import 'dart:async';

import 'package:flutter/material.dart' show Material, MaterialType;
import 'package:flutter/widgets.dart';
import 'package:wds_components/wds_components.dart' show WdsToast;
import 'package:wds_foundation/wds_foundation.dart' show WdsIcon;

class WdsToastController {
  WdsToastController(this._entry, [this._timer]);

  final OverlayEntry _entry;
  final Timer? _timer;
  bool _isDismissed = false;

  void dismiss() {
    if (_isDismissed) return;
    _isDismissed = true;
    try {
      _timer?.cancel();
      _entry.remove();
    } catch (_) {}
  }
}

extension WdsToastContextExt on BuildContext {
  WdsToastController showWdsToastText(
    String message, {
    Duration duration = const Duration(milliseconds: 2000),
    double bottomOffset = 80,
  }) {
    return _showWdsToast(
      child: WdsToast.text(message: message),
      duration: duration,
      bottomOffset: bottomOffset,
    );
  }

  WdsToastController showWdsToastIcon(
    String message, {
    required WdsIcon icon,
    Duration duration = const Duration(milliseconds: 2000),
    double bottomOffset = 80,
  }) {
    return _showWdsToast(
      child: WdsToast.icon(message: message, leadingIcon: icon),
      duration: duration,
      bottomOffset: bottomOffset,
    );
  }

  WdsToastController _showWdsToast({
    required Widget child,
    required Duration duration,
    required double bottomOffset,
  }) {
    final OverlayState overlay = Overlay.of(this, rootOverlay: true);

    final OverlayEntry entry = OverlayEntry(
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          left: false,
          right: false,
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomOffset),
                child: Material(
                  type: MaterialType.transparency,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);

    final Timer timer = Timer(duration, () {
      try {
        entry.remove();
      } catch (_) {}
    });

    return WdsToastController(entry, timer);
  }
}
