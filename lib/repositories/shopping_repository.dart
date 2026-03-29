import 'package:tiendita/database/tienditaDatabase.dart';
import '../models/shopping_model.dart';
import 'package:drift/drift.dart';

class ShoppingRepository{
  final TienditaDatabase database;
  ShoppingRepository(this.database);

  Future<int> createShopping(ShoppingModel model) async {
    final shopping = model.toCompanion();
    return await database.into(database.shopping).insert(shopping);
  }

  Future<int> deleteShopping(int id) async {
    return await (database.delete(database.shopping)..where(
            (t) => t.id_shops.equals(id))).go();
  }

  Future<List<ShoppingModel>> getShopsByDateRange(DateTime start, DateTime end) async {
    final query = database.select(database.shopping)
      ..where((t) => t.shop_date.isBetweenValues(start, end));

    final rows = await query.get();
    return rows.map((row) => ShoppingModel.fromRow(row)).toList();
  }

  Future<List<ShoppingModel>> getShopsForDay(DateTime date) async {
    // Start of the day (00:00:00)
    final startOfDay = DateTime(date.year, date.month, date.day);
    // End of the day (23:59:59)
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return await getShopsByDateRange(startOfDay, endOfDay);
  }
}