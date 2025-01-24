class Transactions {
  final int? id;
  final double amount;
  final int categoryId;
  final String transactionName;
  final String date;
  final String type;

  Transactions({
    this.id,
    required this.amount,
    required this.categoryId,
    required this.transactionName,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category_id': categoryId,
      'description': transactionName,
      'date': date,
      'type': type,
    };
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      id: map['id'],
      amount: map['amount'],
      categoryId: map['category_id'],
      transactionName: map['transaction_name'],
      date: map['date'],
      type: map['type'],
    );
  }
}
