import 'package:drift/drift.dart';
import 'package:tiendita/database/tienditaDatabase.dart';
import 'package:tiendita/model/company_model.dart';

class CompanyRepository{
  final TienditaDatabase database;

  CompanyRepository (this.database);

  //CRUD operations
  //Create
  Future<int> createCompany(CompanyModel company) async{
    final companion = company.toCompanion();
    return await database.into(database.company).insert(companion);
  }

    //Read
  Future<CompanyModel?> getCompany() async{
    final companyData = await (database.select(database.company)..limit(1)).getSingleOrNull();

    if(companyData==null)throw Exception("Negocio no encontrado");
    return CompanyModel.fromRow(companyData);

  }

  //real time updates
  Stream<CompanyModel?> watchCompany() {
    return (database.select(database.company)..limit(1))
        .watchSingleOrNull()
        .map((data) => data != null ? CompanyModel.fromRow(data) : null);
  }

  //Update
  Future<bool> updateCompany(CompanyModel company) async{
    if(company.idCompany == null)return false;
    return await database.update(database.company).replace(company.toCompanion() as CompanyData);
  }


  Future<int> updateCompanyById(CompanyModel company) async {
    if (company.idCompany == null) return 0;

    return await (database.update(database.company)
      ..where((t) => t.id_company.equals(company.idCompany!)))
        .write(company.toCompanion());
  }


  Future<bool> companyExists() async {
    final count = await database.company.count().getSingle();
    return count > 0;
  }


}