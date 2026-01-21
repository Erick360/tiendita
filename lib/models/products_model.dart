import 'package:drift/drift.dart';
import 'package:tiendita/database/tienditaDatabase.dart';

class ProductsModel{
  final int? idProduct;
  final String productName;
  final String? presentation;
  final int? units;
  final String? coin;
  final double? priceShop;
  final double? priceSale;
  final int? stock;
  final int? status;
  final String? productImage;
  final DateTime? productExpiresAt;
  //foreign key
  final int? idCategory;


  ProductsModel({
    this.idProduct,
    required this.productName,
    required this.presentation,
    required this.units,
    required this.coin,
    required this.priceShop,
    required this.priceSale,
    required this.stock,
    required this.status,
    required this.productImage,
    required this.productExpiresAt,
    required this.idCategory
  });

  ProductsCompanion toCompanion(){
    return ProductsCompanion(
      id_product: idProduct != null ? Value(idProduct!) : const Value.absent(),
      productName: Value(productName),
      presentationProduct: Value(presentation!),
      units: units != null ? Value(units!) : const Value.absent(),
      localCoin: Value(coin!),
      price_shop: priceShop != null ? Value(priceShop!) : const Value.absent(),
      price_sale: priceSale != null ? Value(priceSale!) : const Value.absent(),
      stock: stock != null ? Value(stock!) : const Value.absent(),
      status: status != null ? Value(ProductStatus.active) : const Value.absent(),
      productImage: productImage != null ? Value(productImage!) : const Value.absent(),
      product_expires_at: productExpiresAt != null ? Value(productExpiresAt!) : const Value.absent(),

       id_category: idCategory != null ? Value(idCategory!) : const Value.absent()

    );
  }

  factory ProductsModel.fromRow(Product row){
    return ProductsModel(
        idProduct: row.id_product,
        productName: row.productName,
        presentation: row.presentationProduct,
        units: row.units,
        coin: row.localCoin,
        priceShop: row.price_shop,
        priceSale: row.price_sale,
        stock: row.stock,
        status: row.status.index,
        productImage: row.productImage,
        productExpiresAt: row.product_expires_at,
        idCategory: row.id_category
    );
  }

}