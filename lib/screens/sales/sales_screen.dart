import 'package:flutter/material.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/widgets/text_data.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});
  static String id = "sales_screen";

  @override 
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen>{
  @override
  final List<String> _items = ['Option 1', 'Option 2', 'Option 3'];

  String? _selectedValue;

  Widget build(BuildContext context) {
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
              Icons.point_of_sale_sharp,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              'Ventas',
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
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  DropdownButtonFormField<String>(
                    decoration:  InputDecoration(
                      icon: Icon(Icons.search),
                      labelText: "Selecciona un proveedor",
                      border: OutlineInputBorder(),
                    ),
                      initialValue: _selectedValue,
                      items: _items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged:(String? newValue) {
                        setState(() {
                          _selectedValue = newValue;
                        });
                      },
                      validator: (value){
                        if(value == null){
                          return "Por favor seleccione un cliente";
                        }
                        return null;
                      },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration:  InputDecoration(
                      icon: Icon(Icons.search),
                      labelText: "Agregar un producto",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _selectedValue,
                    items: _items.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged:(String? newValue) {
                      setState(() {
                        _selectedValue = newValue;
                      });
                    },
                    validator: (value){
                      if(value == null){
                        return "Por favor seleccione un proveedor";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                        headingRowHeight: 60,
                        dataRowMaxHeight: 60,
                        columnSpacing: 15,
                        showCheckboxColumn: false,
                          columns: [
                            DataColumn(
                              label: TextData(
                                  "Item",
                                18,
                                Colors.black,
                                "Poppins",
                                FontWeight.bold,
                              )
                            ),
                            DataColumn(
                                label: TextData(
                                  "Nombre",
                                  18,
                                  Colors.black,
                                  "Poppins",
                                  FontWeight.bold,
                                )
                            ),
                            DataColumn(
                                label: TextData(
                                  "Precio venta ",
                                  18,
                                  Colors.black,
                                  "Poppins",
                                  FontWeight.bold,
                                )
                            ),
                            DataColumn(
                                label: TextData(
                                  "stock",
                                  18,
                                  Colors.black,
                                  "Poppins",
                                  FontWeight.bold,
                                )
                            ),
                            DataColumn(
                                label: TextData(
                                  "Cantidad",
                                  18,
                                  Colors.black,
                                  "Poppins",
                                  FontWeight.bold,
                                )
                            ),
                            DataColumn(
                                label: TextData(
                                  "Importe",
                                  18,
                                  Colors.black,
                                  "Poppins",
                                  FontWeight.bold,
                                )
                            ),
                          ],
                          rows: [

                          ],
                      ),

                    ),
                  ),
                  const SizedBox(height: 25),
                  DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                      headingRowHeight: 60,
                      dataRowMaxHeight: 60,
                      columnSpacing: 15,
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(
                            label: TextData(
                              "Subtotal",
                              18,
                              Colors.black,
                              "Poppins",
                              FontWeight.bold,
                            )
                        ),
                        DataColumn(
                            label: TextData(
                              "I.V.A%",
                              18,
                              Colors.black,
                              "Poppins",
                              FontWeight.bold,
                            )
                        ),
                        DataColumn(
                            label: TextData(
                              "Total",
                              18,
                              Colors.black,
                              "Poppins",
                              FontWeight.bold,
                            )
                        ),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(Text("0.00")),
                            DataCell(Text("16%")),
                            DataCell(Text("0.00"))
                          ]
                      ),
                    ]
                  ),
                  SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                      onPressed: (){},
                      icon: Icon(Icons.save),
                      label: Text("Registrar Venta"),
                  ),
                  )
                ],
              )
          ),
    );
  }
  
}