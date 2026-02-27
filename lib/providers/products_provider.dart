import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/products_model.dart';
import 'package:tiendita/providers/category_provider.dart';
import 'package:tiendita/providers/database_provider.dart';
import 'package:tiendita/repositories/products_repository.dart';
import '../models/category_model.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref){
    final database = ref.watch(databaseProvider);
    return ProductsRepository(database);
});

final categoriesListProvider = StreamProvider<List<CategoryModel?>>((ref){
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.watchAllCategories();
});

final productsListProvider = StreamProvider<List<ProductsModel?>>((ref){
  final repository = ref.watch(productsRepositoryProvider);
  return repository.watchAllProducts();
});

final productsNotifierProvider = StateNotifierProvider<ProductsNotifier, AsyncValue<ProductsModel?>>((ref){
  final repository = ref.watch(productsRepositoryProvider);
  return ProductsNotifier(repository);
});

class ProductsNotifier extends StateNotifier<AsyncValue<ProductsModel?>>{
  final ProductsRepository _repo;
  ProductsNotifier(this._repo): super(const AsyncValue.loading());

  Future<void> loadProducts() async{
    state = const AsyncValue.loading();
    try{
      final products = await _repo.getProduct();
      state = AsyncValue.data(products);
    }catch(e, stack){
      state = AsyncError(e,stack);
    }
  }

  Future<void> deleteProduct(int id) async{
    try{
      await _repo.deleteProduct(id);
    }catch(e,stack){
      state = AsyncError(e, stack);
    }
  }



  Future<void> saveProduct(ProductsModel products) async{
    try{
      final exists = await _repo.productExits();

      if(exists && products.idProduct != null){
        await _repo.updateProductById(products);
      }else{
        await _repo.createProduct(products);
      }
    }catch(e,stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}