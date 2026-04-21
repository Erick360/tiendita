import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tiendita/screens/expenses/delete_expense.dart';
import '../../providers/expenses_provider.dart';
import '../../widgets/footer_button.dart';
import '../../widgets/text_data.dart';
import 'create_expense.dart';
import 'edit_expense.dart';

class ExpensesScreen extends ConsumerStatefulWidget{
  const ExpensesScreen({super.key});
  static String id = "expenses_screen";

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen>{
  @override
  Widget build(BuildContext){
    final ExpensesList = ref.watch(expensesListProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF25410),
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
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 30)),
          SearchBar(
            hintText: 'Buscar gastos',
            leading: const Icon(Icons.search),
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          Expanded(
              child: ExpensesList.when(
                  data: (expenses) {
                      if(expenses.isEmpty){
                        return const Center(child: Text("No hay datos registrados"));
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          child: DataTable(
                              headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                              headingRowHeight: 60,
                              dataRowMaxHeight: 60,
                              columnSpacing: 20,
                              showCheckboxColumn: false,
                              columns: [
                                DataColumn(
                                  label: TextData(
                                    'Gasto',
                                    18,
                                    Colors.black,
                                    "Poppins",
                                    FontWeight.bold,
                                  ),
                                ),
                                DataColumn(
                                  label: TextData(
                                    'Descripcion',
                                    18,
                                    Colors.black,
                                    "Poppins",
                                    FontWeight.bold,
                                  ),
                                ),
                                DataColumn(
                                  label: TextData(
                                    'Fecha',
                                    18,
                                    Colors.black,
                                    "Poppins",
                                    FontWeight.bold,
                                  ),
                                ),
                                DataColumn(
                                  label: TextData(
                                    'Precio',
                                    18,
                                    Colors.black,
                                    "Poppins",
                                    FontWeight.bold,
                                  ),
                                ),
                                DataColumn(
                                  label: TextData(
                                    'Editar',
                                    18,
                                    Colors.black,
                                    "Poppins",
                                    FontWeight.bold,
                                  ),
                                ),
                                DataColumn(
                                  label: TextData(
                                    'Eliminar',
                                    18,
                                    Colors.black,
                                    "Poppins",
                                    FontWeight.bold,
                                  ),
                                ),
                              ],
                              rows: expenses.map((expense) {
                                return DataRow(
                                    cells: [
                                      DataCell(
                                          Text(
                                            expense?.expenseName ?? "sin Nombre",
                                            style: TextStyle(fontSize: 15),
                                          )
                                      ),
                                      DataCell(
                                          Text(
                                            expense?.description ?? "sin Nombre",

                                            style: TextStyle(fontSize: 15),
                                          )
                                      ),
                                      DataCell(
                                          Text(
                                            expense?.expenseDate != null
                                                ? DateFormat('dd/MM/yy').format(expense!.expenseDate)
                                                : "Sin fecha de caducidad",
                                            style: const TextStyle(fontSize: 15),
                                          )
                                      ),
                                      DataCell(
                                          Text(
                                            "${expense?.amount ?? "sin Nombre"}",
                                            style: TextStyle(fontSize: 15),
                                          )
                                      ),
                                      DataCell(
                                        IconButton(
                                          icon: Icon(
                                            FontAwesomeIcons.penToSquare,
                                            color: Colors.blueAccent,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder:(context) => EditExpense(expense!)));
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteExpense(expense!)));
                                          },
                                        ),
                                      ),
                                    ]
                                );
                              }).toList(),
                          ),
                        ),
                      );
                  },
                  error: (e, stack) => Text("Error $e"),
                  loading: () => const Center(child: CircularProgressIndicator()),
              ),
          ),
        ],
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
