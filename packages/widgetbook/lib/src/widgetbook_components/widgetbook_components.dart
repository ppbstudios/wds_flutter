library;

import 'dart:math' as math;

import 'package:flutter/material.dart'
    hide Typography, Icon, Chip, Switch, Divider;
import 'package:wds_components/wds_components.dart';
import 'package:wds_foundation/wds_foundation.dart';

export 'package:flutter/material.dart' hide Typography, TextButton, TextField;
export 'package:wds_components/wds_components.dart';
export 'package:wds_foundation/wds_foundation.dart';

part 'page_layout.dart';
part 'playground.dart';
part 'section.dart';
part 'theme.dart';
part 'title.dart';

class Button {}

class TextButton {}

/// material 에서 Typography 는 hidden 처리
class Typography {}

class Icon {}

class Cover {}

class ItemCard {}

class SquareButton {}

class IconButton {}

class Header {}

class Heading {}

class BottomNavigation {}

class SearchField {}

class TextField {}

class PaginationDot {}

class PaginationCount {}

class Chip {}

/// material 의 Tab 과 충돌을 피하기 위해 Tabs 로 명명
class Tabs {}

class Select {}

class ActionArea {}

class Switch {}

class Checkbox {}

class Radio {}

class Toast {}

class Snackbar {}

class Tooltip {}

class Divider {}

class DotBadge {}

class SectionMessage {}

class Badge {}

class Sheet {}

class Thumbnail {}

class Tag {}

class Option {}

class Circular {}

class Loading {}

class MenuItem {}

class SegmentedControl {}
