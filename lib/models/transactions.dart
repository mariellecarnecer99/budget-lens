class Transactions {
  final int? id;
  final double amount;
  final String categoryName;
  final String transactionName;
  final String date;
  final String transactionType;
  final String? notes;

  Transactions(
      {this.id,
      required this.amount,
      required this.categoryName,
      required this.transactionName,
      required this.date,
      required this.transactionType,
      this.notes});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category_name': categoryName,
      'transaction_name': transactionName,
      'date': date,
      'transaction_type': transactionType,
      'notes': notes
    };
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
        id: map['id'],
        amount: map['amount'],
        categoryName: map['category_name'],
        transactionName: map['transaction_name'],
        date: map['date'],
        transactionType: map['transaction_type'],
        notes: map['notes']);
  }
}
