import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/expenses_model.dart';
import '../repositories/expenses_repository.dart';
import 'database_provider.dart';

final expenseRepositoryProvider = Provider<ExpensesRepository>((ref) => ExpensesRepository(ref.read(databaseProvider)));

//final expensesListProvider = StreamProvider<List<ExpensesModel?>>((ref) => ref.watch(expenseRepositoryProvider).watchAllExpenses());

final expenseNotifierProvider = StateNotifierProvider<ExpensesNotifier, AsyncValue<List<ExpensesModel?>>>((ref) => ExpensesNotifier(ref.watch(expenseRepositoryProvider)));

class ExpensesNotifier extends StateNotifier<AsyncValue<List<ExpensesModel?>>> {
  final ExpensesRepository _repo;
  ExpensesNotifier(this._repo) : super(const AsyncValue.loading());

  /*
  Future<void> loadExpenses() async{
    state = const AsyncValue.loading();
    try{
      final expenses = await _repo.getExpense();
      state = AsyncValue.data(expenses as List<ExpensesModel?>);
    }catch(e, stack){
      state = AsyncError(e, stack);
    }
  }
*/

  Future<void> deleteExpense(int id) async{
    try{
      await _repo.deleteExpense(id);
    }catch(e, stack){
      state = AsyncError(e, stack);
    }
  }

  Future<void> saveExpense(ExpensesModel expense) async{
    try{
      final exists = await _repo.expenseExists();

      if(exists && expense.idExpenses!= null){
        await _repo.updateExpenseById(expense);
      }else{
        await _repo.createExpense(expense);
      }
    }catch(e, stack){
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> loadExpensesForDay(DateTime time) async{
    try{
      state = const AsyncLoading();
      print("Buscando gastos para la fecha: $time");

      final allExpenses = await _repo.database.select(_repo.database.expenses).get();
      print("Total de compras en toda la base de datos: ${allExpenses.length}");
      for(var exp in allExpenses) {
        print("   - Id: ${exp.id_expenses} | Nombre ${exp.expense_name}| Fecha guardada: ${exp.expenseDate}");
      }

      final expenses = await _repo.getExpensesPerDay(time);
      print("Total de compras hot: ${expenses.length}");
      state = AsyncData(expenses);
    }catch(e, stack){
      print("ERROR FETCHING EXPENSES: $e");
      state = AsyncError(e, stack);
    }
  }

  Future<void> loadExpensesByDateRange(DateTime start, DateTime end) async{
    try{
      state = const AsyncLoading();
      final expenses = await _repo.getExpensesByDateRange(start, end);
      state = AsyncData(expenses);
    }catch(e, stack){
      state = AsyncError(e, stack);
    }
  }

}