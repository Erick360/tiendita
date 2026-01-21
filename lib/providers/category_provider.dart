import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/category_model.dart';
import 'package:tiendita/providers/database_provider.dart';
import 'package:tiendita/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref){
  final database = ref.watch(databaseProvider);
  return CategoryRepository(database);
});


final categoryListProvider  = StreamProvider<List<CategoryModel?>>((ref){
   final repository = ref.watch(categoryRepositoryProvider);
   return repository.watchAllCategories();
});

final categoryNotifierProvider = StateNotifierProvider<CategoryNotifier,AsyncValue<CategoryModel?>>((ref){
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryNotifier(repository);
});

class CategoryNotifier extends StateNotifier<AsyncValue<CategoryModel?>>{
  final CategoryRepository _repository;
  CategoryNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadCategory() async{
    state = const AsyncValue.loading();
    try{
      final category = await _repository.getCategory();
      state = AsyncValue.data(category);
    }catch(e,stack){
      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteCategory(int id) async{
    try{
      await _repository.deleteCategory(id);

    }catch(e, stack){
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> saveCategory(CategoryModel category) async{
    try{
      final exits = await _repository.categoryExits();

      if(exits && category.idCategory != null) {
        await _repository.updateCategoryById(category);
      }else{
        await _repository.createCategory(category);
      }

      await loadCategory();
    }catch(e,stack){
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

}


