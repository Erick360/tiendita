import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../constants/constants.dart';
import '../../providers/salesProviders.dart';
import '../../widgets/text_data.dart';

class SalesHistoryCustom extends ConsumerStatefulWidget{
  const SalesHistoryCustom({super.key});
  static String id = "sales_history_custom";

  @override
  ConsumerState<SalesHistoryCustom> createState() => _SalesHistoryCustomState();

}

class _SalesHistoryCustomState extends ConsumerState<SalesHistoryCustom>{
  DateTime? _startDate;
  DateTime? _endDate;

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
            23, 59, 59
        );
      });

      ref.read(salesNotifierProvider.notifier).loadSalesByRange(_startDate!, _endDate!);
    }
  }
  Widget build(BuildContext context){
    final shopsState = ref.watch(salesNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF25410),
        elevation: 0,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon((Icons.history), color: Colors.white, size: 20),
              const SizedBox(width: 5),
              Text("Historial ventas fechas",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
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
                    "Usa el botón de arriba para buscar ventas.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : shopsState.when(
                  error: (e, stack) => Text("Error: $e"),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  data: (shops) {
                    if (shops.isEmpty) {
                      return const Center(
                          child: Text(
                              "No se encontraron ventas en estas fechas.",
                              style: TextStyle(fontSize: 18)
                          )
                      );
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(top: 10),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                          headingRowHeight: 60,
                          dataRowMaxHeight: 60,
                          columnSpacing: 25,
                          showCheckboxColumn: false,
                          columns: [
                            DataColumn(label: TextData("Ticket", 18, Colors.black, "Poppins", FontWeight.bold)),
                            DataColumn(label: TextData("Fecha", 18, Colors.black, "Poppins", FontWeight.bold)),
                            DataColumn(label: TextData("Total", 18, Colors.black, "Poppins", FontWeight.bold)),
                            DataColumn(label: TextData("Acciones", 18, Colors.black, "Poppins", FontWeight.bold)),
                          ],
                          rows: shops.map((shop) {
                            return DataRow(
                              cells: [
                                DataCell(Text(shop!.numSales, style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Text(DateFormat('dd/MM/yy hh:mm a').format(shop.salesDate))),
                                DataCell(Text("\$${shop.total.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                                DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      onPressed: () async {
                                        if (shop.idClient != null) {
                                          await ref.read(salesNotifierProvider.notifier).deleteSale(shop.idSales!);
                                          ref.read(salesNotifierProvider.notifier).loadSalesByRange(_startDate!, _endDate!);
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}