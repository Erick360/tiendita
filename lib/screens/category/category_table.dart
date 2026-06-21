import 'package:flutter/material.dart';
import '../../widgets/text_data.dart';
import 'category_data_source.dart';

PaginatedDataTable buildCategoryPaginatedDataTable(CategoryDataSource source) {
  return PaginatedDataTable(
    header: Center(
      child: const Text("Lista de categorias",
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
    //rows: filteredCategory.map((category) {}).toList(),
    source: source,
  );
}