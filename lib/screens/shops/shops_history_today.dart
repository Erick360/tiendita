import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tiendita/constants/constants.dart';

import '../../providers/shopping_provider.dart';
import '../../widgets/text_data.dart';

class ShoppingHistoryToday extends ConsumerStatefulWidget{
  const ShoppingHistoryToday({super.key});
  static String id = "shopping_history_today";

  @override
  ConsumerState<ShoppingHistoryToday> createState() => _ShoppingHistoryToday();
}

class _ShoppingHistoryToday extends ConsumerState<ShoppingHistoryToday>{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shopsNotifierProvider.notifier).loadShopsForDay(DateTime.now());
    });
  }

  Widget build(BuildContext context){
    final shopsToday = ref.watch(shopsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kActiveColor,
        elevation: 0,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
          children: [
            Icon((Icons.history), color: Colors.white, size: 20),
            const SizedBox(width: 5),
            Text("Historial compras hoy",
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
                shopsToday.when(
                    error: (e, stack) => Text("Error al cargar compras: $e"),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    data: (shops) {
                      if(shops.isEmpty){
                        return const  Center(child: Text("No haz realizado ninguna compra hoy"));
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
                            rows: shops.map((shop){
                              return DataRow(
                                cells: [
                                  DataCell(Text(shop!.numShop, style: const TextStyle(fontWeight: FontWeight.bold))),

                                  DataCell(Text(DateFormat('hh:mm a').format(shop.shopDate!))),

                                  DataCell(Text("\$${shop.subtotal.toStringAsFixed(2)}")),
                                  DataCell(Text("\$${shop.total.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),

                                  DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        onPressed: () async {
                                          if (shop.idShopping != null) {
                                            await ref.read(shopsNotifierProvider.notifier).deleteShopping(shop.idShopping!);
                                            ref.read(shopsNotifierProvider.notifier).loadShopsForDay(DateTime.now());
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
                    }
                ),
              ],
            ),
          )
      ),
    );
  }
}