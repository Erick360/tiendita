import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../constants/constants.dart';
import '../../providers/expenses_provider.dart';
import '../../widgets/footer_button.dart';
import '../../widgets/text_data.dart';
import 'create_expense.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});
  static String id = "expenses_screen";

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isShowingToday = true;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kActiveColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      setState(() {
        _startDate = pickedRange.start;
        _endDate = DateTime(
          pickedRange.end.year,
          pickedRange.end.month,
          pickedRange.end.day,
          23, 59, 59,
        );
      });

      ref.read(expenseNotifierProvider.notifier).loadExpensesByDateRange(_startDate!, _endDate!);
    }else if(_startDate == null){
      _loadToday();
    }
  }

  Future<void> _confirmDelete(BuildContext context, int expenseId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar Gasto"),
          content: const Text("¿Estás seguro de que deseas eliminar este gasto? Esta acción no se puede deshacer."),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Eliminar", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirm == true && context.mounted) {
      await ref.read(expenseNotifierProvider.notifier).deleteExpense(expenseId);

      if(_isShowingToday) {
        _loadToday();
      }else if (_startDate != null && _endDate != null) {
        ref.read(expenseNotifierProvider.notifier).loadExpensesByDateRange(_startDate!, _endDate!);
      }

      showSuccessSnackBar(context, 'Gasto eliminado correctamente');
    }
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadToday();
    });
  }

  void _loadToday() {
    setState(() {
      _isShowingToday = true;
    });
    ref.read(expenseNotifierProvider.notifier).loadExpensesForDay(DateTime.now());
  }

  @override
  Widget build(BuildContext) {
    final expensesState = ref.watch(expenseNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kActiveColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt, color: Colors.white, size: 20),
            const SizedBox(width: 5),
            Text(
              'Mis Gastos',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: _loadToday,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isShowingToday ? const Color(0xFFF25410) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                        ),
                          child: Center(
                            child: Text(
                              "Hoy",
                              style: TextStyle(
                                color: _isShowingToday ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _isShowingToday = false;
                            });
                            _selectDateRange(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isShowingToday ? kActiveColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                          ),
                            child: Center(
                              child: Text(
                                "Por Fechas",
                                style: TextStyle(
                                  color: !_isShowingToday ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if(!_isShowingToday && _startDate != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[50],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.calendar_today, color: Color(0xFFF25410)),
                    label: Text(
                      "${DateFormat('dd/MMM/yyyy').format(_startDate!)}  -  ${DateFormat('dd/MMM/yyyy').format(_endDate!)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () => _selectDateRange(context),
                  ),
                ),
              Expanded(
                  child: (!_isShowingToday && _startDate == null) ? 
                  const Center(
                    child: Text(
                      "Selecciona un rango de fechas.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ) : expensesState.when(
                      data: (expenses){
                        if(expenses.isEmpty){
                          return Center(
                            child: Text(
                              _isShowingToday ? "No tienes gastos registrados hoy." : "No se encontraron gastos.",
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }
                        final double totalSum = expenses.fold(0.0, (sum, expense) => sum + (expense?.amount ?? 0.0));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Total Gastado:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                                  Text("\$${totalSum.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                                    headingRowHeight: 60,
                                    dataRowMaxHeight: 60,
                                    columnSpacing: 25,
                                    showCheckboxColumn: false,
                                    columns: [
                                      DataColumn(label: TextData(_isShowingToday ? "Hora" : "Fecha", 18, Colors.black, "Poppins", FontWeight.bold)),
                                      DataColumn(label: TextData("Descripción", 18, Colors.black, "Poppins", FontWeight.bold)),
                                      DataColumn(label: TextData("Monto", 18, Colors.black, "Poppins", FontWeight.bold)),
                                      DataColumn(label: TextData("Acciones", 18, Colors.black, "Poppins", FontWeight.bold)),
                                    ],
                                    rows: expenses.map((expense) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(
                                              _isShowingToday
                                                  ? DateFormat('hh:mm a').format(expense!.expenseDate)
                                                  : DateFormat('dd/MM/yy').format(expense!.expenseDate),
                                              style: TextStyle(fontWeight: _isShowingToday ? FontWeight.bold : FontWeight.normal)
                                          )),
                                          DataCell(Text(expense.description ?? "Sin descripción")),
                                          DataCell(Text("\$${expense.amount.toStringAsFixed(2) ?? '0.00'}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red))),
                                          DataCell(
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                                              onPressed: () {
                                                if (expense?.idExpenses != null) {
                                                  _confirmDelete(context, expense!.idExpenses!);
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      error: (e, stack) => Center(child: Text("Error: $e", style: const TextStyle(color: Colors.red))),
                      loading: () => const Center(child: CircularProgressIndicator()),
                  ),
              ),



              /*
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text("Gastos del dia de hoy", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      expensesToday.when(
                          data: (expenses){
                            if(expenses.isEmpty){
                              return const  Center(child: Text("No haz realizado ningun gasto hoy", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
                            }
                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(top: 10),
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                                  headingRowHeight: 40,
                                  dataRowMinHeight: 40,
                                  dataRowMaxHeight: 40,
                                  columnSpacing: 20,
                                  showCheckboxColumn: false,
                                  columns: [
                                    DataColumn(label: TextData("Ticket", 18, Colors.black, "Poppins", FontWeight.bold)),
                                    DataColumn(label: TextData("Hora", 18, Colors.black, "Poppins", FontWeight.bold)),
                                    DataColumn(label: TextData("Subtotal", 18, Colors.black, "Poppins", FontWeight.bold)),
                                    DataColumn(label: TextData("Total", 18, Colors.black, "Poppins", FontWeight.bold)),
                                    DataColumn(label: TextData("Acciones", 18, Colors.black, "Poppins", FontWeight.bold)),
                                  ],
                                  rows: expenses.map((exp){
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(exp!.expenseName, style: const TextStyle(fontWeight: FontWeight.bold))),
                                        DataCell(Text(exp.description, style: const TextStyle(fontWeight: FontWeight.bold))),
                                        DataCell(Text(DateFormat('hh:mm a').format(exp.expenseDate))),
                                        DataCell(Text("\$${exp.amount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),

                                        DataCell(
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                                              onPressed: () async {
                                                if (exp.idExpenses != null) {
                                                  await ref.read(expenseNotifierProvider.notifier).deleteExpense(exp.idExpenses!);
                                                  ref.read(expenseNotifierProvider.notifier).loadExpensesForDay(exp.expenseDate);
                                                }
                                              },
                                            )
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                          error: (e, stack) => Text("Error al cargar datos: $e"),
                          loading: () => const Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Selecciona un rango de fechas",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[50],
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: const Icon(Icons.calendar_today, color: Color(0xFFF25410)),
                        label: Text(
                          _startDate == null
                              ? "Elegir Fechas"
                              : "${DateFormat('dd/MM/yyyy').format(_startDate!)}  -  ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () => _selectDateRange(context),
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 20),
              Expanded(
                child: _startDate == null
                    ? const Center(
                  child: Text(
                    "Usa el botón de arriba para buscar gastos.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : expensesState.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, stack) => Center(child: Text("Error: $e", style: const TextStyle(color: Colors.red))),
                  data: (expenses) {
                    if (expenses.isEmpty) {
                      return const Center(
                        child: Text(
                          "No se encontraron gastos en estas fechas.",
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }

                    final double totalSum = expenses.fold(0.0, (sum, expense) => sum + (expense?.amount ?? 0.0));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Gastado:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                              Text("\$${totalSum.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                                headingRowHeight: 60,
                                dataRowMaxHeight: 60,
                                columnSpacing: 25,
                                showCheckboxColumn: false,
                                columns: [
                                  DataColumn(label: TextData("Fecha", 18, Colors.black, "Poppins", FontWeight.bold)),
                                  DataColumn(label: TextData("Descripción", 18, Colors.black, "Poppins", FontWeight.bold)),
                                  DataColumn(label: TextData("Monto", 18, Colors.black, "Poppins", FontWeight.bold)),
                                  DataColumn(label: TextData("Acciones", 18, Colors.black, "Poppins", FontWeight.bold)),
                                ],
                                rows: expenses.map((expense) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(DateFormat('dd/MM/yy').format(expense!.expenseDate))),
                                      DataCell(Text(expense.description)),
                                      DataCell(Text("\$${expense.amount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red))),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                                          onPressed: () {
                                            if (expense.idExpenses != null) {
                                              _confirmDelete(context, expense.idExpenses!);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              */

            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, CreateExpense.id);
          },
          backgroundColor: Color(0xFFF25410),
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Color(0xFFF25410),
        elevation: 10,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FooterButton("Exportar a Excel", "images/excel.png", () {}),
            const SizedBox(width: 40),
            FooterButton("Exportar a PDF", "images/pdf.png", () {}),
          ],
        ),
      ),
    );
  }
}
