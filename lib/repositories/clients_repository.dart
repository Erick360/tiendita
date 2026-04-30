import 'package:tiendita/database/tienditaDatabase.dart';
import 'package:tiendita/models/clients_model.dart';

class ClientsRepository{
  final TienditaDatabase database;
  ClientsRepository(this.database);

  Future<int> createClient(ClientsModel model) async{
    final client = model.toCompanion();
    return await database.into(database.clients).insert(client);
  }

  Future<ClientsModel?> getClient() async{
    final clientData = await(database.select(database.clients)..limit(1)).getSingleOrNull();
    if(clientData == null)throw new Exception("No se encontro ningun dato");
    return ClientsModel.fromRow(clientData);
  }

  Stream<List<ClientsModel?>> watchAllClients(){
    return (database.select(database.clients)).
    watch().map((row) => row.map((row)=>ClientsModel.fromRow(row)).toList());
  }

  Future<bool> updateClientById(ClientsModel model) async{
    final res = await (database.update(database.clients)..
    where((t) => t.id_client.equals(model.idClient!))).write(model.toCompanion());
    return res > 0;
  }

  Future<int>  deleteClient(int id) async{
    return await (database.delete(database.clients)..where((t) => t.id_client.equals(id))).go();
  }
}