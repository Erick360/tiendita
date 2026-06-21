import 'package:flutter/material.dart';
import 'package:tiendita/screens/purveyors/purveyor_data_source.dart';
import '../../widgets/text_data.dart';

PaginatedDataTable buildPurveyorsPaginatedDataTable(PurveyorDataSource source) {
  return PaginatedDataTable(
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
  );
}
