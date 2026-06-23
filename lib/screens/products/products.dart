import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiendita/screens/products/products_data_source.dart';
import 'package:tiendita/screens/products/products_table.dart';
import '../../constants/constants.dart';
import '../../models/products_model.dart';
import '../../providers/products_provider.dart';
import '../../widgets/footer_button.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'create_products.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});
  static String id = "products_screen";

  @override
  ConsumerState<ProductsScreen> createState() => _MyProductsState();
}

class _MyProductsState extends ConsumerState<ProductsScreen> {
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }

  Future<void> exportProductsPdf(List<ProductsModel?> products) async{
    final pdf = pw.Document();
    final validProducts = products.whereType<ProductsModel?>().toList();
    final tableData = validProducts.map((product){
      return [
        product?.idProduct ?? "N/A",
        product?.productName ?? "Sin nombre",
        product?.presentation ?? "Sin presentacion",
        product?.units ?? "Sin medidas",
        product?.priceShop ?? "Sin precio de compra",
        product?.priceShop ?? "Sin precio de venta",
        product?.stock ?? "Sin stock",
        product?.status ?? "Sin status",

        /*
        product?.productImage != null ? SizedBox(
          width: 50,
          height: 50,
          child: Image.file(
            File(product!.productImage!),
            fit: BoxFit.cover,
          ),
        ) : const Icon(Icons.image_not_supported, color: Colors.grey),
  */
        product?.productExpiresAt ?? "Sin fecha de caducidad",
      ];
    }).toList();

    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context){
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Lista de Productos',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                  headers: ['ID','Nombre','Presentacion','Unidad de\nmedida','Precio de\ncompra','Precio de\nventa','Stock','Status','Fecha de\ncaducidad'],
                  data: tableData,
                  border: pw.TableBorder.all(width: 1.5,color: PdfColors.black),
                  headerStyle: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold
                  ),
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors.deepOrange,
                  ),
                  rowDecoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(color: PdfColors.green300, width: 1),
                    ),
                  ),
                  cellAlignment: pw.Alignment.centerLeft,
                  cellPadding: const pw.EdgeInsets.all(8)
              ),
            ];
          }
      ),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat) async => pdf.save(),
        name: 'Lista_Productos.pdf'
    );
  }


  Future<void> exportProductsExcel(List<ProductsModel> products) async{
    try{
      var excel = Excel.createExcel();

      String sheetName = 'Productos';
      excel.rename(excel.getDefaultSheet()!, sheetName);
      Sheet sheetObject = excel[sheetName];


      sheetObject.appendRow([
        TextCellValue('ID'),
        TextCellValue('Nombre'),
        TextCellValue('Presentación'),
        TextCellValue('Unidad'),
        TextCellValue('Precio Compra'),
        TextCellValue('Precio Venta'),
        TextCellValue('Stock'),
      ]);

      final validProducts = products.whereType<ProductsModel>().toList();
      for(var product in validProducts){
        sheetObject.appendRow([
          IntCellValue(product.idProduct ?? 0),
          TextCellValue(product.productName),
          TextCellValue(product.presentation ?? 'N/A'),
          TextCellValue(product.units ?? 'N/A'),
          DoubleCellValue(product.priceShop!),
          DoubleCellValue(product.priceSale!),
          IntCellValue(product.stock!),
        ]);
      }

      var fileBytes = excel.save();
      if(fileBytes != null){
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/Reporte_Productos.xlsx';
        File(filePath)..createSync(recursive: true)..writeAsBytesSync(fileBytes);
        if(mounted){
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(filePath)],
              text: 'Reporte de Productos',
            ),
          );
        }
      }
    }catch(e){
      if(mounted){
        showErrorSnackBar(context, "Error al generar Excel: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productList = ref. watch(productsListProvider);
    
    Future<void> confirmDelete(BuildContext context, int id) async{
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


    ref.listen<AsyncValue<List<ProductsModel>>>(expiringProductsProvider, (previous, next){
      next.whenData((expiringProducts){
        if(expiringProducts.isNotEmpty){
          final productNames = expiringProducts.map((p) => p.productName).join(', ');

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Column(
                  children: [
                    Icon(Icons.timer, size: 20, color: Colors.white),
                    const SizedBox(width: 5),
                    Text("¡Atencion! Próximos a caducar: $productNames",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                duration: const Duration(seconds: 5),
              )
          );
        }
      });
    });


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
                  final filteredProducts = products.whereType<ProductsModel?>().where((product){
                    final productName =  product?.productName.toLowerCase() ?? "";
                    return productName.contains(_searchQuery);
                  }).toList();

                  if(filteredProducts.isEmpty){
                    return Center(
                        child: Text(
                            _searchQuery.isEmpty ? "No hay datos registrados" : "No se encontraron productos",
                        style: TextStyle(fontSize: 16)
                        ),
                    );
                  }


                  final source = ProductsDataSource(
                      products: filteredProducts,
                      context: context,
                      onDelete: (id) => confirmDelete(context, id),
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
                            child: buildProductsPaginatedDataTable(source),
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
            FooterButton("Exportar a Excel", "images/excel.png", () {
              final currentData = ref.read(productsListProvider).value;

              if(currentData != null && currentData.isNotEmpty){
                final filteredProducts = currentData.whereType<ProductsModel>().where((pro){
                  return pro.productName.toLowerCase().contains(_searchQuery);
                }).toList();

                exportProductsExcel(filteredProducts);
              }else{
               showErrorSnackBar(context, "No hay datos para exportar");
              }
            }),
            const SizedBox(width: 40),
            FooterButton("Exportar a PDF", "images/pdf.png", () {
              final currentData = ref.read(productsListProvider).value;

              if(currentData!= null && currentData.isNotEmpty){
                final filteredProducts = currentData.whereType<ProductsModel>().where((pro){
                  return pro.productName.toLowerCase().contains(_searchQuery);
                }).toList();

                exportProductsPdf(filteredProducts);
              }else{
                showErrorSnackBar(context, "No hay datos para exportar");
              }
            }),
          ],
        ),
      ),
    );
  }
}
