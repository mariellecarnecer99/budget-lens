import 'package:expense_tracker/models/category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/transactions.dart';

class DatabaseHelper {
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
      try {
        // Create the transactions table
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL,
            category_name TEXT,
            transaction_name TEXT,
            date TEXT,
            transaction_type TEXT,
            notes TEXT
          )
        ''');

        // Create the categories table
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');
      } catch (e) {
        print("Error creating tables: $e");
      }
    });
  }

  // Transactions API
  Future<int> insertTransaction(Transactions transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<int> updateCategoryTransaction(Transactions transaction) async {
    var dbClient = await database;
    return await dbClient.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<List<Transactions>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> queryResult =
        await db.query('transactions');
    return queryResult.map((e) => Transactions.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getTransactionsByType(String type) async {
    final db = await database;
    return await db.query('transactions',
        where: 'transaction_type = ?', whereArgs: [type]);
  }

  Future<List<Map<String, dynamic>>> getTransactionsByDateRange(
      String startDate, String endDate) async {
    final db = await database;
    return await db.query('transactions',
        where: 'date BETWEEN ? AND ?', whereArgs: [startDate, endDate]);
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getTotalIncome() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('transactions',
        where: 'transaction_type = ?', whereArgs: ['Income']);
    double totalIncome = result.fold(0.0, (sum, item) => sum + item['amount']);
    return totalIncome;
  }

  Future<double> getTotalExpenses() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('transactions',
        where: 'transaction_type = ?', whereArgs: ['Expense']);
    double totalExpenses =
        result.fold(0.0, (sum, item) => sum + item['amount']);
    return totalExpenses;
  }

  Future<double> getBalance() async {
    double totalIncome = await getTotalIncome();
    double totalExpenses = await getTotalExpenses();
    return totalIncome - totalExpenses;
  }

  // Categories API
  Future<int> insertCategory(Category category) async {
    var dbClient = await database;
    return await dbClient.insert('categories', category.toMap());
  }

  Future<int> updateCategory(Category category) async {
    var dbClient = await database;
    return await dbClient.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    var dbClient = await database;
    return await dbClient.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Category>> getCategories() async {
    var dbClient = await database;
    List<Map<String, dynamic>> categoryMaps =
        await dbClient.query('categories');

    return List.generate(categoryMaps.length, (i) {
      return Category.fromMap(categoryMaps[i]);
    });
  }
}
