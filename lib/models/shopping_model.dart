import 'package:drift/drift.dart';
import 'package:tiendita/database/tienditaDatabase.dart';

class ShoppingModel{
  final int? idShopping;
  final DateTime shopDate;
  final String numShop;
  final double subtotal;
  final double total;
  final int idPurveyor;


  ShoppingModel({
    this.idShopping,
    required this.shopDate,
    required this.numShop,
    required this.subtotal,
    required this.total,
    required this.idPurveyor
  });

  ShoppingCompanion toCompanion(){
    return ShoppingCompanion(
      id_shops: idShopping != null ? Value(idShopping!) : const Value.absent(),
      shop_date: Value(shopDate),
      num_shop: Value(numShop),
      subtotal: Value(subtotal),
      total: Value(total),
      id_purveyor: Value(idPurveyor)
    );
  }

  factory ShoppingModel.fromRow(Shopping row){
    return ShoppingModel(
        idShopping: row.id_shops as int,
        shopDate: row.shop_date as DateTime,
        numShop: row.num_shop as String,
        subtotal: row.subtotal as double,
        total: row.total as double,
        idPurveyor: row.id_purveyor as int
    );
  }
}