import 'package:drift/drift.dart';
import "package:tiendita/database/tienditaDatabase.dart";

class ClientsModel {
  final int? idClient;
  final String clientName;
  final String clientLastName;
  final String clientPhoneNumber;
  final String clientEmail;
  final String clientAddress;

  ClientsModel({
  this.idClient,
  required this.clientName,
  required this.clientLastName,
  required this.clientPhoneNumber,
  required this.clientEmail,
  required this.clientAddress
  });

  ClientsCompanion toCompanion(){
    return ClientsCompanion(
      id_client: idClient != null ? Value(idClient!) : const Value.absent(),
      client_name: Value(clientName),
      last_name: Value(clientLastName),
      phone_number: Value(clientPhoneNumber),
      email_client: Value(clientEmail),
      address_client: Value(clientAddress)
    );
  }

  factory ClientsModel.fromRow(Client row) {
    return ClientsModel(
      idClient: row.id_client,
      clientName: row.client_name,
      clientLastName: row.last_name,
      clientPhoneNumber: row.phone_number,
      clientEmail: row.email_client,
      clientAddress: row.address_client,
    );
  }
}
