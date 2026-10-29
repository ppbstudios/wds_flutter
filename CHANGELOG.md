### 0.0.24
- WdsTag > 고정 Tag 색을 Figma(node 5050-7799)에 맞춤
  - `$soldOut`: coolNeutral300 채움 + white 글자 → neutral/50 배경 + text/neutral 글자 (종료⋅완료)
  - `$myPower` · `$upto2days`: neutral/50 배경 → white 배경 + border/neutral 테두리 (정보 속성)
  - `$barodrim`: 변경 없음. 윙크 primary(blue/400, #5B7BF3) 유지
- Widgetbook > Tag 에 고정 Tag 섹션 추가

### 0.0.23
- WdsIcon > 기존 info(느낌표) 아이콘을 alert / alertFilled로 이름 변경 (모양 동일)
- WdsIcon > 새 i 아이콘을 info / infoFilled로 추가
- WdsSectionMessage.warning > leadingIcon을 WdsIcon.alert로 변경 (normal / highlight는 info 유지)

### 0.0.22
- onMessage > OverlayState 자신의 context(`navigatorKey.currentState.overlay.context`)로 호출해도 토스트가 뜨도록 수정
- onMessage > Overlay 를 찾지 못하면 null check 크래시 대신 메시지를 띄우지 않고 넘어가도록 변경

### 0.0.21
- WdsIcon > 불투명 color 지정 시 colorFilter(srcIn) 대신 ColorMapper로 파싱 단계에서 색을 입혀 아이콘마다 생기던 saveLayer 제거 (Impeller raster 비용 감소)
- WdsIcon > 반투명 color는 기존 colorFilter 유지, color 미지정 시 동작 변경 없음

### 0.0.20
- WdsThumbnail > imageProvider 추가 (외부 ImageProvider 주입, 미주입 시 기존 CachedNetworkImage 유지)
- WdsItemCard > thumbnailImageProvider, lensPatternImageProvider 추가
- Widgetbook > Thumbnail Asset 예시 이미지 누락 수정

### 0.0.19
- WDSSearchField > WdsSearchFieldSize별 FontSize 세분화 진행

### 0.0.17

- WdsButton > isEnabled → isActive로 변경 (버튼 항상 누를 수 있도록, inactive 상태에서도 onTap 콜백 호출)

### 0.0.16
- WdsSheet.draggable > Header에 backgroundColor 영역은 별도로 받을 수 있게끔 추가

### 0.0.14

- WdsSliverHeader.logo에 외부 로고 탭 콜백 추가

### 0.0.13

- WdsSlider > start, end clamp 함수 추가

### 0.0.12

- WdsOption > WdsOptionVaraint.normal 추가
- WdsButton > widget.child > Text.rich 대응 로직 추가

### 0.0.11

- 메세지 UI (WdsToast, WdsSnackbar, WdsSectionMessage) 공통 컨트롤러 도입
- WdsHeader.search > widthFactor 수정
- WdsChip > leading 형변환 (WdsIcon > Widget)

### 0.0.10

- WdsTextArea > 최소 높이 60px / 최대 높이 320px 대응될 수 있게끔 개선
- WdsTextArea > 'label' 파라미터 String에서 Text로 형변환

### 0.0.9

- WdsToolTip > 'message'에서 'label'로 변경
- WdsToolTip > 'message' 파라미터 String에서 Text로 형변환
- WdsChip > outline 'backgroundColor' > WdsColors.white로 변경
- WdsIcon > barcode 아이콘 추가

### 0.0.8

- WdsThumbnail 내 placeholder 에서 icon 제거
- WdsTextField > keyboardType & inputFormatters 파라미터로 받을 수 있게끔 추가
- WdsTag > '바로드림' 태그 배경색과 글자색 변경
- WdsToolTip > 제한해둔 최대 라인 삭제

### 0.0.7

- WdsItemCard > xsmall에서 small로 명칭 수정
- WdsItemCard > \_\_LikeButton 내 LikeCount 존재 시, 고정 사이즈로 지정
- WdsHeading > moreTextButton 내 Varaint를 Custom할 수 있게끔 수정
- WdsTag > 'NEW' Tag > 배경색 수정

### 0.0.6

- WdsIcon > circle 추가
- WdsTextArea > helper, error 삭제 및 counter 노출 위치 수정
- WdsActionArea > border 노출 여부
- WdsSheet > 시트 내 Header, ActionArea로 위젯 전환

### 0.0.5

- WdsMaterialTabController, WdsMaterialTextTabBar, WdsMaterialLineTabBar 추가

### 0.0.4

- PaginationCount small/medium 사이즈 세분화
- SegmentedControl state별 폰트 사이즈 변경
- ItemCards size별 textStyle/spacing 변경

### 0.0.3

- WdsSliverDivider 추가

### 0.0.2

- WdsSliverHeader 추가
- WdsHeader 에 safeArea 속성 추가

### 0.0.1+2

- typography 내 line-height 변경
- WdsTextButton, small의 typography 변경
