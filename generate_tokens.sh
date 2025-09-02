#!/bin/bash

# wds_flutter Design Token Generator Script
# Usage: ./generate_tokens.sh [atomic|semantic|all] [options]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
TOKEN_TYPE="all"
VERBOSE=false
SYNC=true
BASE_FONT_SIZE="16.0"
INPUT_DIR="./tokens"
OUTPUT_DIR="./packages/tokens"
GENERATOR_PATH="./tools/token_generator/bin/main.dart"

# Help function
show_help() {
    echo -e "${BLUE}wds_flutter Design Token Generator${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS] [TOKEN_TYPE]"
    echo ""
    echo "TOKEN_TYPE:"
    echo "  atomic     Generate atomic tokens only"
    echo "  semantic   Generate semantic tokens only"
    echo "  all        Generate all tokens: atomic → semantic (default)"
    echo ""
    echo "OPTIONS:"
    echo "  -h, --help              Show this help message"
    echo "  -v, --verbose           Enable verbose output"
    echo "  -n, --no-sync           Disable output directory synchronization"
    echo "  -b, --base-font-size    Base font size for letterSpacing calculation (default: 16.0)"
    echo "  -i, --input-dir         Input directory containing JSON files (default: ./tokens)"
    echo "  -o, --output-dir        Output directory for generated tokens (default: ./packages/tokens)"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Generate all tokens (atomic → semantic)"
    echo "  $0 atomic                             # Generate atomic tokens only"
    echo "  $0 semantic                           # Generate semantic tokens only"
    echo "  $0 -v semantic                        # Generate semantic tokens with verbose output"
    echo "  $0 --base-font-size 18.0 semantic    # Generate semantic tokens with custom base font size"
    echo ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        atomic|semantic|all)
            TOKEN_TYPE="$1"
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -n|--no-sync)
            SYNC=false
            shift
            ;;
        -b|--base-font-size)
            BASE_FONT_SIZE="$2"
            shift 2
            ;;
        -i|--input-dir)
            INPUT_DIR="$2"
            shift 2
            ;;
        -o|--output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Validate input directory
if [[ ! -d "$INPUT_DIR" ]]; then
    echo -e "${RED}Error: Input directory '$INPUT_DIR' does not exist${NC}"
    exit 1
fi

# Validate generator path
if [[ ! -f "$GENERATOR_PATH" ]]; then
    echo -e "${RED}Error: Token generator not found at '$GENERATOR_PATH'${NC}"
    exit 1
fi

# Build command options
VERBOSE_OPT=""
if [[ "$VERBOSE" == true ]]; then
    VERBOSE_OPT="-v"
fi

SYNC_OPT=""
if [[ "$SYNC" == false ]]; then
    SYNC_OPT="--no-sync"
fi

# Function to generate tokens
generate_tokens() {
    local type=$1
    local json_file=""
    local out_dir_used="${OUTPUT_DIR}"
    
    case $type in
        atomic)
            json_file="$INPUT_DIR/design_system_atomic.json"
            if [[ ! -f "$json_file" ]]; then
                echo -e "${RED}Error: Atomic JSON file not found: $json_file${NC}"
                return 1
            fi
            echo -e "${BLUE}Generating atomic tokens from: $json_file${NC}"
            ;;
        semantic)
            json_file="$INPUT_DIR/design_system_semantic.json"
            if [[ ! -f "$json_file" ]]; then
                echo -e "${RED}Error: Semantic JSON file not found: $json_file${NC}"
                return 1
            fi
            echo -e "${BLUE}Generating semantic tokens from: $json_file${NC}"
            ;;
        *)
            echo -e "${RED}Unknown token type: $type${NC}"
            return 1
            ;;
    esac
    
    # Ensure output directory exists for the selected type
    if [[ ! -d "$out_dir_used" ]]; then
        echo -e "${RED}Error: Output directory '$out_dir_used' does not exist${NC}"
        return 1
    fi

    local cmd="dart run $GENERATOR_PATH -i $json_file -o $out_dir_used -k $type --base-font-size $BASE_FONT_SIZE $VERBOSE_OPT $SYNC_OPT"
    
    echo -e "${YELLOW}Executing: $cmd${NC}"
    echo ""
    
    if eval $cmd; then
        echo -e "${GREEN}✓ Successfully generated $type tokens${NC}"
        # brief delay to avoid race conditions between sequential generations
        sleep 0.5
    else
        echo -e "${RED}✗ Failed to generate $type tokens${NC}"
        return 1
    fi
}

# Main execution
echo -e "${BLUE}=== wds_flutter Design Token Generator ===${NC}"
echo ""

case $TOKEN_TYPE in
    atomic)
        generate_tokens "atomic"
        ;;
    semantic)
        generate_tokens "semantic"
        ;;
    all)
        echo -e "${BLUE}Generating all tokens (atomic → semantic)...${NC}"
        echo ""
        generate_tokens "atomic"
        echo ""
        generate_tokens "semantic"
        ;;
esac

fvm exec melos run format

echo ""
echo -e "${GREEN}Token generation completed!${NC}"
