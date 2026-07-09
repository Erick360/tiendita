import 'package:drift/drift.dart';
import 'package:tiendita/database/tienditaDatabase.dart';
import 'package:tiendita/models/products_model.dart';

class ProductsRepository{
  final TienditaDatabase database;
  ProductsRepository(this.database);

  Future<int> createProduct(ProductsModel products) async{
    final product = products.toCompanion();
    return await database.into(database.products).insert(product);
  }

  Future<ProductsModel?> getProduct() async{
    final productData = await(database.select(database.products)..limit(1)).getSingleOrNull();
    if(productData == null)throw Exception("No se encontro ningun dato");
    return ProductsModel.fromRow(productData);
  }

  Stream<List<ProductsModel>> watchAllProducts(){
    return (database.select(database.products)).watch(). 
    map((rows) => rows.map((row) => ProductsModel.fromRow(row)).toList());
  }

  Stream<List<ProductsModel>> watchAllAvailableProductsToSell(){
    final query = database.select(database.products)
    ..where((p) => p.status.equals(1))..where((p) => p.stock.isBiggerThanValue(0));

    return query.map((r) => ProductsModel.fromRow(r)).watch();
  }
  
  Stream<List<ProductsModel>> watchAllProductsStockLow({required int limit}){
    final query =
    database.select(database.products)..
    where((p) => p.stock.isSmallerOrEqualValue(limit));

    return query.map((r) => ProductsModel.fromRow(r)).watch();
  }

  Stream<List<ProductsModel>> watchProductsAboutToExpire({int daysWarning = 15}){
    final thresholdDate = DateTime.now().add(Duration(days: daysWarning));

    final query = database.select(database.products)
      ..where((p) => p.product_expires_at.isNotNull())
      ..where((p) => p.product_expires_at.isSmallerOrEqualValue(thresholdDate));

    return query.map((r) => ProductsModel.fromRow(r)).watch();
  }
  
  Future<bool> updateProductById(ProductsModel products) async{
    final res = await (database.update(database.products)..
    where((t) => t.id_product.equals(products.idProduct!))).write(products.toCompanion());

    return res > 0;
  }

  Future<bool> productExits() async{
    final count = await database.products.count().getSingle();
    return count > 0;
  }


  Future<int> deleteProduct(int id) async{
    return await (database.delete(database.products)
      ..where((t) => t.id_product.equals(id))).go();
  }

  Future<void> updateStock(int productId, int quantityChange) async{
    final product = await(database.select(database.products)
      ..where((tbl)=> tbl.id_product.equals(productId))).getSingle();

    final newStock = product.stock + quantityChange;

    final newStatus = newStock <= 0 ? 0 : 1;

    await (database.update(database.products)
      ..where((tbl) => tbl.id_product.equals(productId)))
      .write(ProductsCompanion(
        stock: Value(newStock),
        status: Value(newStatus as ProductStatus)));
  }
}