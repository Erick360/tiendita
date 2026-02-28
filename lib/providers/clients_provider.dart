import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/clients_model.dart';
import '../repositories/clients_repository.dart';
import 'database_provider.dart';

final clientsRepositoryProvider = Provider<ClientsRepository>((ref){
  final database = ref.watch(databaseProvider);
  return ClientsRepository(database);
});


final clientListProvider = StreamProvider<List<ClientsModel?>>((ref){
    final repo = ref.watch(clientsRepositoryProvider);
    return repo.watchAllClients();
});

final clientNotifierProvider = StateNotifierProvider<ClientNotifier, AsyncValue<ClientsModel?>>((ref){
  final repo = ref.watch(clientsRepositoryProvider);
  return ClientNotifier(repo);
});

class ClientNotifier extends StateNotifier<AsyncValue<ClientsModel?>>{
 final ClientsRepository _repo;
 ClientNotifier(this._repo): super(const AsyncValue.loading());

 Future<void> loadClient() async {
  state = AsyncValue.loading();
 try{
  final clients = await _repo.getClient();
  state = AsyncValue.data(clients);
 }catch(e, stack){
  state = AsyncError(e, stack);
 }
 }

 Future<void> saveClient(ClientsModel client) async{
   try{
     if(client.idClient != null){
       await _repo.updateClientById(client);
     }else{
       await _repo.createClient(client);
     }

     await loadClient();
   }catch(e, stack){
     state = AsyncError(e, stack);
     rethrow;
   }
 }
}