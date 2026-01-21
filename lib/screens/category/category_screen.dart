import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/providers/category_provider.dart';
import 'package:tiendita/screens/category/create_category.dart';
import 'package:tiendita/screens/category/delete_category.dart';
import 'package:tiendita/screens/category/edit_category.dart';
import 'package:tiendita/widgets/text_data.dart';
import 'package:tiendita/widgets/footer_button.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});
  static String id = "category";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryListAsync = ref.watch(categoryListProvider);
    return Scaffold(
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
      ),
      body: Column(
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(top: 30)),
          SearchBar(
            hintText: "Buscar categoria",
            leading: const Icon(Icons.search),
            onChanged: (value) {},
          ),
          const SizedBox(height: 10),
          Expanded(
            child: categoryListAsync.when(
              error: (e, stack) => Text("Error: e"),
              loading: () =>
                  const Center(child: const CircularProgressIndicator()),
              data: (categories) {
                if (categories.isEmpty) {
                  return const Center(
                    child: Text("No hay categorias registradas."),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey[200],
                      ),
                      headingRowHeight: 60,
                      dataRowMaxHeight: 60,
                      dividerThickness: 2,
                      columnSpacing: 20,
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(
                          label: TextData(
                            "Nombre",
                            18,
                            Colors.black,
                            "Poppins",
                            FontWeight.bold,
                          ),
                        ),
                        DataColumn(
                          label: TextData(
                            "Editar",
                            18,
                            Colors.black,
                            "Poppins",
                            FontWeight.bold,
                          ),
                        ),
                        DataColumn(
                          label: TextData(
                            "Eliminar",
                            18,
                            Colors.black,
                            "Poppins",
                            FontWeight.bold,
                          ),
                          numeric: true,
                        ),
                      ],
                      //rows
                      rows: categories.map((category) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                category?.CategoryName ?? "Sin nombre",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.penToSquare,
                                  color: Colors.blueAccent,
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.push(context, 
                                      MaterialPageRoute(builder:(context) => EditCategory(category!)));
                                },
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => DeleteCategory(category!)),
                                  );
                                },
                              ),
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
            FooterButton("Exportar a Excel", "images/excel.png", () {}),
            const SizedBox(width: 40),
            FooterButton("Exportar a PDF", "images/pdf.png", () {}),
          ],
        ),
      ),
    );
  }
}
