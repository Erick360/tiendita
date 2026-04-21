import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/sales_model.dart';
import '../repositories/sales_repository.dart';
import 'database_provider.dart';

final salesRepositoryProvider = Provider<SalesRepository>((ref) => SalesRepository(ref.read(databaseProvider)));

final salesNotifierProvider = StateNotifierProvider<SalesNotifier, AsyncValue<List<SalesModel?>>>((ref)=> SalesNotifier(ref.watch(salesRepositoryProvider)));

class SalesNotifier extends StateNotifier<AsyncValue<List<SalesModel?>>>{
  final SalesRepository _repo;
  SalesNotifier(this._repo) : super(const AsyncData([]));

  Future<void> saveSales(SalesModel model) async{
    try{
      final id = await _repo.createSale(model);
      print("SUCCESS: Venta guardada en la base de datos con ID: $id");
    }catch(e, stack){
      print("ERROR SAVING VENTA: $e");
      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteSale(int id) async{
    try{
      await _repo.deleteSale(id);
    }catch(e, stack){
      state = AsyncError(e, stack);
    }
  }

  Future<void> loadSalesPerDay(DateTime date) async{
    try{
      state = const AsyncLoading();
      print("Buscando VENTAS para la fecha: $date");

      final allSales = await _repo.database.select(_repo.database.sales).get();
      print("Total de ventas en toda la base de datos: ${allSales.length}");
      for(var sale in allSales){
        print("   - Ticket: ${sale.num_sale} | Fecha guardada: ${sale.sale_date}");
      }
      final sales = await _repo.getSalesPerDay(date);
      print("Total de compras hoY: ${sales.length}");
      state = AsyncData(sales);
    }catch(e, stack){
      print("ERROR FETCHING SALES: $e");
      state = AsyncError(e, stack);
    }
  }

  Future<void> loadSalesByRange(DateTime start, DateTime end) async{
    try{
      state = const AsyncLoading();
      final sales = await _repo.getSalesByDateRange(start, end);
      state = AsyncData(sales);
    }catch(e, stack){
      state = AsyncError(e, stack);
    }
  }
}