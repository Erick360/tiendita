import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiendita/models/clients_model.dart';
import 'package:tiendita/models/footer_model.dart';
import 'package:tiendita/screens/clients/clients_data_source.dart';
import '../../constants/constants.dart';
import '../../providers/clients_provider.dart';
import '../../widgets/footer_button.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'clients_table.dart';
import 'create_client.dart';

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});
  static String id = "clients_screen";

  @override
  ConsumerState<ClientsScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends ConsumerState<ClientsScreen>{
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();


  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }

  Future<void> exportCategoryPdf(List<ClientsModel?> clients) async{
      try{
        final kPdf = pw.Document();

        final validClients = clients.whereType<ClientsModel?>().toList();
      final tableData = validClients.map((client){
        return [
          client?.idClient ?? "N/A",
          client?.clientName ?? "Sin nombre",
          client?.clientLastName ?? "Sin apellidos",
          client?.clientAddress ?? "Sin direccion",
          client?.clientEmail ?? "Sin correo",
          client?.clientPhoneNumber ?? "Sin telefono",
        ];
      }).toList();

      kPdf.addPage(
        pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context context){
              return [
                pw.Header(
                  level: 0,
                  child: pw.Text(
                    'Lista de Clientes',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.TableHelper.fromTextArray(
                    headers: ['ID','Nombre','Apellidos','Direccion','Correo','Telefono'],
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
          onLayout: (PdfPageFormat) async => kPdf.save(),
          name: 'Lista_Clientes.pdf'
      );
    }catch(e){
        if(mounted) showErrorSnackBar(context, "Error al generar PDF: Intente de nuevo");
      }
  }


  
  Future<void> exportClientsExcel(List<ClientsModel> cli) async{
    try {

      String sheetName = 'Clientes';
      kExcel.rename(kExcel.getDefaultSheet()!, sheetName);
      Sheet sheetObj = kExcel[sheetName];

      sheetObj.appendRow([
        TextCellValue("Id"),
        TextCellValue("Nombre"),
        TextCellValue("Apellidos"),
        TextCellValue("Direccion"),
        TextCellValue("Correo"),
        TextCellValue("Telefono")
      ]);
      final validClients = cli.whereType<ClientsModel>().toList();
      for (var cli in validClients) {
        sheetObj.appendRow([
          IntCellValue(cli.idClient ?? 0),
          TextCellValue(cli.clientName),
          TextCellValue(cli.clientLastName),
          TextCellValue(cli.clientLastName),
          TextCellValue(cli.clientAddress),
          TextCellValue(cli.clientEmail),
          TextCellValue(cli.clientPhoneNumber),
        ]);
      }

      if (kFileBytes != null) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/Lista_Clientes.xlsx';
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(kFileBytes!);
        if (mounted) {
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(filePath)],
              text: 'Lista de Clientes',
            ),
          );
        }
      }
    }catch(e){
      if(mounted){
        showErrorSnackBar(context, "Error al generar Excel: Intente de nuevo");
      }
    }
  }

  @override
  Widget build(BuildContext context){
    final clientsList = ref.watch(clientListProvider);

    Future<void> confirmDelete(BuildContext context, int id) async{
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
            Icon(Icons.people, color: Colors.white, size: 20),
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
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
              child: SearchBar(
                controller: _searchController,
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                hintText: 'Buscar Cliente',
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
            child: clientsList.when(
              data: (clients) {
                final filteredClients = clients.whereType<ClientsModel?>().where((client){
                  final clientName = client?.clientName.toLowerCase() ?? "";
                  return clientName.contains(_searchQuery);
                });

                if (filteredClients.isEmpty) {
                  return Center(
                    child: Text(
                        _searchQuery.isEmpty ? "No hay datos registrados" : "No se encontraron productos",
                        style: TextStyle(fontSize: 16)
                    ),
                  );
                }

                final source = ClientsDataSource(
                    clients: filteredClients.toList(),
                    context: context,
                    onDelete: (id) => confirmDelete(context, id)
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
                          child: buildClientsPaginatedDataTable(source),
                        ),
                      ),
                    ),
                  ),
                );
              },
              error: (e, stack) => Text('Error: $e'),
              loading: () =>
              const Center(child: CircularProgressIndicator()),
            ),
          ),
          const SizedBox(height: 40),
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
          mouseCursor: WidgetStateMouseCursor.textable,
          tooltip: "Agregar Cliente",
          elevation: 10,
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
            FooterButton(
                model: FooterModel(
                "Exportar a Excel", "images/excel.png", () {
              final currentData = ref.read(clientListProvider).value;

              if(currentData != null && currentData.isNotEmpty){
                final filteredClients = currentData.whereType<ClientsModel>().where((cli){
                  return cli.clientName.toLowerCase().contains(_searchQuery);
                }).toList();

                exportClientsExcel(filteredClients);
              }else{
                showErrorSnackBar(context, "No hay datos para exportar");
              }
            }),
            ),
            const SizedBox(width: 40),
            FooterButton(
                model: FooterModel(
                "Exportar a PDF", "images/pdf.png", () {
              final currentData = ref.read(clientListProvider).value;

              if(currentData!= null && currentData.isNotEmpty){
                final filteredClients = currentData.whereType<ClientsModel>().where((cli){
                  return cli.clientName.toLowerCase().contains(_searchQuery);
                }).toList();

                exportCategoryPdf(filteredClients);
              }else{
                showErrorSnackBar(context, "No hay datos para exportar");
              }
            }),
            ),
          ],
        ),
      ),

    );
  }

}