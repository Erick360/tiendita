
import 'package:drift/drift.dart';
import 'package:tiendita/database/tienditaDatabase.dart';
import 'package:tiendita/models/sales_model.dart';

class SalesRepository{
  final TienditaDatabase database;
  SalesRepository(this.database);

  Future<int> createSale(SalesModel model) async{
    final sales = model.toCompanion();
    return await database.into(database.sales).insert(sales);
  }

  Future<int> deleteSale(int id) async{
    return await (database.delete(database.sales)..where(
      (t) => t.id_sales.equals(id))).go();
  }

  Future<List<SalesModel>> getSalesByDateRange(DateTime start, DateTime end) async{
    final query = database.select(database.sales)
        ..where((t) => t.sale_date.isBetweenValues(start, end));

    final rows = await query.get();
    return rows.map((row) => SalesModel.fromRow(row)).toList();
  }

  Future<List<SalesModel>> getSalesPerDay(DateTime date) async{
    final startDay = DateTime(date.year, date.month, date.day);

    final endDay = DateTime(date.year, date.month, date.day, 23,59,59);
    return await getSalesByDateRange(startDay, endDay);
  }
}