import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/models/purveyors_model.dart';
import 'package:tiendita/providers/purveyor_provider.dart';
import 'package:tiendita/screens/purveyors/purveyor_data_source.dart';
import 'package:tiendita/screens/purveyors/purveyors_table.dart';
import '../../widgets/footer_button.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'create_purveyors.dart';

class PurveyorsScreen extends ConsumerStatefulWidget {
  const PurveyorsScreen({super.key});

  static String id = "purveyors";

  @override
  ConsumerState<PurveyorsScreen> createState() => _PurveyorScreenState();
}

 class _PurveyorScreenState extends ConsumerState<PurveyorsScreen> {
   String _searchQuery = "";
   final TextEditingController _searchController = TextEditingController();

   @override
   void dispose() {
     _searchController.dispose();
     super.dispose();
   }

   Future<void> exportPurveyorsPdf(List<PurveyorsModel?> clients) async {
     final pdf = pw.Document();
     final validClients = clients.whereType<PurveyorsModel?>().toList();
     final tableData = validClients.map((purveyor) {
       return [
         purveyor?.idPurveyor ?? "N/A",
         purveyor?.PurveyorName ?? "Sin Nombre",
         purveyor?.PurveyorAddress ?? "Sin Direccion",
         purveyor?.PurveyorEmail ?? "Sin Correo",
         purveyor?.PurveyorPhoneNumber ?? "Sin Telefono",
         purveyor?.PurveyorRFC ?? "Sin RFC",
       ];
     }).toList();

     pdf.addPage(
       pw.MultiPage(
           pageFormat: PdfPageFormat.a4,
           margin: const pw.EdgeInsets.all(32),
           build: (pw.Context context) {
             return [
               pw.Header(
                 level: 0,
                 child: pw.Text(
                   'Lista de Proveedores',
                   style: pw.TextStyle(
                       fontSize: 24, fontWeight: pw.FontWeight.bold),
                 ),
               ),
               pw.SizedBox(height: 20),
               pw.TableHelper.fromTextArray(
                   headers: [
                     'ID',
                     'Nombre',
                     'Direccion',
                     'Correo',
                     'Telefono',
                     'RFC'
                   ],
                   data: tableData,
                   border: pw.TableBorder.all(
                       width: 1.5, color: PdfColors.black),
                   headerStyle: pw.TextStyle(
                       color: PdfColors.white,
                       fontWeight: pw.FontWeight.bold
                   ),
                   headerDecoration: const pw.BoxDecoration(
                     color: PdfColors.deepOrange,
                   ),
                   rowDecoration: const pw.BoxDecoration(
                     border: pw.Border(
                       bottom: pw.BorderSide(
                           color: PdfColors.green300, width: 1),
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
         name: 'Lista_Proveedores.pdf'
     );
   }

   Future<void> exportPurveyorExcel(List<PurveyorsModel> pur) async {

     try{
     var excel = Excel.createExcel();

     String sheetName = "Proveedores";
     excel.rename(excel.getDefaultSheet()!, sheetName);
     Sheet sheetObj = excel[sheetName];

     sheetObj.appendRow([
       TextCellValue("Id"),
       TextCellValue("Nombre"),
       TextCellValue("Direccion"),
       TextCellValue("Correo"),
       TextCellValue("Telefono"),
       TextCellValue("RFC"),
     ]);

     final validPurveyors = pur.whereType<PurveyorsModel>().toList();
     for (var cli in validPurveyors) {
       sheetObj.appendRow([
         IntCellValue(cli.idPurveyor ?? 0),
         TextCellValue(cli.PurveyorName),
         TextCellValue(cli.PurveyorAddress),
         TextCellValue(cli.PurveyorEmail),
         TextCellValue(cli.PurveyorPhoneNumber),
         TextCellValue(cli.PurveyorRFC),
       ]);
     }

     var fileBytes = excel.save();
     if (fileBytes != null) {
       final directory = await getTemporaryDirectory();
       final filePath = '${directory.path}/Lista_Proveedores.xlsx';
       File(filePath)
         ..createSync(recursive: true)
         ..writeAsBytesSync(fileBytes);
       if (mounted) {
         await SharePlus.instance.share(
           ShareParams(
             files: [XFile(filePath)],
             text: 'Lista de Proveedores',
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
     final purveyorListAsync = ref.watch(purveyorListProvider);
     Future<void> confirmDelete(BuildContext context, int id) async {
       final bool? confirm = await showDialog<bool>(
           context: context,
           builder: (BuildContext context) {
             return AlertDialog(
               title: const Text("Eliminar Categoria"),
               content: const Text(
                   "¿Estás seguro de que deseas eliminar esta categoria? Esta acción no se puede deshacer."),
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(15)),
               actions: [
                 TextButton(
                   onPressed: () => Navigator.of(context).pop(false),
                   child: const Text(
                       "Canceler", style: TextStyle(color: Colors.grey)),
                 ),
                 ElevatedButton(
                     style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.red),
                     onPressed: () => Navigator.of(context).pop(true),
                     child: const Text(
                         "Eliminar", style: TextStyle(color: Colors.white))
                 ),
               ],
             );
           }
       );
       if (confirm == true && context.mounted) {
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
               child: SearchBar(
                 shape: WidgetStatePropertyAll(
                   RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(
                         12), // Customize radius
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
                       onPressed: () {
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
                 final filteredPurveyors = purveyors.whereType<
                     PurveyorsModel?>().where((purveyor) {
                   final purveyorName = purveyor?.PurveyorName.toLowerCase() ??
                       "";
                   return purveyorName.contains(_searchQuery);
                 }).toList();

                 if (filteredPurveyors.isEmpty) {
                   return Center(
                     child: Text(_searchQuery.isEmpty
                         ? "No hay datos registrados"
                         : "No se encontraron productos",
                         style: TextStyle(fontSize: 16)
                     ),
                   );
                 }

                 final source = PurveyorDataSource(
                     context: context,
                     onDelete: (id) => confirmDelete(context, id),
                     purveyors: filteredPurveyors
                 );

                 return SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: SingleChildScrollView(
                     padding: const EdgeInsets.only(top: 10),
                     child: Container(
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(12),
                         border: Border.all(color: Colors.grey.shade400,
                             width: 1.5),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.grey.withValues(alpha: 0.2),
                             blurRadius: 3,
                             offset: const Offset(0, 3),
                           ),
                         ],
                       ),
                       child: ConstrainedBox(
                         constraints: BoxConstraints(maxWidth: MediaQuery
                             .of(context)
                             .size
                             .width),
                         child: buildPurveyorsPaginatedDataTable(source),
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
             FooterButton("Exportar a Excel", "images/excel.png", () {
               final currentData = ref.read(purveyorListProvider).value;

               if(currentData != null && currentData.isNotEmpty){
                 final filteredPurveyors = currentData.whereType<PurveyorsModel>().where((pur){
                   return pur.PurveyorName.toLowerCase().contains(_searchQuery);
                 }).toList();

                 exportPurveyorExcel(filteredPurveyors);
               }else{
                 showErrorSnackBar(context, "No hay datos para exportar");
               }
             }),
             const SizedBox(width: 40),
             FooterButton("Exportar a PDF", "images/pdf.png", () {
               final currentData = ref.read(purveyorListProvider).value;

               if(currentData!= null && currentData.isNotEmpty){
                 final filteredPurveyors = currentData.whereType<PurveyorsModel>().where((pur){
                   return pur.PurveyorName.toLowerCase().contains(_searchQuery);
                 }).toList();

                 exportPurveyorsPdf(filteredPurveyors);
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
