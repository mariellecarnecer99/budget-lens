import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/transactions.dart';

class TransactionDatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'app_database.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          ' CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT,amount REAL,category_id INTEGER,transaction_name TEXT,date TEXT,type TEXT)');
    });
  }

  Future<int> insertTransaction(Transactions transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<int> updateCategory(Transactions transaction) async {
    var dbClient = await _initDatabase();
    return await dbClient.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await _initDatabase();
    return await db.query('transactions');
  }

  Future<List<Map<String, dynamic>>> getTransactionsByType(String type) async {
    final db = await _initDatabase();
    return await db.query('transactions', where: 'type = ?', whereArgs: [type]);
  }

  Future<List<Map<String, dynamic>>> getTransactionsByDateRange(
      String startDate, String endDate) async {
    final db = await _initDatabase();
    return await db.query('transactions',
        where: 'date BETWEEN ? AND ?', whereArgs: [startDate, endDate]);
  }

  Future<int> deleteTransaction(int id) async {
    final db = await _initDatabase();
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getTotalIncome() async {
    final db = await _initDatabase();
    List<Map<String, dynamic>> result = await db
        .query('transactions', where: 'type = ?', whereArgs: ['income']);
    double totalIncome = result.fold(0.0, (sum, item) => sum + item['amount']);
    return totalIncome;
  }

  Future<double> getTotalExpenses() async {
    final db = await _initDatabase();
    List<Map<String, dynamic>> result = await db
        .query('transactions', where: 'type = ?', whereArgs: ['expense']);
    double totalExpenses =
        result.fold(0.0, (sum, item) => sum + item['amount']);
    return totalExpenses;
  }

  Future<double> getBalance() async {
    double totalIncome = await getTotalIncome();
    double totalExpenses = await getTotalExpenses();
    return totalIncome - totalExpenses;
  }
}
