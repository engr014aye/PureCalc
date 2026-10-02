import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../controllers/calculator_controller.dart';
import '../controllers/theme_controller.dart';
import '../core/constants/app_constants.dart';
import '../widgets/display_panel.dart';
import '../widgets/hidden_lottie_layer.dart';
import '../widgets/history_view.dart';
import '../widgets/keypad.dart';
import 'settings_view.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final calcController = Provider.of<CalculatorController>(context);
    final isDark = themeController.isDarkMode;
    final primaryTextColor = isDark ? CupertinoColors.white : CupertinoColors.black;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/images/app_icon_512.png',
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontFamily: AppConstants.fontFamilyInter,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
                color: primaryTextColor,
              ),
            ),
          ],
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => HistoryView(
                  controller: calcController,
                  isDark: isDark,
                ),
              ),
            );
          },
          child: const Icon(
            CupertinoIcons.clock,
            size: 24,
            color: AppColors.orangeAccent,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // Fluid Cupertino page transition to settings
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const SettingsView(),
              ),
            );
          },
          child: const Icon(
            CupertinoIcons.gear_alt,
            size: 24,
            color: AppColors.orangeAccent,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Background texture and hidden Lottie layer
          HiddenLottieLayer(isDark: isDark),

          // Main Calculator UI Content
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    // Top Display with gesture backspace
                    Expanded(
                      child: DisplayPanel(
                        expression: calcController.expression,
                        liveResult: calcController.liveResult,
                        isDark: isDark,
                        onSwipeBackspace: calcController.backspace,
                      ),
                    ),

                    // Tactile Cupertino Keypad
                    Keypad(
                      controller: calcController,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
