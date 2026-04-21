import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/expenses_model.dart';
import '../repositories/expenses_repository.dart';
import 'database_provider.dart';

final expenseRepositoryProvider = Provider<ExpensesRepository>((ref) => ExpensesRepository(ref.read(databaseProvider)));

final expensesListProvider = StreamProvider<List<ExpensesModel?>>((ref) => ref.watch(expenseRepositoryProvider).watchAllExpenses());

final expenseNotifierProvider = StateNotifierProvider<ExpensesNotifier, AsyncValue<ExpensesModel?>>((ref) => ExpensesNotifier(ref.watch(expenseRepositoryProvider)));

class ExpensesNotifier extends StateNotifier<AsyncValue<ExpensesModel?>> {
  final ExpensesRepository _repo;
  ExpensesNotifier(this._repo) : super(const AsyncValue.loading());

  Future<void> loadExpenses() async{
    state = const AsyncValue.loading();
    try{
      final expenses = await _repo.getExpense();
      state = AsyncValue.data(expenses);
    }catch(e, stack){
      state = AsyncError(e, stack);
    }
  }

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

}