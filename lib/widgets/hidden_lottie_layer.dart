import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import '../core/constants/app_constants.dart';

class HiddenLottieLayer extends StatelessWidget {
  final bool isDark;

  const HiddenLottieLayer({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // High-resolution background texture
        Opacity(
          opacity: isDark ? 0.08 : 0.05,
          child: Image.asset(
            isDark ? AppConstants.bgDark : AppConstants.bgLight,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ),

        // Hidden Lottie animation layer (very subtle ambient motion)
        Positioned.fill(
          child: Opacity(
            opacity: 0.04,
            child: IgnorePointer(
              child: Lottie.asset(
                AppConstants.lottieParticles,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
