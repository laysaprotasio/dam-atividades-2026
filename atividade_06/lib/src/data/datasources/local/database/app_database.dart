import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._internal();

  static final AppDatabase instance = AppDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'vendas_app.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE clients (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            phone TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE categories (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE products (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            price REAL NOT NULL,
            imageUrl TEXT NOT NULL,
            category TEXT NOT NULL,
            isFavorite INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE orders (
            id TEXT PRIMARY KEY,
            clientId TEXT NOT NULL,
            date TEXT NOT NULL,
            FOREIGN KEY (clientId) REFERENCES clients (id)
          )
        ''');

        await db.execute('''
          CREATE TABLE order_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId TEXT NOT NULL,
            productId TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            FOREIGN KEY (orderId) REFERENCES orders (id) ON DELETE CASCADE,
            FOREIGN KEY (productId) REFERENCES products (id)
          )
        ''');
      },
    );
  }
}
