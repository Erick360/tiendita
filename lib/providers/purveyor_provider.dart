import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/purveyors_model.dart';
import 'package:tiendita/repositories/purveyor_repository.dart';
import 'package:tiendita/providers/database_provider.dart';

final purveyorRepositoryProvider = Provider<PurveyorRepository>((ref){
  final database = ref.watch(databaseProvider);
  return PurveyorRepository(database);
});

final purveyorListProvider = StreamProvider<List<PurveyorsModel?>>((ref){
  final repository = ref.watch(purveyorRepositoryProvider);
  return repository.watchAllPurveyors();
});

final purveyorNotifierProvider = StateNotifierProvider<PurveyorNotifier, AsyncValue<PurveyorsModel?>>((ref){
  final repository = ref.watch(purveyorRepositoryProvider);
  return PurveyorNotifier(repository);
});

class PurveyorNotifier extends StateNotifier<AsyncValue<PurveyorsModel?>>{
  final PurveyorRepository _repo;
  PurveyorNotifier(this._repo): super(const AsyncValue.loading());

  Future<void> loadPurveyors() async{
    state = const AsyncValue.loading();
    try{
    final purveyors = await _repo.getPurveyor();
    state = AsyncValue.data(purveyors);

    }catch(e,stack){
      state = AsyncError(e, stack);
    }
  }

  Future<void> deletePurveyor(int id) async{
    try{
      await _repo.deletePurveyor(id);
    }catch(e, stack){
      state = AsyncError(e, stack);
    }
  }

  Future<void> savePurveyor(PurveyorsModel purveyor) async{
    try{
      //final exits = await _repo.purveyorExits();
      if(purveyor.idPurveyor != null){
        await _repo.updatePurveyorById(purveyor);
      }else{
        await _repo.createPurveyor(purveyor);
      }

      await loadPurveyors();
    }catch(e, stack){
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

}