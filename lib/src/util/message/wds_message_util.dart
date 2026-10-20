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

    final overlay = _findRootOverlay();

    final overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          left: false,
          right: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (context, constraints) {
                const fixedWidth = 420.0;
                const horizontalPadding = 16.0;

                // 모바일 크기 내에서는 양옆 padding을 고려한 너비 사용
                // 그보다 큰 경우에는 고정 너비 사용
                final isMobile = constraints.maxWidth <= fixedWidth;
                final availableWidth =
                    constraints.maxWidth - (horizontalPadding * 2);
                final maxWidth = isMobile ? availableWidth : fixedWidth;
                final minWidth = isMobile ? availableWidth : fixedWidth;

                return Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: bottomOffset,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: minWidth,
                      maxWidth: maxWidth,
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: widget,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    // Overlay 를 찾지 못하면 메시지 하나 때문에 앱이 죽지 않도록 띄우지 않고 넘어간다
    if (overlay == null) return WdsMessageController(overlayEntry);

    overlay.insert(overlayEntry);

    Timer? timer;
    timer = Timer(duration, () {
      try {
        overlayEntry.remove();
      } catch (_) {}
    });

    return WdsMessageController(overlayEntry, timer);
  }

  /// [Overlay.maybeOf] 는 OverlayEntry 아래에서만 Overlay 를 찾으므로
  /// `navigatorKey.currentState.overlay.context` 처럼 [OverlayState] 자신의 context 가
  /// 들어오면 null 이 된다. 그 경우 조상 Overlay 가 없으면 자신을 root 로 쓴다.
  OverlayState? _findRootOverlay() {
    final overlay = Overlay.maybeOf(this, rootOverlay: true);
    if (overlay != null) return overlay;

    final self = this;
    if (self is StatefulElement && self.state is OverlayState) {
      return self.state as OverlayState;
    }

    return null;
  }
}
