import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants/constants.dart';
import '../../providers/clients_provider.dart';
import '../../widgets/footer_button.dart';
import '../../widgets/text_data.dart';
import 'create_client.dart';
import 'edit_client.dart';

class ClientsScreen extends ConsumerWidget{
  const ClientsScreen({super.key});
  static String id = "clients_screen";

  Widget build(BuildContext context, WidgetRef ref){
    final clientsList = ref.watch(clientListProvider);

    Future<void> _confirmDelete(BuildContext context, int id) async{
      final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text("Eliminar Cliente"),
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
        await ref.read(clientNotifierProvider.notifier).deleteClient(id);

        showSuccessSnackBar(context, 'Categoria eliminada correctamente');
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
            Icon(FontAwesomeIcons.peopleGroup, color: Colors.white, size: 20),
            const SizedBox(width: 5),
            Text(
              'Mis Clientes',
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
            hintText: 'Buscar Cliente',
            leading: const Icon(Icons.search),
            onChanged: (value) {},
          ),
          const SizedBox(height: 10),
          Expanded(
            child: clientsList.when(
              data: (clients) {
                if (clients.isEmpty) {
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
                            'Cliente',
                            18,
                            Colors.black,
                            "Poppins",
                            FontWeight.bold,
                          ),
                        ),
                        DataColumn(
                          label: TextData(
                            'Apellidos',
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
                      rows: clients.map((client) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                 client?.clientName ?? "Sin nombre",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            DataCell(
                              Text(
                                client?.clientLastName ?? "No apellidos registrados",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            DataCell(
                              Text(
                                client?.clientAddress ?? "No direccion registrada",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            DataCell(
                              Text(
                                client?.clientEmail ?? "No correo electronico registrado",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            DataCell(
                              Text(
                                client?.clientPhoneNumber ?? "No Telefono registrado",
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
                                  Navigator.push(context, MaterialPageRoute(builder:(context) => EditClient(client)));
                                },
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  if(client?.idClient != null){
                                    _confirmDelete(context, client!.idClient!);
                                  }
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
            Navigator.pushNamed(context, CreateClient.id);
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