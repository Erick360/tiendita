import 'package:flutter/material.dart';
import '../../models/text_data_model.dart';
import '../../widgets/text_data.dart';
import 'category_data_source.dart';

Center buildCategoryPaginatedDataTable(CategoryDataSource source) {
  return Center(
    child: PaginatedDataTable(
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
            model: TextDataModel(
            "Nombre",
            18,
            Colors.black,
            "Poppins",
            FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: TextData(
            model: TextDataModel(
            "Editar",
            18,
            Colors.black,
            "Poppins",
            FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: TextData(
            model: TextDataModel(
            "Eliminar",
            18,
            Colors.black,
            "Poppins",
            FontWeight.bold,
            ),
          ),
          numeric: true,
        ),
      ],
      //rows: filteredCategory.map((category) {}).toList(),
      source: source,
    ),
  );
}