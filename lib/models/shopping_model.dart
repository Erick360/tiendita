import 'package:drift/drift.dart';
import 'package:tiendita/database/tienditaDatabase.dart';

class ShoppingModel{
  final int? idShopping;
  final DateTime? shopDate;
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

  factory ShoppingModel.fromRow(ShoppingData row){
    return ShoppingModel(
        idShopping: row.id_shops,
        shopDate: row.shop_date,
        numShop: row.num_shop,
        subtotal: row.subtotal,
        total: row.total,
        idPurveyor: row.id_purveyor
    );
  }
}