class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String date;
  final String category;
  final String type; // 'expense' or 'income'
  final String? note;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'category': category,
      'type': type,
      'note': note,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
      category: map['category'] as String,
      type: map['type'] as String,
      note: map['note'] as String?,
    );
  }
}
