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
       final id = await _repo.createShopping(model);
      print("SUCCESS: Compra guardada en la base de datos con ID: $id");
    }catch(e, stack){
      print("ERROR SAVING COMPRA: $e");
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
      print("Buscando compras para la fecha: $date");

      final allShops = await _repo.database.select(_repo.database.shopping).get();
      print("Total de compras en toda la base de datos: ${allShops.length}");
      for(var shop in allShops) {
        print("   - Ticket: ${shop.num_shop} | Fecha guardada: ${shop.shop_date}");
      }

      final shops = await _repo.getShopsForDay(date);
      print("Total de compras hot: ${shops.length}");
      state = AsyncData(shops);
    } catch (e, stack) {
      print("ERROR FETCHING SHOPS: $e");
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

