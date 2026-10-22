#!/bin/bash

# wds_flutter lockstep version bump
# Usage: ./tools/bump_version.sh <version>   # 지정한 버전으로 전체 패키지 버전 변경
#        ./tools/bump_version.sh --check     # 전체 패키지 버전이 일치하는지 확인

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# lockstep 으로 함께 버전을 올리는 패키지 (tools/ 는 배포 대상이 아니므로 제외)
PUBSPECS=(
    "pubspec.yaml"
    "packages/tokens/pubspec.yaml"
    "packages/foundation/pubspec.yaml"
    "packages/components/pubspec.yaml"
    "packages/widgetbook/pubspec.yaml"
)

read_version() {
    grep -m1 -E '^version:' "$ROOT_DIR/$1" | sed -E 's/^version:[[:space:]]*//'
}

check_versions() {
    local expected
    expected="$(read_version "${PUBSPECS[0]}")"
    local mismatch=false
    for pubspec in "${PUBSPECS[@]}"; do
        local version
        version="$(read_version "$pubspec")"
        if [[ "$version" != "$expected" ]]; then
            echo -e "${RED}❌ $pubspec: $version (expected $expected)${NC}"
            mismatch=true
        fi
    done
    if ! grep -q -E "^### ${expected//./\\.}\$" "$ROOT_DIR/CHANGELOG.md"; then
        echo -e "${RED}❌ CHANGELOG.md 에 '### $expected' 항목이 없습니다${NC}"
        mismatch=true
    fi
    if [[ "$mismatch" == true ]]; then
        exit 1
    fi
    echo -e "${GREEN}✅ 모든 패키지 버전이 $expected 로 일치합니다${NC}"
}

if [[ "$1" == "--check" ]]; then
    check_versions
    exit 0
fi

NEW_VERSION="$1"
if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Usage: $0 <major.minor.patch> | --check"
    exit 1
fi

for pubspec in "${PUBSPECS[@]}"; do
    perl -pi -e "s/^version:.*/version: $NEW_VERSION/ if /^version:/ && !\$done++" "$ROOT_DIR/$pubspec"
    echo "  $pubspec -> $NEW_VERSION"
done

if ! grep -q -E "^### ${NEW_VERSION//./\\.}\$" "$ROOT_DIR/CHANGELOG.md"; then
    echo -e "${RED}⚠️  CHANGELOG.md 맨 위에 '### $NEW_VERSION' 항목을 추가해주세요${NC}"
fi
