import 'package:sqflite/sqflite.dart';
import 'package:vendas_app/src/data/datasources/local/database/app_database.dart';
import 'package:vendas_app/src/models/category_model.dart';
import 'category_local_datasource.dart';

class CategorySqliteLocalDatasource implements CategoryLocalDatasource {
  static const _table = 'categories';

  Future<Database> get _db => AppDatabase.instance.database;

  @override
  Future<List<CategoryModel>> getAll() async {
    final db = await _db;
    final maps = await db.query(_table);
    return maps.map(_fromMap).toList();
  }

  @override
  Future<void> add(CategoryModel category) async {
    final db = await _db;
    await db.insert(_table, _toMap(category));
  }

  @override
  Future<void> update(CategoryModel category) async {
    final db = await _db;
    await db.update(
      _table,
      _toMap(category),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Map<String, Object?> _toMap(CategoryModel category) {
    return {
      'id': category.id,
      'name': category.name,
    };
  }

  CategoryModel _fromMap(Map<String, Object?> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
