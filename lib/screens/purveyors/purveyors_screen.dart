import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/providers/purveyor_provider.dart';
import 'package:tiendita/screens/purveyors/PurveyorDataSource.dart';
import 'package:tiendita/widgets/text_data.dart';
import '../../widgets/footer_button.dart';
import 'create_purveyors.dart';
import 'edit_purveyors.dart';

class PurveyorsScreen extends ConsumerStatefulWidget {
  const PurveyorsScreen({super.key});

  static String id = "purveyors";

  @override
  ConsumerState<PurveyorsScreen> createState() => _PurveyorScreenState();
}

 class _PurveyorScreenState extends ConsumerState<PurveyorsScreen>{
  String _searchQuery = "";
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purveyorListAsync = ref.watch(purveyorListProvider);
    Future<void> _confirmDelete(BuildContext context, int id) async{
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
        await ref.read(purveyorNotifierProvider.notifier).deletePurveyor(id);

        showSuccessSnackBar(context, 'Dato eliminado correctamente');
      }
    }

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
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
              child:  SearchBar(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Customize radius
                  ),
                ),
                controller: _searchController,
                hintText: 'Buscar proveedor',
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
                      icon: Icon(Icons.clear)
                  )
                ],
              ),
            )
        ),
      ),
      body: Column(
        children: <Widget>[
          //Padding(padding: const EdgeInsets.only(top: 30)),
          const SizedBox(height: 10),
          Expanded(
            child: purveyorListAsync.when(
              data: (purveyors) {
                 final filteredPurveyors = purveyors.where((purveyor){
                  final purveyorName = purveyor?.PurveyorName.toLowerCase() ?? "";
                 return purveyorName.contains(_searchQuery);
                 }).toList();

                if(filteredPurveyors.isEmpty){
                  return Center(
                    child: Text(_searchQuery.isEmpty ? "No hay datos registrados" : "No se encontraron productos",
                        style: TextStyle(fontSize: 16)
                    ),
                  );
                }

                final source = PurveyorDataSource(
                    context: context,
                    onDelete: (id) => _confirmDelete(context, id),
                    purveyors: purveyors
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
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                        child: PaginatedDataTable(
                          header: Center(
                            child: const Text("Lista de proveedores",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
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
                          source: source,
                          //rows: filteredPurveyors.map((purveyors) {}).toList(),
                        ),
                      ),
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
