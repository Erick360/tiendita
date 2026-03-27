import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/constants/constants.dart';
import '../../models/products_model.dart';
import '../../models/purveyors_model.dart';
import '../../models/shopping_model.dart';
import '../../providers/products_provider.dart';
import '../../providers/purveyor_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../widgets/text_data.dart';
import 'cart_item.dart';

class ShoppingScreen extends ConsumerStatefulWidget {
  const ShoppingScreen({super.key});
  static String id = "shopping_screen";

  ConsumerState<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends ConsumerState<ShoppingScreen> {
  int? _selectedPurveyorId;
  String? _selectedPurveyorName;
  String _currentPurchaseTicket = "COMP-0001";

  @override
  void initState() {
    super.initState();
    _currentPurchaseTicket =
        "COMP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.watch(cartProvider.notifier);
    final purveyorAsync = ref.watch(purveyorListProvider);
    final productsAsync = ref.watch(productsListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF25410),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart, color: Colors.white, size: 20),
            const SizedBox(width: 5),
            Text(
              'Compras',
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

        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            purveyorAsync.when(
              data: (purveyors) {
                final validPurveyors = purveyors
                    .whereType<PurveyorsModel>()
                    .toList();

                return Autocomplete<PurveyorsModel>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<PurveyorsModel>.empty();
                    }
                    return validPurveyors.where((PurveyorsModel p) {
                      return p.PurveyorName.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                    });
                  },
                  displayStringForOption: (PurveyorsModel option) =>
                      option.PurveyorName,
                  onSelected: (PurveyorsModel selection) {
                    setState(() {
                      _selectedPurveyorId = selection.idPurveyor;
                      _selectedPurveyorName = selection.PurveyorName;
                    });
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.search),
                            labelText: "Buscar proveedor...",
                            border: OutlineInputBorder(),
                          ),
                        );
                      },
                );
              },
              error: (err, stack) => Text("Error al cargar proveedores: $err"),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 16),
            if(_selectedPurveyorId != null)
              Card(
                elevation: 2,
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DataTable(
                    headingRowHeight: 40,
                    dataRowMinHeight: 40,
                    dataRowMaxHeight: 40,
                    columnSpacing: 20,
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: Text('Ticket de Compra', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Proveedor', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text(_currentPurchaseTicket, style: const TextStyle(fontSize: 16, color: Colors.red))),
                        DataCell(Text(_selectedPurveyorName ?? '', style: const TextStyle(fontSize: 16))),
                      ]),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            productsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Error al cargar productos: $err'),
                data: (products) {
                  final validProducts = products.whereType<ProductsModel>().toList();

                  return Autocomplete<ProductsModel>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<ProductsModel>.empty();
                      }
                      return validProducts.where((ProductsModel item) {
                        return item.productName.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },

                    displayStringForOption: (ProductsModel option) => option.productName,

                    onSelected: (ProductsModel selection) {
                      cartNotifier.addItem(CartItem(
                        productId: selection.idProduct ?? 0,
                        name: selection.productName,
                        price: selection.priceShop ?? 0.0,
                        stock: selection.stock ?? 0,
                      ));
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.add_shopping_cart),
                          labelText: "Busca un producto para agregar...",
                          border: OutlineInputBorder(),
                        ),
                      );
                    },
                  );
                }
            ),
            const SizedBox(height: 25),
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
                    DataColumn(label: TextData("Item", 18, Colors.black, "Poppins", FontWeight.bold)),
                    DataColumn(label: TextData("Nombre", 18, Colors.black, "Poppins", FontWeight.bold)),
                    DataColumn(label: TextData("Precio Compra", 18, Colors.black, "Poppins", FontWeight.bold)),
                    DataColumn(label: TextData("Cantidad", 18, Colors.black, "Poppins", FontWeight.bold)),
                    DataColumn(label: TextData("Importe", 18, Colors.black, "Poppins", FontWeight.bold)),
                    DataColumn(label: TextData("Eliminar", 18, Colors.black, "Poppins", FontWeight.bold)),
                  ],
                  rows: cart.asMap().entries.map((entry) {
                    int index = entry.key;
                    CartItem item = entry.value;
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
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    cartNotifier.updateQuantity(item.productId, item.quantity - 1);
                                  }
                                }
                              ),
                              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                onPressed: () => cartNotifier.updateQuantity(item.productId, item.quantity + 1),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text('\$${item.total.toStringAsFixed(2)}')),
                        DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {cartNotifier.updateQuantity(item.productId, 0);},
                            )
                        ),
                      ],
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
                  if (_selectedPurveyorId == null) {
                    showErrorSnackBar(context, 'Por favor, selecciona un proveedor.');
                    return;
                  }
                  if (cart.isEmpty) {
                    showErrorSnackBar(context, 'El carrito está vacío.');
                    return;
                  }

                  final newPurchase = ShoppingModel(
                    shopDate: DateTime.now(),
                    numShop: _currentPurchaseTicket,
                    subtotal: cartNotifier.subtotal,
                    total: cartNotifier.total,
                    idPurveyor: _selectedPurveyorId!,
                  );

                  await ref.read(shopsNotifierProvider.notifier).saveShopping(newPurchase);

                  if (context.mounted) {
                    showSuccessSnackBar(context, '¡Compra registrada con éxito!');
                  }

                  cartNotifier.clearCart();
                  setState(() {
                    _selectedPurveyorId = null;
                    _selectedPurveyorName = null;
                    _currentPurchaseTicket = "COMP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
                  });
                },
                icon: const Icon(Icons.save),
                label: const Text("Registrar Compra"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
