import "package:drift/drift.dart";
import "package:tiendita/database/tienditaDatabase.dart";

class PurveyorsModel{
  final int? idPurveyor;
  final String PurveyorRFC;
  final String PurveyorName;
  final String PurveyorPhoneNumber;
  final String PurveyorEmail;
  final String PurveyorAddress;


  PurveyorsModel({
    this.idPurveyor,
    required this.PurveyorRFC,
    required this.PurveyorName,
    required this.PurveyorPhoneNumber,
    required this.PurveyorEmail,
    required this.PurveyorAddress,
  });

PurveyorsCompanion toCompanion(){
  return PurveyorsCompanion(
    id_purveyor: idPurveyor != null ? Value(idPurveyor!) : const Value.absent(),
    purveyor_name: Value(PurveyorName),
    phone_number: Value(PurveyorPhoneNumber),
    email: Value(PurveyorPhoneNumber),
    address: Value(PurveyorAddress)
  );
}

factory PurveyorsModel.fromRow(Purveyor row){
  return PurveyorsModel(
      idPurveyor: row.id_purveyor,
      PurveyorRFC: row.rfc,
      PurveyorName: row.purveyor_name,
      PurveyorPhoneNumber: row.phone_number,
      PurveyorEmail: row.email,
      PurveyorAddress: row.address
  );
}

}