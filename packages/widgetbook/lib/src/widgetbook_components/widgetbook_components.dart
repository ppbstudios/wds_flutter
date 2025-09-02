library;

import 'dart:math' as math;

import 'package:flutter/material.dart' hide Typography, Icon, Chip, Switch;
import 'package:wds_foundation/wds_foundation.dart';

export 'package:flutter/material.dart' hide Typography, TextButton, TextField;
export 'package:wds_components/wds_components.dart';
export 'package:wds_foundation/wds_foundation.dart';

part 'page_layout.dart';
part 'playground.dart';
part 'section.dart';
part 'theme.dart';
part 'title.dart';

/// 컴포넌트 path 관리를 위한 클래스
class Button {}

/// 컴포넌트 path 관리를 위한 클래스
class TextButton {}

/// 컴포넌트 path 관리를 위한 클래스
///
/// material 에서 Typography 는 hidden 처리
class Typography {}

/// 컴포넌트 path 관리를 위한 클래스
class Icon {}

/// 컴포넌트 path 관리를 위한 클래스
class Cover {}

/// 컴포넌트 path 관리를 위한 클래스
class SquareButton {}

/// 컴포넌트 path 관리를 위한 클래스
class IconButton {}

/// 컴포넌트 path 관리를 위한 클래스
class Header {}

/// 컴포넌트 path 관리를 위한 클래스
class BottomNavigation {}

/// 컴포넌트 path 관리를 위한 클래스
class SearchField {}

/// 컴포넌트 path 관리를 위한 클래스
class TextField {}

/// 컴포넌트 path 관리를 위한 클래스
class Chip {}

/// 컴포넌트 path 관리를 위한 클래스
/// material 의 Tab 과 충돌을 피하기 위해 Tabs 로 명명
class Tabs {}

/// 컴포넌트 path 관리를 위한 클래스
class Select {}

/// 컴포넌트 path 관리를 위한 클래스
class ActionArea {}

/// 컴포넌트 path 관리를 위한 클래스
class Switch {}

/// 컴포넌트 path 관리를 위한 클래스
class Checkbox {}

/// 컴포넌트 path 관리를 위한 클래스
class Radio {}

/// 컴포넌트 path 관리를 위한 클래스
class Toast {}
