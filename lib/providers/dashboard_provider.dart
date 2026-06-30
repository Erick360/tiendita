import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/database_provider.dart';
import 'package:tiendita/models/weekly_chart_model.dart';
import 'package:tiendita/constants/constants.dart';

final weeklyChartProvider = FutureProvider<List<WeeklyChartModel>>((ref) async{
  final db = ref.watch(databaseProvider);
  
  final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday -1));
  final endOfWeek = startOfWeek.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

  final weeklySales = await (db.select(db.sales)
    ..where((t) => t.sale_date.isBetweenValues(startOfWeek, endOfWeek))).get();

  final weeklyExpenses = await(db.select(db.expenses)
    ..where((tbl) => tbl.expenseDate.isBetweenValues(startOfWeek, endOfWeek))).get();

  
  List<WeeklyChartModel> chartData = List.generate(
      7,
      (index) => WeeklyChartModel(dayIndex: index, sales: 0.0, expenses: 0.0)
  );

  for(var sale in weeklySales){
    int dayIndex = sale.sale_date.weekday - 1;
    chartData[dayIndex] = WeeklyChartModel(
        dayIndex: dayIndex,
        sales: chartData[dayIndex].sales + sale.total,
        expenses: chartData[dayIndex].expenses,
    );
  }

  for(var expense in weeklyExpenses){
    int dayIndex = expense.expenseDate.weekday - 1;
    chartData[dayIndex] = WeeklyChartModel(
        dayIndex: dayIndex,
        sales: chartData[dayIndex].sales,
        expenses: chartData[dayIndex].expenses + expense.amount
    );
  }

  return chartData;
});
