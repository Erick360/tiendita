import 'package:tiendita/database/tienditaDatabase.dart';
import 'package:tiendita/models/purveyors_model.dart';

class PurveyorRepository{

  final TienditaDatabase database;
  PurveyorRepository(this.database);

  Future<int> createPurveyor(PurveyorsModel model)  async{
    final purveyor = model.toCompanion();
    return await database.into(database.purveyors).insert(purveyor);
  }

  Future<PurveyorsModel?> getPurveyor()  async{
    final purveyorData = await(database.select(database.purveyors)..limit(1)).getSingleOrNull();
    if(purveyorData == null)throw new Exception("No se encontro ningun dato");
    return PurveyorsModel.fromRow(purveyorData);
  }

  Stream<List<PurveyorsModel?>> watchAllPurveyors(){
    return (database.select(database.purveyors)).watch().
    map((rows) => rows.map((row) => PurveyorsModel.fromRow(row)).toList());
  }

  Future<bool> updatePurveyorById(PurveyorsModel purveyors) async{
    final res = await (database.update(database.purveyors)
    ..where((t) => t.id_purveyor.equals(purveyors.idPurveyor!))).write(purveyors.toCompanion());

    return res > 0;
  }
/*
  Future<bool> purveyorExits() async{
    final count = await database.purveyors.count().getSingle();
    return count > 0;
  }
*/
  Future<int> deletePurveyor(int id) async{
    return await (database.delete(database.purveyors)
      ..where((t)=> t.id_purveyor.equals(id))).go();
  }
}