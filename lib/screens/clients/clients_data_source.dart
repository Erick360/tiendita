import 'package:flutter/material.dart';
import 'package:tiendita/models/clients_model.dart';

import 'edit_client.dart';

class ClientsDataSource extends DataTableSource{
  final List<ClientsModel?> clients;
  final BuildContext context;
  final Function(int) onDelete;

  ClientsDataSource({
    required this.clients,
    required this.context,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index){
    if(index >= clients.length)return null;

    final client = clients[index];

    return DataRow(
        cells: [
          DataCell(
            Text(
              client?.clientName ?? "Sin nombre",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          DataCell(
            Text(
              client?.clientLastName ?? "No apellidos registrados",
              style: TextStyle(fontSize: 15),
            ),
          ),
          DataCell(
            //SizedBox(
            //width: 200,
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 20),
                SizedBox(width: 3),
                Expanded(
                  child: Text(
                    client?.clientAddress ?? "No direccion registrada",
                    style: TextStyle(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            //),
          ),
          DataCell(
            Row(
              children: [
                Icon(Icons.email_outlined, size: 20),
                SizedBox(width: 3),
                Expanded(
                  child: Text(
                    client?.clientEmail ?? "No correo electronico registrado",
                    style: TextStyle(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          DataCell(
            Row(
              children: [
                Icon(Icons.phone_android_outlined, size: 20),
                SizedBox(width: 3),
                Text(
                  client?.clientPhoneNumber ?? "No Telefono registrado",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.blueAccent,
                size: 20,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:(context) => EditClient(client)));
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                if(client?.idClient != null){
                  onDelete(client!.idClient!);
                }
              },
            ),
          ),
        ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => clients.length;

  @override
  int get selectedRowCount => 0;
}