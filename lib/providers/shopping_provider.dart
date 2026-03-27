import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/shopping_model.dart';
import 'package:tiendita/providers/database_provider.dart';
import '../repositories/shopping_repository.dart';

final shopsRepositoryProvider = Provider<ShoppingRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ShoppingRepository(database);
});

final shopsNotifierProvider = StateNotifierProvider<ShoppingNotifier, AsyncValue<List<ShoppingModel?>>>((ref) {
  final repo = ref.watch(shopsRepositoryProvider);
  return ShoppingNotifier(repo);
});


class ShoppingNotifier extends StateNotifier<AsyncValue<List<ShoppingModel?>>> {
  final ShoppingRepository _repo;

  ShoppingNotifier(this._repo) : super(const AsyncData([]));

  Future<void> saveShopping(ShoppingModel model) async {
    try{
      await _repo.createShopping(model);

    }catch(e, stack){
      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteShopping(int id) async {
    try {
      await _repo.deleteShopping(id);
    }catch(e, stack){
      state = AsyncError(e, stack);
    }
  }

  Future<void> loadShopsForDay(DateTime date) async {
    try {
      state = const AsyncLoading();
      final shops = await _repo.getShopsForDay(date);
      state = AsyncData(shops);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> loadShopsByRange(DateTime start, DateTime end) async {
    try {
      state = const AsyncLoading();
      final shops = await _repo.getShopsByDateRange(start, end);
      state = AsyncData(shops);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}

