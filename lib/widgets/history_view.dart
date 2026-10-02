import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../controllers/calculator_controller.dart';
import '../core/constants/app_constants.dart';

class HistoryView extends StatelessWidget {
  final CalculatorController controller;
  final bool isDark;

  const HistoryView({
    super.key,
    required this.controller,
    required this.isDark,
  });

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);
    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(dt);
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${DateFormat('h:mm a').format(dt)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = isDark ? CupertinoColors.white : CupertinoColors.black;
    final secondaryTextColor = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6C6C70);
    final cardBg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFFFFFFF);
    final separatorColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'History',
          style: TextStyle(
            fontFamily: AppConstants.fontFamilyInter,
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        ),
        trailing: controller.history.isNotEmpty
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (ctx) => CupertinoAlertDialog(
                      title: const Text('Clear History'),
                      content: const Text('Are you sure you want to clear your calculation history?'),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Cancel'),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            controller.clearHistory();
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontFamily: AppConstants.fontFamilyInter,
                    color: CupertinoColors.destructiveRed,
                    fontSize: 16,
                  ),
                ),
              )
            : null,
      ),
      child: SafeArea(
        child: controller.history.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.clock,
                      size: 54,
                      color: secondaryTextColor.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Calculation History',
                      style: TextStyle(
                        fontFamily: AppConstants.fontFamilyInter,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Previous calculations will appear here.',
                      style: TextStyle(
                        fontFamily: AppConstants.fontFamilyInter,
                        fontSize: 14,
                        color: secondaryTextColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                // STRICT REQUIREMENT: Forced BouncingScrollPhysics
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: controller.history.length,
                separatorBuilder: (context, index) => Container(
                  height: 0.5,
                  color: separatorColor,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
                itemBuilder: (context, index) {
                  final record = controller.history[index];
                  return Dismissible(
                    key: Key('record_${record.id ?? index}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: CupertinoColors.destructiveRed,
                      child: const Icon(
                        CupertinoIcons.delete,
                        color: CupertinoColors.white,
                        size: 22,
                      ),
                    ),
                    onDismissed: (_) {
                      if (record.id != null) {
                        controller.deleteHistoryItem(record.id!);
                      }
                    },
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        controller.selectHistoryRecord(record);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatTimestamp(record.timestamp),
                                  style: TextStyle(
                                    fontFamily: AppConstants.fontFamilyInter,
                                    fontSize: 12,
                                    color: secondaryTextColor,
                                  ),
                                ),
                                Icon(
                                  CupertinoIcons.arrow_up_left,
                                  size: 14,
                                  color: secondaryTextColor.withValues(alpha: 0.6),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              record.expression,
                              style: TextStyle(
                                fontFamily: AppConstants.fontFamilyInter,
                                fontSize: 16,
                                color: secondaryTextColor,
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '= ${record.result}',
                              style: TextStyle(
                                fontFamily: AppConstants.fontFamilyInter,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColors.orangeAccent,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
