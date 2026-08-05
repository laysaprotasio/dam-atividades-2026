import 'package:sqflite/sqflite.dart';
import 'package:vendas_app/src/data/datasources/local/database/app_database.dart';
import 'package:vendas_app/src/models/product_model.dart';
import 'product_local_datasource.dart';

class ProductSqliteLocalDatasource implements ProductLocalDatasource {
  static const _table = 'products';

  Future<Database> get _db => AppDatabase.instance.database;

  @override
  Future<List<ProductModel>> getAll() async {
    final db = await _db;
    final maps = await db.query(_table);
    return maps.map(_fromMap).toList();
  }

  @override
  Future<void> add(ProductModel product) async {
    final db = await _db;
    await db.insert(_table, _toMap(product));
  }

  @override
  Future<void> update(ProductModel product) async {
    final db = await _db;
    await db.update(
      _table,
      _toMap(product),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Map<String, Object?> _toMap(ProductModel product) {
    return {
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'category': product.category,
      'isFavorite': product.isFavorite ? 1 : 0,
    };
  }

  ProductModel _fromMap(Map<String, Object?> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
      category: map['category'] as String,
      isFavorite: (map['isFavorite'] as int) == 1,
    );
  }
}
