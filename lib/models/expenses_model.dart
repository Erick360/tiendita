import 'package:drift/drift.dart';
import 'package:tiendita/database/tienditaDatabase.dart';

class ExpensesModel{
  final int? idExpenses;
  final String expenseName;
  final String description;
  final double amount;
  final DateTime expenseDate;

  ExpensesModel({
    this.idExpenses,
    required  this.expenseName,
    required this.description,
    required this.amount,
    required this.expenseDate,
  });


  ExpensesCompanion toCompanion(){
    return ExpensesCompanion(
      id_expenses: idExpenses != null ? Value(idExpenses!) : const Value.absent(),
      expense_name: Value(expenseName),
      description: Value(description),
      amount: Value(amount),
      expenseDate: Value(expenseDate),
    );
  }

  factory ExpensesModel.fromRow(Expense row){
    return ExpensesModel(
      idExpenses: row.id_expenses,
        expenseName: row.expense_name,
        description: row.description!,
        amount: row.amount,
        expenseDate: row.expenseDate,
    );
  }
}
