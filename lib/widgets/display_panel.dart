import 'package:flutter/cupertino.dart';
import '../core/constants/app_constants.dart';

class DisplayPanel extends StatelessWidget {
  final String expression;
  final String liveResult;
  final bool isDark;
  final VoidCallback onSwipeBackspace;

  const DisplayPanel({
    super.key,
    required this.expression,
    required this.liveResult,
    required this.isDark,
    required this.onSwipeBackspace,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic font sizing based on length of expression
    double fontSize = 64;
    if (expression.length > 9) {
      fontSize = 48;
    }
    if (expression.length > 14) {
      fontSize = 36;
    }
    if (expression.length > 20) {
      fontSize = 28;
    }

    final textColor = isDark ? CupertinoColors.white : CupertinoColors.black;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity!.abs() > 100) {
          onSwipeBackspace();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Live calculated preview if typing multi-step expression
            if (liveResult.isNotEmpty)
              AnimatedOpacity(
                opacity: liveResult.isNotEmpty ? 0.85 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '= $liveResult',
                    style: const TextStyle(
                      fontFamily: AppConstants.fontFamilyInter,
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                      color: AppColors.orangeAccent,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

            // Main Active Expression Display
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                expression,
                style: TextStyle(
                  fontFamily: AppConstants.fontFamilyInter,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w300,
                  color: textColor,
                  letterSpacing: -1.0,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
