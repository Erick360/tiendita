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
    if(productData == null)throw new Exception("No se encontro ningun dato");
    return ProductsModel.fromRow(productData);
  }

  Stream<List<ProductsModel>> watchAllProducts(){
    return (database.select(database.products)).watch(). 
    map((rows) => rows.map((row) => ProductsModel.fromRow(row)).toList());
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
}