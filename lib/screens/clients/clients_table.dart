import 'package:flutter/material.dart';
import '../../models/text_data_model.dart';
import '../../widgets/text_data.dart';
import 'clients_data_source.dart';

PaginatedDataTable buildClientsPaginatedDataTable(ClientsDataSource cli) {
  return PaginatedDataTable(
    header: Center(
      child: const Text("Lista de clientes",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
    ),
    headingRowColor: WidgetStateProperty.all(
      Colors.grey[200],
    ),
    headingRowHeight: 45,
    dataRowMaxHeight: 50,
    dividerThickness: 2,
    columnSpacing: 20,
    showCheckboxColumn: false,
    columns: [
      DataColumn(
        label: TextData(
          model: TextDataModel(
          'Cliente',
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
          'Apellidos',
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
          'Direccion',
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
          'Correo',
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
          'Telefono',
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
          'Editar',
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
          'Eliminar',
          18,
          Colors.black,
          "Poppins",
          FontWeight.bold,
          ),
        ),
      ),
    ],
    rowsPerPage: 10,
    availableRowsPerPage: [10,20,50],
    source: cli,
  );
}