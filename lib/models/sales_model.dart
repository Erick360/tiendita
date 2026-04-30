import 'package:drift/drift.dart';
import 'package:tiendita/database/tienditaDatabase.dart';

class SalesModel{
  final int? idSales;
  final DateTime salesDate;
  final String numSales;
  final double subTotal;
  final double total;
  final int? idClient;

  SalesModel({
    this.idSales,
    required this.salesDate,
    required this.numSales,
    required this.subTotal,
    required this.total,
    this.idClient,
  });

  SalesCompanion toCompanion(){
    return SalesCompanion(
      id_sales: idSales != null ? Value(idSales!) : const Value.absent(),
      sale_date: Value(salesDate),
      num_sale: Value(numSales),
      subtotal: Value(subTotal),
      total: Value(total),
      id_client: Value(idClient!)
    );
  }

  factory SalesModel.fromRow(Sale row){
    return SalesModel(
        idSales: row.id_sales,
        salesDate: row.sale_date,
        numSales: row.num_sale,
        subTotal: row.subtotal,
        total: row.total,
        idClient: row.id_client,
    );
  }
}
