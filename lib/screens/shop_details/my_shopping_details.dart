import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiendita/providers/shopping_provider.dart';
import '../../constants/constants.dart';
import '../../models/text_data_model.dart';
import '../../widgets/text_data.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

enum ReportPeriod { daily, weekly, monthly }

class ShoppingDetails extends ConsumerStatefulWidget{
  const ShoppingDetails({super.key});

  static String id = "my_shopping_details";

  @override
  ConsumerState<ShoppingDetails> createState() => _ShoppingDetailsState();
}

class _ShoppingDetailsState extends ConsumerState<ShoppingDetails>{
  ReportPeriod _selectedPeriod = ReportPeriod.daily;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _fetchData(ReportPeriod.daily);
    });
  }

  void _fetchData(ReportPeriod p) {
    final now = DateTime.now();
    DateTime start;
    DateTime end;

    switch (p) {
      case ReportPeriod.daily:
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;

      case ReportPeriod.weekly:
        start = DateTime(now.year, now.month, now.day).subtract(
            const Duration(days: 6));
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;

      case ReportPeriod.monthly:
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
    }
    ref.read(shopsNotifierProvider.notifier).loadShopsByRange(start, end);
  }

  Future<void> _exportShoppingPdf(List<dynamic> shops, double total) async{

    try{
      final kPdf = pw.Document();

      final tableData = shops.map((shop){
      return[
        shop.numShop ?? "N/A",
        shop.shopDate != null ?
        DateFormat("dd/MM/yyyy hh:mm a").format(shop.shopDate!) : 'Sin fecha',
        '\$${shop.total.toStringAsFixed(2) ?? '.00'}',
      ];
    }).toList();
    String periodName = getDay(DateFormat('EEEE').format(now));
    if(_selectedPeriod == ReportPeriod.weekly) periodName = "Semanal";
    if(_selectedPeriod == ReportPeriod.monthly) periodName = getMonth(DateFormat.MMMM().format(now));

    kPdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.all(32),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context){
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Reporte de Compras $periodName',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Compras Totales: \$${total.toStringAsFixed(2)}',
              style:  pw.TextStyle(fontSize: 16, color: PdfColors.deepOrange),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Ticket de Compra','Fecha y Hora', 'Total'],
                data: tableData,
              border: pw.TableBorder.all(width: 1.5,color: PdfColors.black),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
              headerDecoration: pw.BoxDecoration(
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
      onLayout: (PdfPageFormat format) async => kPdf.save(),
      name: 'Reporte_Compras_$periodName.pdf',
    );
    }catch(e){
      if(mounted){
        showErrorSnackBar(context, 'Error al generar PDF: Intente de nuevo');
      }
    }
  }

  Future<void> _exportShopsExcel(List<dynamic> shops, double total) async{
    try{

      String sheetName = 'Reporte_Compras_${getDay(DateFormat('EEEE').format(now))}_${getMonth(DateFormat.MMMM().format(now))}_${now.year}}';
      if(_selectedPeriod == ReportPeriod.weekly) sheetName = "Semanal";
      if(_selectedPeriod == ReportPeriod.monthly) sheetName = '${getMonth(DateFormat.MMMM().format(now))}_${now.year}';

      kExcel.rename(kExcel.getDefaultSheet()!, sheetName);
      Sheet sheetObj = kExcel[sheetName];

      sheetObj.appendRow([
        TextCellValue('Ticket de Compra'),
        TextCellValue('Fecha y Hora'),
        TextCellValue('Total'),
      ]);


      shops.map((shop){
        return [
          sheetObj.appendRow([
            TextCellValue(shop.numShop ?? "N/A"),
            TextCellValue(shop.shopDate != null ? DateFormat("dd/MM/yyyy hh:mm a").format(shop.shopDate!) : 'Sin fecha'),
            TextCellValue('\$${shop.total.toStringAsFixed(2) ?? '.00'}'),
          ]),
        ];
      }).toList();

      if(kFileBytes != null){
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/Reporte_Compras_${getDay(DateFormat('EEEE').format(now))}_${getMonth(DateFormat.MMMM().format(now))}_${now.year}}.xlsx';
        File(filePath)..createSync(recursive: true)..writeAsBytesSync(kFileBytes!);
        if(mounted){
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(filePath)],
              text: 'Reporte de Compras',
            ),
          );
        }
      }

    }catch(e){
      if(mounted){
        showErrorSnackBar(context, 'Error al generar Excel: Intente de nuevo');
      }
    }
  }

  Widget _buildTab(String title, ReportPeriod period) {
    final isActive = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedPeriod = period);
          _fetchData(period);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? kActiveColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    final salesState = ref.watch(shopsNotifierProvider);
    final dateFormat = _selectedPeriod == ReportPeriod.daily
        ? DateFormat('hh:mm a')
        : DateFormat('dd/MM/yy');

    return Scaffold(
      appBar:  AppBar(
        backgroundColor: kActiveColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.list_alt,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              'Reporte de compras',
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTab("Hoy", ReportPeriod.daily),
                    _buildTab("Semana", ReportPeriod.weekly),
                    _buildTab("Mes", ReportPeriod.monthly),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: salesState.when(
                    data: (shops){
                      if(shops.isEmpty){
                        return Center(
                          child: Text(
                            "No hay compras registradas en este periodo",
                            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          ),
                        );
                      }
                      final double totalEarnings = shops.fold(0.0, (sum, shop) => sum + (shop?.total ?? 0.0));

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF25410), Color(0xFFFF7A3D)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withValues(),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Totales por compras",
                                  style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                                const SizedBox(height: 5),
                                Text(
                                  "\$${totalEarnings.toStringAsFixed(2)}",
                                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                  onPressed: () => _exportShoppingPdf(shops, totalEarnings),
                                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                                  label: const Text('Exportar a PDF', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey[800],
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                              const SizedBox(width: 10),
                            Expanded(
                                child: ElevatedButton.icon(
                                    onPressed: () => _exportShopsExcel(shops, totalEarnings),
                                  label: const Text('Exportar a Excel', style: TextStyle(color: Colors.white),),
                                  icon: const Icon(Icons.document_scanner, color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey[800],
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                )
                              ),
                            ]
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                                    headingRowHeight: 50,
                                    dataRowMaxHeight: 50,
                                    columnSpacing: 30,
                                    showCheckboxColumn: false,
                                    columns: [
                                      DataColumn(label: TextData(model: TextDataModel( "Ticket", 16, Colors.black, "Poppins", FontWeight.bold))),
                                      DataColumn(label: TextData(model: TextDataModel( _selectedPeriod == ReportPeriod.daily ? "Hora" : "Fecha", 16, Colors.black, "Poppins", FontWeight.bold))),
                                      DataColumn(label: TextData(model: TextDataModel("Total", 16, Colors.black, "Poppins", FontWeight.bold))),
                                    ],
                                    rows: shops.map((shop) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(shop?.numShop ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold))),
                                          DataCell(Text(dateFormat.format(shop!.shopDate!))),
                                          DataCell(Text("\$${shop.total.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                          ),
                        ],
                      );
                    },
                    error: (e, stack) => Center(child: Text("Error: $e", style: const TextStyle(color: Colors.red))),
                    loading: () => Center(child: const CircularProgressIndicator()),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}