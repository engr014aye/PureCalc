import 'package:flutter/cupertino.dart';
import '../core/utils/expression_evaluator.dart';
import '../core/utils/haptic_feedback_helper.dart';
import '../data/database/history_database_helper.dart';
import '../data/models/calculation_record.dart';

class CalculatorController extends ChangeNotifier {
  String _expression = '0';
  String _liveResult = '';
  bool _isResultEvaluated = false;
  List<CalculationRecord> _history = [];
  bool _isLoadingHistory = false;

  String get expression => _expression;
  String get liveResult => _liveResult;
  bool get isResultEvaluated => _isResultEvaluated;
  List<CalculationRecord> get history => _history;
  bool get isLoadingHistory => _isLoadingHistory;

  CalculatorController() {
    loadHistory();
  }

  Future<void> loadHistory() async {
    _isLoadingHistory = true;
    notifyListeners();
    try {
      _history = await HistoryDatabaseHelper.instance.getAllRecords();
    } catch (_) {}
    _isLoadingHistory = false;
    notifyListeners();
  }

  void inputDigit(String digit) {
    HapticFeedbackHelper.buttonTap();
    if (_isResultEvaluated) {
      _expression = digit;
      _isResultEvaluated = false;
    } else {
      if (_expression == '0') {
        _expression = digit;
      } else {
        _expression += digit;
      }
    }
    _updateLiveResult();
    notifyListeners();
  }

  void inputOperator(String op) {
    HapticFeedbackHelper.operatorTap();
    _isResultEvaluated = false;

    if (_expression.isEmpty) {
      _expression = '0 $op ';
      notifyListeners();
      return;
    }

    final trimmed = _expression.trimRight();
    final lastChar = trimmed.substring(trimmed.length - 1);

    if (['+', '−', '×', '÷'].contains(lastChar)) {
      // Replace existing operator
      _expression = '${trimmed.substring(0, trimmed.length - 1)}$op ';
    } else {
      _expression = '$trimmed $op ';
    }

    _updateLiveResult();
    notifyListeners();
  }

  void inputDecimal() {
    HapticFeedbackHelper.buttonTap();
    if (_isResultEvaluated) {
      _expression = '0.';
      _isResultEvaluated = false;
      notifyListeners();
      return;
    }

    // Check if the current trailing number already has a decimal
    final parts = _expression.split(RegExp(r'[ +−×÷()]'));
    final lastPart = parts.isNotEmpty ? parts.last : '';
    if (!lastPart.contains('.')) {
      if (lastPart.isEmpty) {
        _expression += '0.';
      } else {
        _expression += '.';
      }
    }
    _updateLiveResult();
    notifyListeners();
  }

  void inputPercent() {
    HapticFeedbackHelper.operatorTap();
    if (_expression.isNotEmpty && !_expression.endsWith('%')) {
      _expression += '%';
      _isResultEvaluated = false;
      _updateLiveResult();
      notifyListeners();
    }
  }

  void inputParentheses() {
    HapticFeedbackHelper.buttonTap();
    if (_isResultEvaluated) {
      _expression = '(';
      _isResultEvaluated = false;
      notifyListeners();
      return;
    }

    if (_expression == '0') {
      _expression = '(';
      notifyListeners();
      return;
    }

    int openCount = 0;
    int closeCount = 0;
    for (int i = 0; i < _expression.length; i++) {
      if (_expression[i] == '(') openCount++;
      if (_expression[i] == ')') closeCount++;
    }

    final lastChar = _expression.trimRight().characters.lastOrNull ?? '';
    final isDigitOrClose = RegExp(r'[0-9)%]').hasMatch(lastChar);

    if (openCount > closeCount && isDigitOrClose) {
      _expression += ')';
    } else {
      if (isDigitOrClose) {
        _expression += ' × (';
      } else {
        _expression += '(';
      }
    }

    _updateLiveResult();
    notifyListeners();
  }

  void toggleSign() {
    HapticFeedbackHelper.buttonTap();
    if (_expression == '0') return;

    if (_isResultEvaluated) {
      if (_expression.startsWith('-')) {
        _expression = _expression.substring(1);
      } else {
        _expression = '-$_expression';
      }
      notifyListeners();
      return;
    }

    // Find the last number token in the expression
    final regExp = RegExp(r'(-?\d+(?:\.\d+)?)$');
    final match = regExp.firstMatch(_expression);

    if (match != null) {
      final token = match.group(1)!;
      final start = match.start;
      String replacement;
      if (token.startsWith('-')) {
        replacement = token.substring(1);
      } else {
        replacement = '-$token';
      }
      _expression = _expression.substring(0, start) + replacement;
      _updateLiveResult();
      notifyListeners();
    }
  }

  void backspace() {
    HapticFeedbackHelper.buttonTap();
    if (_isResultEvaluated) {
      _expression = '0';
      _liveResult = '';
      _isResultEvaluated = false;
      notifyListeners();
      return;
    }

    if (_expression.length <= 1) {
      _expression = '0';
      _liveResult = '';
    } else {
      String trimmed = _expression.trimRight();
      // If ends with operator space
      if (trimmed.length < _expression.length) {
        _expression = trimmed;
      } else {
        _expression = _expression.substring(0, _expression.length - 1).trimRight();
      }
      if (_expression.isEmpty) _expression = '0';
    }

    _updateLiveResult();
    notifyListeners();
  }

  void clear() {
    HapticFeedbackHelper.clearTap();
    _expression = '0';
    _liveResult = '';
    _isResultEvaluated = false;
    notifyListeners();
  }

  Future<void> evaluateAndSave() async {
    if (_isResultEvaluated) return;

    final trimmed = _expression.trim();
    final evaluatedValue = ExpressionEvaluator.tryEvaluate(trimmed);

    if (evaluatedValue == null) {
      HapticFeedbackHelper.errorTap();
      return;
    }

    HapticFeedbackHelper.equalsTap();
    final formattedResult = ExpressionEvaluator.formatNumber(evaluatedValue);

    // Save invisibly to SQLite database
    final record = CalculationRecord(
      expression: trimmed,
      result: formattedResult,
      timestamp: DateTime.now(),
    );

    // Run quietly in background
    HistoryDatabaseHelper.instance.insertRecord(record).then((_) {
      loadHistory();
    });

    _expression = formattedResult;
    _liveResult = '';
    _isResultEvaluated = true;
    notifyListeners();
  }

  void _updateLiveResult() {
    final trimmed = _expression.trim();
    if (trimmed == '0' || trimmed.isEmpty) {
      _liveResult = '';
      return;
    }

    // Only show live preview if there's an operator or brackets
    if (!RegExp(r'[+−×÷%]').hasMatch(trimmed)) {
      _liveResult = '';
      return;
    }

    final val = ExpressionEvaluator.tryEvaluate(trimmed);
    if (val != null) {
      _liveResult = ExpressionEvaluator.formatNumber(val);
    } else {
      _liveResult = '';
    }
  }

  void selectHistoryRecord(CalculationRecord record, {bool reuseResult = true}) {
    HapticFeedbackHelper.buttonTap();
    _expression = reuseResult ? record.result : record.expression;
    _isResultEvaluated = reuseResult;
    _liveResult = '';
    notifyListeners();
  }

  Future<void> deleteHistoryItem(int id) async {
    await HistoryDatabaseHelper.instance.deleteRecord(id);
    await loadHistory();
  }

  Future<void> clearHistory() async {
    HapticFeedbackHelper.clearTap();
    await HistoryDatabaseHelper.instance.clearAll();
    await loadHistory();
  }
}
