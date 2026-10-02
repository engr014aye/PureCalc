import 'package:flutter/cupertino.dart';
import '../controllers/calculator_controller.dart';
import '../core/constants/app_constants.dart';
import 'calc_button.dart';

class Keypad extends StatelessWidget {
  final CalculatorController controller;
  final bool isDark;

  const Keypad({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final hasInput = controller.expression != '0' && controller.expression.isNotEmpty;
    final clearLabel = hasInput && !controller.isResultEvaluated ? AppConstants.keyClear : AppConstants.keyAllClear;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Clear, Parentheses, Percent, Divide
          Row(
            children: [
              CalcButton(
                label: clearLabel,
                type: ButtonType.function,
                isDark: isDark,
                onTap: controller.clear,
              ),
              CalcButton(
                label: AppConstants.keyParentheses,
                type: ButtonType.function,
                isDark: isDark,
                onTap: controller.inputParentheses,
              ),
              CalcButton(
                label: AppConstants.keyPercent,
                type: ButtonType.function,
                isDark: isDark,
                onTap: controller.inputPercent,
              ),
              CalcButton(
                label: AppConstants.keyDivide,
                type: ButtonType.operator,
                isDark: isDark,
                onTap: () => controller.inputOperator(AppConstants.keyDivide),
              ),
            ],
          ),

          // Row 2: 7, 8, 9, Multiply
          Row(
            children: [
              CalcButton(
                label: '7',
                type: ButtonType.number,
                isDark: isDark,
                onTap: () => controller.inputDigit('7'),
              ),
              CalcButton(
                label: '8',
                type: ButtonType.number,
                isDark: isDark,
                onTap: () => controller.inputDigit('8'),
              ),
              CalcButton(
                label: '9',
                type: ButtonType.number,
                isDark: isDark,
                onTap: () => controller.inputDigit('9'),
              ),
              CalcButton(
                label: AppConstants.keyMultiply,
                type: ButtonType.operator,
                isDark: isDark,
                onTap: () => controller.inputOperator(AppConstants.keyMultiply),
              ),
            ],
          ),

          // Row 3: 4, 5, 6, Subtract
          Row(
            children: [
              CalcButton(
                label: '4',
                type: ButtonType.number,
                isDark: isDark,
                onTap: () => controller.inputDigit('4'),
              ),
              CalcButton(
                label: '5',
                type: ButtonType.number,
                isDark: isDark,
                onTap: () => controller.inputDigit('5'),
              ),
              CalcButton(
                label: '6',
                type: ButtonType.number,
                isDark: isDark,
                onTap: () => controller.inputDigit('6'),
              ),
              CalcButton(
                label: AppConstants.keySubtract,
                type: ButtonType.operator,
                isDark: isDark,
                onTap: () => controller.inputOperator(AppConstants.keySubtract),
              ),
            ],
          ),

          // Row 4: 1, 2, 3, Add
          Row(
            children: [
              CalcButton(
                label: '1',
                type: ButtonType.number,
                isDark: isDark,
                onTap: () => controller.inputDigit('1'),
              ),
              CalcButton(
                label: '2',
                type: ButtonType.number,
                isDark: isDark,
                onTap: () => controller.inputDigit('2'),
              ),
              CalcButton(
                label: '3',
                type: ButtonType.number,
                isDark: isDark,
                onTap: () => controller.inputDigit('3'),
              ),
              CalcButton(
                label: AppConstants.keyAdd,
                type: ButtonType.operator,
                isDark: isDark,
                onTap: () => controller.inputOperator(AppConstants.keyAdd),
              ),
            ],
          ),

          // Row 5: PlusMinus, 0, Decimal, Equals
          Row(
            children: [
              CalcButton(
                label: AppConstants.keyPlusMinus,
                type: ButtonType.number,
                isDark: isDark,
                onTap: controller.toggleSign,
              ),
              CalcButton(
                label: '0',
                type: ButtonType.number,
                isDark: isDark,
                onTap: () => controller.inputDigit('0'),
              ),
              CalcButton(
                label: AppConstants.keyDecimal,
                type: ButtonType.number,
                isDark: isDark,
                onTap: controller.inputDecimal,
              ),
              CalcButton(
                label: AppConstants.keyEquals,
                type: ButtonType.operator,
                isDark: isDark,
                onTap: controller.evaluateAndSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
