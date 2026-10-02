class CalculationRecord {
  final int? id;
  final String expression;
  final String result;
  final DateTime timestamp;

  CalculationRecord({
    this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CalculationRecord.fromMap(Map<String, dynamic> map) {
    return CalculationRecord(
      id: map['id'] as int?,
      expression: map['expression'] as String,
      result: map['result'] as String,
      timestamp: DateTime.tryParse(map['timestamp'] as String) ?? DateTime.now(),
    );
  }
}
