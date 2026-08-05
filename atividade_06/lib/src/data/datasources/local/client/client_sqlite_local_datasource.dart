import 'package:sqflite/sqflite.dart';
import 'package:vendas_app/src/data/datasources/local/database/app_database.dart';
import 'package:vendas_app/src/models/client_model.dart';
import 'client_local_datasource.dart';

class ClientSqliteLocalDatasource implements ClientLocalDatasource {
  static const _table = 'clients';

  Future<Database> get _db => AppDatabase.instance.database;

  @override
  Future<List<ClientModel>> getAll() async {
    final db = await _db;
    final maps = await db.query(_table);
    return maps.map(_fromMap).toList();
  }

  @override
  Future<void> add(ClientModel client) async {
    final db = await _db;
    await db.insert(_table, _toMap(client));
  }

  @override
  Future<void> update(ClientModel client) async {
    final db = await _db;
    await db.update(
      _table,
      _toMap(client),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Map<String, Object?> _toMap(ClientModel client) {
    return {
      'id': client.id,
      'name': client.name,
      'email': client.email,
      'phone': client.phone,
    };
  }

  ClientModel _fromMap(Map<String, Object?> map) {
    return ClientModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
    );
  }
}
