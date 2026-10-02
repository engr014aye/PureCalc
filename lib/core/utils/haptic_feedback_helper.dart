import 'package:flutter/services.dart';

class HapticFeedbackHelper {
  static void buttonTap() {
    HapticFeedback.lightImpact();
  }

  static void operatorTap() {
    HapticFeedback.mediumImpact();
  }

  static void equalsTap() {
    HapticFeedback.heavyImpact();
  }

  static void clearTap() {
    HapticFeedback.selectionClick();
  }

  static void errorTap() {
    HapticFeedback.vibrate();
  }
}
