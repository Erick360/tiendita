import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/models/category_model.dart';
import 'package:tiendita/providers/category_provider.dart';
import 'package:tiendita/screens/category/category_data_source.dart';
import 'package:tiendita/screens/category/create_category.dart';
import 'package:tiendita/widgets/text_data.dart';
import 'package:tiendita/widgets/footer_button.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'category_table.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  static String id = "category";

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen>{
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }

  Future<void> exportCategoryPdf(List<CategoryModel?> categories) async{
    final pdf = pw.Document();

    final validCategories = categories.whereType<CategoryModel?>().toList();

    final tableData = validCategories.map((category){
      return[
        category?.idCategory.toString() ?? "N/A",
        category?.CategoryName ?? "Sin nombre",
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
                'Reporte de Categorias',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 28),
            pw.TableHelper.fromTextArray(
              headers: ['ID,' 'Nombre'],
              data: tableData,
              border: null,
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.deepOrange,
              ),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.green300, width: 0.5),
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
      name: 'Reporte_Categorias.pdf'
    );
  }


  @override
  Widget build(BuildContext context) {
    Future<void> confirmDelete(BuildContext context, int id) async{
      final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text("Eliminar Categoria"),
              content: const Text("¿Estás seguro de que deseas eliminar esta categoria? Esta acción no se puede deshacer."),
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
        await ref.read(categoryNotifierProvider.notifier).deleteCategory(id);

        showSuccessSnackBar(context, 'Categoria eliminada correctamente');
      }
    }


    final categoryListAsync = ref.watch(categoryListProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kActiveColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.listCheck, color: Colors.white, size: 20),
            const SizedBox(width: 5),
            TextData(
              "Categorias",
              22,
              Colors.white,
              'Poppins',
              FontWeight.w600,
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
                hintText: "Buscar categoria",
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
                    icon: const Icon(Icons.clear),
                  )
                ],
              ),
            )
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(top: 30)),
          const SizedBox(height: 10),
          Expanded(
            child: categoryListAsync.when(
              error: (e, stack) => Text("Error: e"),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              data: (categories) {
                final filteredCategory = categories.whereType<CategoryModel?>().where((category){
                  final categoryName = category?.CategoryName?.toLowerCase() ?? "";
                  return categoryName.contains(_searchQuery);
                });

                if (filteredCategory.isEmpty) {
                  return Center(
                    child: Text(
                        _searchQuery.isEmpty ? "No hay datos registrados" : "No se encontraron productos",
                        style: TextStyle(fontSize: 16)
                    ),
                  );
                }

                final source = CategoryDataSource(
                    categories: filteredCategory.toList(),
                    context: context,
                    onDelete: (id) => confirmDelete(context, id),
                );

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
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
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                        child: buildCategoryPaginatedDataTable(source),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, CreateCategory.id);
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

            }),
            const SizedBox(width: 40),
            FooterButton("Exportar a PDF", "images/pdf.png", () {
              final currentData = ref.read(categoryListProvider).value;

              if(currentData != null && currentData.isNotEmpty){
                final filteredCategories = currentData.whereType<CategoryModel>().where((cat){
                  return cat.CategoryName!.toLowerCase().contains(_searchQuery);
                }).toList();

                exportCategoryPdf(filteredCategories);
              }else{
                showErrorSnackBar(context, "No hay datos para exportar                                 ");
              }
            }),
          ],
        ),
      ),
    );
  }

}
