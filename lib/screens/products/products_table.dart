import 'package:flutter/material.dart';
import 'package:tiendita/screens/products/products_data_source.dart';
import '../../widgets/text_data.dart';

PaginatedDataTable buildProductsPaginatedDataTable(ProductsDataSource source) {
  return PaginatedDataTable(
    header: Center(
      child: Text(
        "Lista de productos",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
    headingRowHeight: 60,
    dataRowMaxHeight: 60,
    columnSpacing: 20,
    showCheckboxColumn: false,
    columns:  [
      DataColumn(
        label: TextData(
          'Producto',
          18,
          Colors.black,
          "Poppins",
          FontWeight.bold,
        ),
      ),
      DataColumn(
        label: TextData(
          'Presentacion',
          18,
          Colors.black,
          "Poppins",
          FontWeight.bold,
        ),
      ),
      DataColumn(
        label: TextData(
          'Unidad de\nmedida',
          18,
          Colors.black,
          "Poppins",
          FontWeight.bold,
        ),
      ),
      DataColumn(
        label: TextData(
          'Precio de\ncompra',
          18,
          Colors.black,
          "Poppins",
          FontWeight.bold,
        ),
      ),
      DataColumn(
        label: TextData(
          'Precio de\nventa',
          18,
          Colors.black,
          "Poppins",
          FontWeight.bold,
        ),
      ),
      DataColumn(
        label: TextData(
          'Stock',
          18,
          Colors.black,
          "Poppins",
          FontWeight.bold,
        ),
      ),
      DataColumn(
        label: TextData(
          'Status',
          18,
          Colors.black,
          "Poppins",
          FontWeight.bold,
        ),
      ),
      DataColumn(
        label: TextData(
          'Imagen',
          18,
          Colors.black,
          "Poppins",
          FontWeight.bold,
        ),
      ),
      DataColumn(
        label: TextData(
          'Fecha de\ncaducidad',
          18,
          Colors.black,
          "Poppins",
          FontWeight.bold,
        ),
      ),
      DataColumn(
        label: TextData(
          'Categoria',
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
  );
}
