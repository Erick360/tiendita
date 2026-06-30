import 'package:flutter/material.dart';
import 'package:tiendita/models/purveyors_model.dart';

import 'edit_purveyors.dart';

class PurveyorDataSource extends DataTableSource {
  final Function(int) onDelete;
  final BuildContext context;
  final List<PurveyorsModel?> purveyors;

  PurveyorDataSource({
    required this.context,
    required this.onDelete,
    required this.purveyors,
  });

  @override
  DataRow? getRow(int index){
    if(index >= purveyors.length)return null;
    final purveyor = purveyors[index];

    return DataRow(
      cells: [
        DataCell(
          Text(
            purveyor?.PurveyorName ?? "Sin nombre",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20),
              const SizedBox(width: 2),
              Text(
                purveyor?.PurveyorAddress ?? "No direccion registrada",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            children: [
              Icon(Icons.email_outlined, size: 20),
              const SizedBox(width: 2),
              Text(
                purveyor?.PurveyorEmail ?? "No correo electronico registrado",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),

        ),
        DataCell(
          Row(
            children: [
              Icon(Icons.phone, size: 20),
              const SizedBox(width: 2),
              Text(
                purveyor?.PurveyorPhoneNumber ?? "No Telefono registrado",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            children: [
              Icon(Icons.book_outlined, size: 20),
              const SizedBox(width: 2),
              Text(
                purveyor?.PurveyorRFC ?? "No RFC registrado",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(
              Icons.people,
              color: Colors.blueAccent,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) => EditPurveyors(purveyor)));
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              if(purveyor?.idPurveyor != null){
                onDelete(purveyor!.idPurveyor!);
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => purveyors.length;

  @override
  int get selectedRowCount => 0;
}