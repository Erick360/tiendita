import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/screens/products/ProductsDataSource.dart';
import '../../constants/constants.dart';
import '../../providers/products_provider.dart';
import '../../widgets/footer_button.dart';
import '../../widgets/text_data.dart';
import 'create_products.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});
  static String id = "products_screen";

  @override
  ConsumerState<ProductsScreen> createState() => _MyProductsState();
}

class _MyProductsState extends ConsumerState<ProductsScreen> {
  String _searchQuery = "";
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productList = ref. watch(productsListProvider);
    
    Future<void> _confirmDelete(BuildContext context, int id) async{
      final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text("Eliminar Producto"),
              content: const Text("¿Estás seguro de que deseas eliminar este producto? Esta acción no se puede deshacer."),
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
        await ref.read(productsNotifierProvider.notifier).deleteProduct(id);

        showSuccessSnackBar(context, 'Producto eliminado correctamente');
      }
    }

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
            Icon(FontAwesomeIcons.bagShopping, color: Colors.white, size: 20),
            const SizedBox(width: 5),
            Text(
              'Mis productos',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
              child: SearchBar(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Customize radius
                  ),
                ),
                controller: _searchController,
                hintText: 'Buscar producto',
                leading: const Icon(Icons.search),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                trailing: [
                  IconButton(
                    onPressed: (){
                      _searchController.clear();

                      setState(() {
                        _searchQuery = "";
                      });
                    },
                    icon: Icon(Icons.clear),
                  )
                ],
              ),
            ),
        ),
      ),
      body: Column(
        children: <Widget>[
          //Padding(padding: const EdgeInsets.only(top: 30)),
          const SizedBox(height: 16),
          Expanded(
            child: productList.when(
                data: (products){
                  final filteredProducts = products.where((product){
                    final productName =  product?.productName.toLowerCase() ?? "";
                    return productName.contains(_searchQuery);
                  }).toList();

                  if(filteredProducts.isEmpty){
                    return Center(
                        child: Text(_searchQuery.isEmpty ? "No hay datos registrados" : "No se encontraron productos",
                        style: TextStyle(fontSize: 16)
                        ),
                    );
                  }


                  final source = ProductsDataSource(
                      products: products,
                      context: context,
                      onDelete: (id) => _confirmDelete(context, id),
                      ref: ref
                  );

                  return SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                        margin: const EdgeInsets.all(8),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            cardTheme: const CardThemeData(
                              elevation: 0,
                              color: Colors.transparent,
                              margin: EdgeInsets.zero,
                            ),
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                            child: PaginatedDataTable(
                              headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                                headingRowHeight: 60,
                                dataRowMaxHeight: 60,
                                columnSpacing: 20,
                                showCheckboxColumn: false,
                                columns:  [
                                  DataColumn(
                                    label: TextData(
                                      'Producto',
                                      18,
                                      Colors.black,
                                      "Poppins",
                                      FontWeight.bold,
                                    ),
                                  ),
                                  DataColumn(
                                    label: TextData(
                                      'Presentacion',
                                      18,
                                      Colors.black,
                                      "Poppins",
                                      FontWeight.bold,
                                    ),
                                  ),
                                  DataColumn(
                                    label: TextData(
                                      'U medida',
                                      18,
                                      Colors.black,
                                      "Poppins",
                                      FontWeight.bold,
                                    ),
                                  ),
                                  DataColumn(
                                    label: TextData(
                                      'Precio de compra',
                                      18,
                                      Colors.black,
                                      "Poppins",
                                      FontWeight.bold,
                                    ),
                                  ),
                                  DataColumn(
                                    label: TextData(
                                      'Precio de venta',
                                      18,
                                      Colors.black,
                                      "Poppins",
                                      FontWeight.bold,
                                    ),
                                  ),
                                  DataColumn(
                                    label: TextData(
                                      'Stock',
                                      18,
                                      Colors.black,
                                      "Poppins",
                                      FontWeight.bold,
                                    ),
                                  ),
                                  DataColumn(
                                    label: TextData(
                                      'Status',
                                      18,
                                      Colors.black,
                                      "Poppins",
                                      FontWeight.bold,
                                    ),
                                  ),
                                  DataColumn(
                                    label: TextData(
                                      'Imagen',
                                      18,
                                      Colors.black,
                                      "Poppins",
                                      FontWeight.bold,
                                    ),
                                  ),
                                  DataColumn(
                                    label: TextData(
                                      'Fecha de caducidad',
                                      18,
                                      Colors.black,
                                      "Poppins",
                                      FontWeight.bold,
                                    ),
                                  ),
                                  DataColumn(
                                    label: TextData(
                                      'Categoria',
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
                                source: source,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                error: (e,stack) => Text("Error $e"),
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
            Navigator.pushNamed(context, CreateProducts.id);
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
