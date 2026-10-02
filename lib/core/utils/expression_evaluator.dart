import 'package:intl/intl.dart';

class ExpressionEvaluator {
  static final NumberFormat _formatter = NumberFormat('#,##0.########', 'en_US');

  /// Formats a numeric string or double into localized comma-grouped number
  static String formatNumber(double value) {
    if (value.isNaN || value.isInfinite) return 'Error';
    if (value.abs() >= 1e12 || (value.abs() < 1e-7 && value != 0)) {
      return value.toStringAsExponential(6);
    }
    // Remove negative zero
    if (value == 0) return '0';
    return _formatter.format(value);
  }

  /// Evaluates an arithmetic expression string
  /// Supports: +, −, -, ×, *, ÷, /, %, parentheses ()
  static double evaluate(String expression) {
    if (expression.trim().isEmpty) return 0.0;

    String clean = expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll(',', '')
        .trim();

    final parser = _Parser(clean);
    return parser.parse();
  }

  /// Attempts to evaluate expression, returning null if invalid or incomplete
  static double? tryEvaluate(String expression) {
    try {
      final res = evaluate(expression);
      if (res.isNaN || res.isInfinite) return null;
      return res;
    } catch (_) {
      return null;
    }
  }
}

class _Parser {
  final String src;
  int pos = 0;

  _Parser(this.src);

  double parse() {
    double result = _parseExpression();
    _skipWhitespace();
    if (pos < src.length) {
      throw const FormatException("Unexpected trailing characters");
    }
    return result;
  }

  void _skipWhitespace() {
    while (pos < src.length && (src[pos] == ' ' || src[pos] == '\t')) {
      pos++;
    }
  }

  double _parseExpression() {
    double left = _parseTerm();
    while (true) {
      _skipWhitespace();
      if (pos >= src.length) break;
      final char = src[pos];
      if (char == '+') {
        pos++;
        left += _parseTerm();
      } else if (char == '-') {
        pos++;
        left -= _parseTerm();
      } else {
        break;
      }
    }
    return left;
  }

  double _parseTerm() {
    double left = _parseFactor();
    while (true) {
      _skipWhitespace();
      if (pos >= src.length) break;
      final char = src[pos];
      if (char == '*') {
        pos++;
        left *= _parseFactor();
      } else if (char == '/') {
        pos++;
        double right = _parseFactor();
        if (right == 0.0) {
          throw const FormatException("Division by zero");
        }
        left /= right;
      } else if (char == '%') {
        pos++;
        left = left / 100.0;
      } else {
        break;
      }
    }
    return left;
  }

  double _parseFactor() {
    _skipWhitespace();
    if (pos >= src.length) {
      throw const FormatException("Unexpected end of expression");
    }

    // Unary plus/minus
    if (src[pos] == '+') {
      pos++;
      return _parseFactor();
    }
    if (src[pos] == '-') {
      pos++;
      return -_parseFactor();
    }

    // Parentheses
    if (src[pos] == '(') {
      pos++;
      double val = _parseExpression();
      _skipWhitespace();
      if (pos < src.length && src[pos] == ')') {
        pos++;
      }
      // Check trailing % immediately after bracket e.g. (10 + 20)%
      _skipWhitespace();
      if (pos < src.length && src[pos] == '%') {
        pos++;
        val /= 100.0;
      }
      return val;
    }

    // Number literal
    int start = pos;
    bool hasDot = false;
    while (pos < src.length) {
      final c = src[pos];
      if ((c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57)) {
        pos++;
      } else if (c == '.' && !hasDot) {
        hasDot = true;
        pos++;
      } else {
        break;
      }
    }

    if (start == pos) {
      throw FormatException("Expected number at index $pos");
    }

    double value = double.parse(src.substring(start, pos));

    // Check trailing % on number
    _skipWhitespace();
    if (pos < src.length && src[pos] == '%') {
      pos++;
      value /= 100.0;
    }

    return value;
  }
}
