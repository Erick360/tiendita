import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/providers/purveyor_provider.dart';
import 'package:tiendita/widgets/text_data.dart';
import '../../widgets/footer_button.dart';
import 'create_purveyors.dart';
import 'delete_purveyors.dart';
import 'edit_purveyors.dart';

class PurveyorsScreen extends ConsumerWidget {
  const PurveyorsScreen({super.key});
  static String id = "purveyors";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purveyorListAsync = ref.watch(purveyorListProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kActiveColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.truck, color: Colors.white, size: 20),
            const SizedBox(width: 5),
            Text(
              'Proveedores',
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
            hintText: 'Buscar proveedor',
            leading: const Icon(Icons.search),
            onChanged: (value) {},
          ),
          const SizedBox(height: 10),
          Expanded(
            child: purveyorListAsync.when(
              data: (purveyors) {
                if (purveyors.isEmpty) {
                  return const Center(child: Text("No hay datos registrados"));
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
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
                            'Nombre',
                            18,
                            Colors.black,
                            "Poppins",
                            FontWeight.bold,
                          ),
                        ),
                        DataColumn(
                          label: TextData(
                            'Direccion',
                            18,
                            Colors.black,
                            "Poppins",
                            FontWeight.bold,
                          ),
                        ),
                        DataColumn(
                          label: TextData(
                            'Correo',
                            18,
                            Colors.black,
                            "Poppins",
                            FontWeight.bold,
                          ),
                        ),
                        DataColumn(
                          label: TextData(
                            'Telefono',
                            18,
                            Colors.black,
                            "Poppins",
                            FontWeight.bold,
                          ),
                        ),
                        DataColumn(
                          label: TextData(
                            'RFC',
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
                      rows: purveyors.map((purveyors) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                purveyors?.PurveyorName ?? "Sin nombre",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            DataCell(
                              Text(
                                purveyors?.PurveyorAddress ?? "No direccion registrada",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            DataCell(
                              Text(
                                purveyors?.PurveyorEmail ?? "No correo electronico registrado",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            DataCell(
                              Text(
                                purveyors?.PurveyorPhoneNumber ?? "No Telefono registrado",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            DataCell(
                              Text(
                                purveyors?.PurveyorRFC ?? "No RFC registrado",
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
                                  Navigator.push(context, MaterialPageRoute(builder:(context) => EditPurveyors(purveyors)));
                                },
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DeletePurveyor(purveyors!)));
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
              error: (e, stack) => Text('Error: $e'),
              loading: () =>
                  const Center(child: const CircularProgressIndicator()),
            ),
          ),
        ],
      ),

      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, CreatePurveyor.id);
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
