import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/providers/salesProviders.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/text_data.dart';

enum ReportPeriod { daily, weekly, monthly }

class SalesDetails extends ConsumerStatefulWidget{
  const SalesDetails({super.key});

  static String id = "my_sales_details";
  @override
  ConsumerState<SalesDetails> createState() => _SalesDetailsState();
}

class _SalesDetailsState extends ConsumerState<SalesDetails>{
  ReportPeriod _selectedPeriod = ReportPeriod.daily;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _fetchData(ReportPeriod.daily);
    });
  }

  void _fetchData(ReportPeriod p){
    final now = DateTime.now();
    DateTime start;
    DateTime end;

    switch(p){
      case ReportPeriod.daily:
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;

      case ReportPeriod.weekly:
        start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;

      case ReportPeriod.monthly:
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
    }
    ref.read(salesNotifierProvider.notifier).loadSalesByRange(start, end);
  }

  Widget _buildTab(String title, ReportPeriod period) {
    final isActive = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedPeriod = period);
          _fetchData(period);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? kActiveColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    final salesState = ref.watch(salesNotifierProvider);
    final dateFormat = _selectedPeriod == ReportPeriod.daily
        ? DateFormat('hh:mm a')
        : DateFormat('dd/MM/yy');

    return Scaffold(
      appBar:  AppBar(
        backgroundColor: kActiveColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_graph,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              'Reporte de ventas',
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
                     _buildTab("Hoy", ReportPeriod.daily),
                     _buildTab("Semana", ReportPeriod.weekly),
                     _buildTab("Mes", ReportPeriod.monthly),
                   ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                    child: salesState.when(
                        data: (sales){
                          if(sales.isEmpty){
                            return Center(
                             child: Text(
                               "No hay ventas registradas en este periodo",
                               style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                             ),
                            );
                          }
                          final double totalEarnings = sales.fold(0.0, (sum, sale) => sum + (sale?.total ?? 0.0));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [Color(0xFFF25410), Color(0xFFFF7A3D)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withValues(),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Ingresos Totales",
                                      style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "\$${totalEarnings.toStringAsFixed(2)}",
                                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      child: DataTable(
                                          headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                                          headingRowHeight: 50,
                                          dataRowMaxHeight: 50,
                                          columnSpacing: 30,
                                          showCheckboxColumn: false,
                                          columns: [
                                            DataColumn(label: TextData("Ticket", 16, Colors.black, "Poppins", FontWeight.bold)),
                                            DataColumn(label: TextData(_selectedPeriod == ReportPeriod.daily ? "Hora" : "Fecha", 16, Colors.black, "Poppins", FontWeight.bold)),
                                            DataColumn(label: TextData("Total", 16, Colors.black, "Poppins", FontWeight.bold)),
                                          ],
                                          rows: sales.map((sale) {
                                            return DataRow(
                                                cells: [
                                                  DataCell(Text(sale?.numSales ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold))),
                                                  DataCell(Text(dateFormat.format(sale!.salesDate))),
                                                  DataCell(Text("\$${sale.total.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                                                ],
                                            );
                                          }).toList(),
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          );
                        },
                        error: (e, stack) => Center(child: Text("Error: $e", style: const TextStyle(color: Colors.red))),
                        loading: () => Center(child: const CircularProgressIndicator()),
                    )
                ),
              ],
            ),
          ),
      ),
    );
  }
}