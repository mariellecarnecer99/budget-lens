import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/category.dart';

class CategoryDatabaseHelper {
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
          'CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
    });
  }

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
