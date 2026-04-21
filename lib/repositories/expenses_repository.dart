import 'package:drift/drift.dart';
import 'package:tiendita/database/tienditaDatabase.dart';
import '../models/expenses_model.dart';

class ExpensesRepository{
  final TienditaDatabase database;
  ExpensesRepository(this.database);

  Future<int> createExpense(ExpensesModel expenses) async{
    final expense = expenses.toCompanion();
    return await database.into(database.expenses).insert(expense);
  }

  Future<ExpensesModel?> getExpense() async{
    final expenseData = await (database.select(database.expenses)..limit(1)).getSingleOrNull();
    if(expenseData == null)throw new Exception("No se encontro ningun dato");
    return ExpensesModel.fromRow(expenseData);
  }

  Stream<List<ExpensesModel>> watchAllExpenses(){
    return (database.select(database.expenses)).watch().
    map((rows) => rows.map((row) => ExpensesModel.fromRow(row)).toList());
  }

  Future<bool> updateExpenseById(ExpensesModel expenses) async{
    final res = await (database.update(database.expenses)..
    where((t) => t.id_expenses.equals(expenses.idExpenses!))).write(expenses.toCompanion());

    return res > 0;
  }

  Future<bool> expenseExists() async{
    final count = await database.expenses.count().getSingle();
    return count > 0;
  }

  Future<int> deleteExpense(int id) async{
    return await (database.delete(database.expenses)
      ..where((t) => t.id_expenses.equals(id))).go();
  }
}