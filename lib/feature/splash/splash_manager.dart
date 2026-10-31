import 'dart:async';

import 'package:flutter/foundation.dart';

/// Owns the splash auto-navigation delay. Cancel via [dispose].
class SplashManager {
  SplashManager({
    this.onSplashFinished,
    this.duration = const Duration(seconds: 2),
  });

  final VoidCallback? onSplashFinished;
  final Duration duration;

  Timer? _timer;

  void start() {
    _timer?.cancel();
    _timer = Timer(duration, () {
      onSplashFinished?.call();
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
