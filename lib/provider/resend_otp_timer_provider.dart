import 'dart:async';

import 'package:flutter/material.dart';

class ResendTimerProvider with ChangeNotifier {
  bool isResendVisible = false;
  Timer? resendTimer;
  int remainingSeconds = 0;

  late Timer _timer;
  int _remainingSeconds = 60;

  int get bidTimer => _remainingSeconds;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer.cancel();
        _remainingSeconds = 60;
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    if (_timer.isActive) {
      _timer.cancel();
      _remainingSeconds = 60;
    }
    notifyListeners();
  }

  void startResendTimer() {
    const resendDelay = Duration(seconds: 120);
    remainingSeconds = resendDelay.inSeconds;
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        isResendVisible = true;
        if (resendTimer != null) {
          resendTimer!.cancel();
          notifyListeners();
        }
      }
    });
    notifyListeners();
  }

  void stopResendTimer() {
    if (resendTimer != null) {
      resendTimer!.cancel();

      notifyListeners();
    }
  }

  void switchResendVisible(bool value) {
    isResendVisible = value;
    notifyListeners();
  }
}
