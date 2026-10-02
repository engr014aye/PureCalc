import 'package:flutter/cupertino.dart';
import '../core/constants/app_constants.dart';

enum ButtonType {
  number,
  function,
  operator,
  accent,
}

class CalcButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final ButtonType type;
  final VoidCallback onTap;
  final bool isDark;
  final int flex;

  const CalcButton({
    super.key,
    required this.label,
    this.icon,
    required this.type,
    required this.onTap,
    required this.isDark,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (type) {
      case ButtonType.operator:
      case ButtonType.accent:
        bgColor = AppColors.orangeAccent;
        textColor = CupertinoColors.white;
        break;
      case ButtonType.function:
        bgColor = isDark
            ? const Color(0xFFA5A5A5)
            : const Color(0xFFD4D4D8);
        textColor = isDark ? CupertinoColors.black : const Color(0xFF1C1C1E);
        break;
      case ButtonType.number:
        bgColor = isDark
            ? const Color(0xFF2C2C2E)
            : const Color(0xFFE5E5EA);
        textColor = isDark ? CupertinoColors.white : CupertinoColors.black;
        break;
    }

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: AspectRatio(
          aspectRatio: flex == 1 ? 1.15 : (flex * 1.1),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            color: bgColor,
            borderRadius: BorderRadius.circular(100),
            pressedOpacity: 0.75,
            onPressed: onTap,
            child: icon ??
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppConstants.fontFamilyInter,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    letterSpacing: -0.5,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
