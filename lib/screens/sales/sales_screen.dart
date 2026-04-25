import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/models/clients_model.dart';
import 'package:tiendita/providers/clients_provider.dart';
import 'package:tiendita/screens/sales/sales_cart_items.dart';
import 'package:tiendita/screens/sales/sales_history_custom.dart';
import 'package:tiendita/screens/sales/sales_history_today.dart';
import 'package:tiendita/widgets/text_data.dart';
import '../../models/products_model.dart';
import '../../models/sales_model.dart';
import '../../providers/salesProviders.dart';
import '../../providers/products_provider.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});
  static String id = "sales_screen";

  @override 
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen>{
  int? _selectedClientId;
  String? _selectedClientName;
  String _currentSalesTicket = "VENT-0001";

  @override
  void initState(){
    super.initState();
    _currentSalesTicket =  "VENT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.watch(cartProvider.notifier);
    final clientAsync = ref.watch(clientListProvider);
    final productsAsync = ref.watch(productsListProvider);

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
              Icons.point_of_sale_sharp,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              'Ventas',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String route) {
              Navigator.pushNamed(context, route);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: SalesHistoryToday.id,
                  child: Row(
                    children: [
                      Icon(Icons.history, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Consultar ventas (hoy)'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: SalesHistoryCustom.id,
                  child: const Row(
                    children: [
                      Icon(Icons.history_outlined, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Consultar ventas (fechas)'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  clientAsync.when(
                      data: (clients){
                        final validClients = clients.whereType<ClientsModel>().toList();
                        return Autocomplete<ClientsModel>(
                            optionsBuilder: (TextEditingValue textEditingValue){
                              if(textEditingValue.text.isEmpty){
                                return const Iterable<ClientsModel>.empty();
                              }
                              return validClients.where((ClientsModel c){
                                return c.clientName.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase(),
                                );
                              });
                            },
                            displayStringForOption: (ClientsModel option) =>
                            option.clientName,
                            onSelected: (ClientsModel c){
                              setState(() {
                                _selectedClientId = c.idClient;
                                _selectedClientName = c.clientName;
                              });
                              FocusScope.of(context).unfocus();
                            },
                            fieldViewBuilder: (context, controller, focusNode, onEditingComplete){
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                onSubmitted: (String value){
                                  onEditingComplete();
                                },
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.search),
                                  labelText: "Buscar cliente...",
                                  border: OutlineInputBorder(),
                                ),
                              );
                            }
                        );
                      },
                      error: (e, stack) => Text("Error al cargar clientes: $e"),
                      loading: () => const Center(child: CircularProgressIndicator()),
                  ),
                  const SizedBox(height: 20),
                  if(_selectedClientId != null)
                    Card(
                      elevation: 2,
                      color: Colors.blue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowHeight: 40,
                            dataRowMinHeight: 40,
                            dataRowMaxHeight: 40,
                            columnSpacing: 20,
                            showCheckboxColumn: false,
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Ticket de Venta',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Cliente',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: [
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      _currentSalesTicket,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      _selectedClientName ?? 'venta rapida',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  productsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Text('Error al cargar productos: $err'),
                    data: (products) {
                      final validProducts = products
                          .whereType<ProductsModel>()
                          .toList();

                      return Autocomplete<ProductsModel>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<ProductsModel>.empty();
                          }
                          return validProducts.where((ProductsModel item) {
                            return item.productName.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            );
                          });
                        },

                        displayStringForOption: (ProductsModel option) =>
                        option.productName,

                        onSelected: (ProductsModel selection) {
                          cartNotifier.addItem(
                            SalesCartItems(
                              productId: selection.idProduct ?? 0,
                              name: selection.productName,
                              price: selection.priceSale ?? 0.0,
                              stock: selection.stock ?? 0,
                            ),
                          );
                          FocusScope.of(context).unfocus();
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onFieldSubmitted) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            onSubmitted: (String value){
                              onFieldSubmitted();
                            },
                            decoration: const InputDecoration(
                              icon: Icon(Icons.add_shopping_cart),
                              labelText: "Busca un producto para agregar...",
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                        headingRowHeight: 60,
                        dataRowMaxHeight: 60,
                        columnSpacing: 15,
                        showCheckboxColumn: false,
                          columns: [
                            DataColumn(
                              label: TextData(
                                  "Item",
                                18,
                                Colors.black,
                                "Poppins",
                                FontWeight.bold,
                              )
                            ),
                            DataColumn(
                                label: TextData(
                                  "Nombre",
                                  18,
                                  Colors.black,
                                  "Poppins",
                                  FontWeight.bold,
                                )
                            ),
                            DataColumn(
                                label: TextData(
                                  "Precio venta ",
                                  18,
                                  Colors.black,
                                  "Poppins",
                                  FontWeight.bold,
                                )
                            ),
                            DataColumn(
                                label: TextData(
                                  "stock",
                                  18,
                                  Colors.black,
                                  "Poppins",
                                  FontWeight.bold,
                                )
                            ),
                            DataColumn(
                                label: TextData(
                                  "Cantidad",
                                  18,
                                  Colors.black,
                                  "Poppins",
                                  FontWeight.bold,
                                )
                            ),
                            DataColumn(
                                label: TextData(
                                  "Importe",
                                  18,
                                  Colors.black,
                                  "Poppins",
                                  FontWeight.bold,
                                )
                            ),
                          ],
                          rows: cart.asMap().entries.map((entry){
                            int index = entry.key;
                            SalesCartItems item = entry.value;
                            return DataRow(
                                cells: [
                                  DataCell(Text('${index + 1}')),
                                  DataCell(Text(item.name)),
                                  DataCell(Text('\$${item.price.toStringAsFixed(2)}')),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            if (item.quantity > 1) {
                                              cartNotifier.updateQuantity(
                                                item.productId,
                                                item.quantity - 1,
                                              );
                                            }
                                          },
                                        ),
                                        Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.green,
                                          ),
                                          onPressed: () => cartNotifier.updateQuantity(
                                            item.productId,
                                            item.quantity + 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(Text('\$${item.total.toStringAsFixed(2)}')),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        cartNotifier.updateQuantity(item.productId, 0);
                                      },
                                    ),
                                  ),

                                ]
                            );
                          }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                  height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_selectedClientId == null) {
                          showErrorSnackBar(
                            context,
                            'Por favor, selecciona un cliente.',
                          );
                          return;
                        }
                        if (cart.isEmpty) {
                          showErrorSnackBar(context, 'El carrito está vacío.');
                          return;
                        }

                        final newSale = SalesModel(
                          salesDate: DateTime.now(),
                          numSales: _currentSalesTicket,
                          subTotal: cartNotifier.subtotal,
                          total: cartNotifier.total,
                          idClient: _selectedClientId,
                        );

                        await ref
                            .read(salesNotifierProvider.notifier)
                            .saveSales(newSale);

                        if (context.mounted) {
                          showSuccessSnackBar(
                            context,
                            '¡Venta registrada con éxito!',
                          );
                        }

                        cartNotifier.clearCart();
                        setState(() {
                          _selectedClientId = null;
                          _selectedClientName = null;
                          _currentSalesTicket =
                          "COMP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
                        });
                      },
                      icon: const Icon(Icons.save),
                      label: const Text("Registrar Venta"),
                    ),
                  ),
                ],
              )
          ),
    );
  }
  
}