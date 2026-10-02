import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:purecalc/controllers/calculator_controller.dart';
import 'package:purecalc/controllers/theme_controller.dart';
import 'package:purecalc/core/utils/expression_evaluator.dart';
import 'package:purecalc/main.dart';

void main() {
  test('ExpressionEvaluator basic arithmetic', () {
    expect(ExpressionEvaluator.evaluate('2 + 3 × 4'), 14.0);
    expect(ExpressionEvaluator.evaluate('(10 + 20) ÷ 2'), 15.0);
    expect(ExpressionEvaluator.evaluate('50%'), 0.5);
    expect(ExpressionEvaluator.formatNumber(1250000), '1,250,000');
  });

  testWidgets('PureCalcApp renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeController()),
          ChangeNotifierProvider(create: (_) => CalculatorController()),
        ],
        child: const PureCalcApp(),
      ),
    );

    // Initial display should show 0
    expect(find.text('0'), findsWidgets);
    // Equals button
    expect(find.text('='), findsOneWidget);
  });
}
