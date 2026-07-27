import 'package:sqflite/sqflite.dart';
import 'package:vendas_app/src/data/datasources/local/database/app_database.dart';
import 'package:vendas_app/src/models/client_model.dart';
import 'package:vendas_app/src/models/order_model.dart';
import 'package:vendas_app/src/models/product_model.dart';
import 'order_local_datasource.dart';

class OrderSqliteLocalDatasource implements OrderLocalDatasource {
  static const _ordersTable = 'orders';
  static const _itemsTable = 'order_items';
  static const _clientsTable = 'clients';

  Future<Database> get _db => AppDatabase.instance.database;

  @override
  Future<List<OrderModel>> getAll() async {
    final db = await _db;
    final orderMaps = await db.query(_ordersTable, orderBy: 'date DESC');

    final orders = <OrderModel>[];
    for (final orderMap in orderMaps) {
      orders.add(await _buildOrder(db, orderMap));
    }
    return orders;
  }

  @override
  Future<void> add(OrderModel order) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.insert(_ordersTable, _orderToMap(order));
      await _insertItems(txn, order);
    });
  }

  @override
  Future<void> update(OrderModel order) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.update(
        _ordersTable,
        _orderToMap(order),
        where: 'id = ?',
        whereArgs: [order.id],
      );
      await txn.delete(_itemsTable, where: 'orderId = ?', whereArgs: [order.id]);
      await _insertItems(txn, order);
    });
  }

  @override
  Future<void> delete(String id) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete(_itemsTable, where: 'orderId = ?', whereArgs: [id]);
      await txn.delete(_ordersTable, where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<void> _insertItems(DatabaseExecutor txn, OrderModel order) async {
    for (final item in order.items) {
      await txn.insert(_itemsTable, {
        'orderId': order.id,
        'productId': item.product.id,
        'quantity': item.quantity,
      });
    }
  }

  Future<OrderModel> _buildOrder(Database db, Map<String, Object?> orderMap) async {
    final orderId = orderMap['id'] as String;

    final clientMaps = await db.query(
      _clientsTable,
      where: 'id = ?',
      whereArgs: [orderMap['clientId']],
      limit: 1,
    );
    final client = _clientFromMap(clientMaps.first);

    final itemRows = await db.rawQuery('''
      SELECT order_items.quantity AS quantity, products.*
      FROM order_items
      INNER JOIN products ON products.id = order_items.productId
      WHERE order_items.orderId = ?
    ''', [orderId]);

    final items = itemRows
        .map((row) => OrderItem(
              product: _productFromMap(row),
              quantity: row['quantity'] as int,
            ))
        .toList();

    return OrderModel(
      id: orderId,
      client: client,
      items: items,
      date: DateTime.parse(orderMap['date'] as String),
    );
  }

  Map<String, Object?> _orderToMap(OrderModel order) {
    return {
      'id': order.id,
      'clientId': order.client.id,
      'date': order.date.toIso8601String(),
    };
  }

  ClientModel _clientFromMap(Map<String, Object?> map) {
    return ClientModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
    );
  }

  ProductModel _productFromMap(Map<String, Object?> map) {
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
