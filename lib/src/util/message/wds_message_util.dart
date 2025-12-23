import 'dart:async';

import 'package:flutter/material.dart' show Material, MaterialType;
import 'package:flutter/widgets.dart';
import 'package:wds_components/wds_components.dart'
    show WdsSnackbar, WdsToast, WdsSectionMessage;

/// [WdsSnackbar], [WdsToast], [WdsSectionMessage]의
/// 생명주기를 관리하는 컨트롤러
class WdsMessageController {
  WdsMessageController(this._entry, [this._timer]);

  final OverlayEntry _entry;

  final Timer? _timer;

  bool _isDismissed = false;

  /// 위젯을 제거
  void dismiss() {
    if (_isDismissed) return;
    _isDismissed = true;
    try {
      _timer?.cancel();
      _entry.remove();
    } catch (_) {}
  }
}

extension WdsMessageUtilExtension on BuildContext {
  /// [WdsSnackbar], [WdsToast], [WdsSectionMessage]를 표시
  ///
  /// 위젯을 파라미터로 받아서 표시
  /// WdsSnackbar, WdsToast, WdsSectionMessage 중 하나여야 하며,
  /// 그 외의 위젯이 전달되면 assert 오류가 발생
  ///
  /// [duration]이 제공되면 해당 시간 후 자동으로 제거
  /// [bottomOffset]은 하단에서의 오프셋을 지정
  /// [dismissOnTapOutside]가 true면 위젯 외부 탭 시 dismiss
  ///
  /// 예시:
  /// ```dart
  /// final controller = context.onMessage(
  ///   WdsSnackbar.multiLine(message: '메시지'),
  ///   duration: const Duration(seconds: 3),
  /// );
  ///
  WdsMessageController onMessage(
    Widget widget, {
    Duration duration = const Duration(seconds: 3),
    double bottomOffset = 80,
    bool dismissOnTapOutside = true,
  }) {
    assert(
      widget is WdsSnackbar ||
          widget is WdsToast ||
          widget is WdsSectionMessage,
      'widget은 WdsSnackbar, WdsToast, WdsSectionMessage 중 하나여야 합니다.',
    );

    final overlay = Overlay.of(this, rootOverlay: true);

    final overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          left: false,
          right: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: bottomOffset,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 화면 너비에 따라 최소 너비 결정
                  /// 데스크탑/태블릿: 최대 420px, 모바일: 최대 너비
                  /// 최대 420px인 이유는 윙크 웹 max-width가 420px이기 때문
                  ///
                  final minWidth = constraints.maxWidth > 600
                      ? 420.0
                      : constraints.maxWidth;

                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: minWidth,
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: widget,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    Timer? timer;
    timer = Timer(duration, () {
      try {
        overlayEntry.remove();
      } catch (_) {}
    });

    return WdsMessageController(overlayEntry, timer);
  }
}
