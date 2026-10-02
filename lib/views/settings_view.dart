import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_controller.dart';
import '../core/constants/app_constants.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDarkMode;
    final primaryTextColor = isDark ? CupertinoColors.white : CupertinoColors.black;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Settings',
          style: TextStyle(
            fontFamily: AppConstants.fontFamilyInter,
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.black.withValues(alpha: 0.15),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/app_icon_512.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontFamily: AppConstants.fontFamilyInter,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.1',
                    style: TextStyle(
                      fontFamily: AppConstants.fontFamilyInter,
                      fontSize: 13,
                      color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF6C6C70),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CupertinoListSection.insetGrouped(
              header: Text(
                'APPEARANCE',
                style: TextStyle(
                  fontFamily: AppConstants.fontFamilyInter,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF6C6C70),
                ),
              ),
              children: [
            CupertinoListTile(
              leading: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF5E5CE6) : const Color(0xFF007AFF),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(
                  CupertinoIcons.moon_fill,
                  color: CupertinoColors.white,
                  size: 18,
                ),
              ),
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  fontFamily: AppConstants.fontFamilyInter,
                  fontSize: 17,
                  color: primaryTextColor,
                ),
              ),
              subtitle: Text(
                isDark ? 'Dark theme enabled' : 'Light theme enabled',
                style: TextStyle(
                  fontFamily: AppConstants.fontFamilyInter,
                  fontSize: 13,
                  color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF6C6C70),
                ),
              ),
              trailing: CupertinoSwitch(
                value: isDark,
                activeTrackColor: AppColors.orangeAccent,
                onChanged: (val) {
                  themeController.toggleTheme(val);
                },
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);
  }
}
