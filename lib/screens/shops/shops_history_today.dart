import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tiendita/constants/constants.dart';
import '../../models/text_data_model.dart';
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

  @override
  Widget build(BuildContext context){
    final shopsToday = ref.watch(shopsNotifierProvider);

    Future<void> confirmDelete(BuildContext context, int id) async{
      final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text("Eliminar Compra"),
              content: const Text("¿Estás seguro de que deseas eliminar este dato? Esta acción no se puede deshacer."),
              shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Canceler", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Eliminar", style: TextStyle(color: Colors.white))
                ),
              ],
            );
          }
      );
      if(confirm == true && context.mounted){
        await ref.read(shopsNotifierProvider.notifier).deleteShopping(id);
        ref.read(shopsNotifierProvider.notifier).loadShopsForDay(DateTime.now());

        showSuccessSnackBar(context, 'Compra eliminada correctamente');
      }
    }

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
                              DataColumn(label: TextData(model: TextDataModel("Ticket", 18, Colors.black, "Poppins", FontWeight.bold))),
                              DataColumn(label: TextData(model: TextDataModel("Hora", 18, Colors.black, "Poppins", FontWeight.bold))),
                              DataColumn(label: TextData(model: TextDataModel("Subtotal", 18, Colors.black, "Poppins", FontWeight.bold))),
                              DataColumn(label: TextData(model: TextDataModel("Total", 18, Colors.black, "Poppins", FontWeight.bold))),
                              DataColumn(label: TextData(model: TextDataModel("Acciones", 18, Colors.black, "Poppins", FontWeight.bold))),
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
                                            confirmDelete(context, shop.idShopping!);
                                            //await ref.read(shopsNotifierProvider.notifier).deleteShopping(shop.idShopping!);
                                            //ref.read(shopsNotifierProvider.notifier).loadShopsForDay(DateTime.now());
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