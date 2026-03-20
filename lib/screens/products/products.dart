import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/tienditaDatabase.dart';
import '../../providers/category_provider.dart';
import '../../providers/products_provider.dart';
import '../../widgets/footer_button.dart';
import '../../widgets/text_data.dart';
import 'create_products.dart';
import 'delete_products.dart';
import 'edit_products.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});
  static String id = "products_screen";

  @override
  ConsumerState<ProductsScreen> createState() => _MyProductsState();
}

class _MyProductsState extends ConsumerState<ProductsScreen> {

  @override
  Widget build(BuildContext context) {
    final productList = ref.watch(productsListProvider);
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
      ),
      body: Column(
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(top: 30)),
          SearchBar(
            hintText: 'Buscar producto',
            leading: const Icon(Icons.search),
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          Expanded(
            child: productList.when(
                data: (products){
                  if(products.isEmpty){
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
                          rows: products.map((product) {
                            return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      product?.productName ?? "sin Nombre",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ),
                                  DataCell(
                                      Text(
                                        product?.presentation ?? "sin Presentacion",
                                        style: TextStyle(fontSize: 15),
                                      )
                                  ),
                                  DataCell(
                                      Text(
                                        product?.units ?? "sin medida",
                                        style: TextStyle(fontSize: 15),
                                      )
                                  ),
                                  DataCell(
                                      Text(
                                        "${product?.priceShop ?? "sin precio de Compra"}",
                                        style: TextStyle(fontSize: 15),
                                      )
                                  ),
                                  DataCell(
                                      Text(
                                        "${product?.priceSale ?? "sin precio de Venta"}",
                                        style: TextStyle(fontSize: 15),
                                      )
                                  ),
                                  DataCell(
                                      Text(
                                        "${product?.stock ?? "no stock"}",
                                        style: TextStyle(fontSize: 15),
                                      )
                                  ),
                                  DataCell(
                                      Text(
                                        "${product?.status ?? "sin status"}",
                                        style: TextStyle(fontSize: 15),
                                      )
                                  ),
                                  DataCell(
                                    product?.productImage != null
                                        ? SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Image.file(File(product!.productImage!), fit: BoxFit.cover),
                                    )
                                        : const Icon(Icons.image_not_supported, color: Colors.grey),
                                  ),
                                  DataCell(
                                      Text(
                                        product?.productExpiresAt != null
                                            ? DateFormat('dd/MM/yy').format(product!.productExpiresAt!)
                                            : "Sin fecha de caducidad",
                                        style: const TextStyle(fontSize: 15),
                                      )
                                  ),
                                  DataCell(
                                    product?.idCategory != null
                                        ? FutureBuilder<Category?>(
                                      future: ref.read(categoryRepositoryProvider).showCategory(product!.idCategory!),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const SizedBox(
                                              width: 20, height: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2)
                                          );
                                        }
                                        if (snapshot.hasError || snapshot.data == null) {
                                          return const Text("Error/Deleted", style: TextStyle(fontSize: 15, color: Colors.red));
                                        }
                                        return Text(snapshot.data!.category, style: const TextStyle(fontSize: 15));
                                      },
                                    )
                                        : const Text("Sin categoria", style: TextStyle(fontSize: 15)),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.penToSquare,
                                        color: Colors.blueAccent,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder:(context) => EditProducts(product!)));
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteProduct(product!)));
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
