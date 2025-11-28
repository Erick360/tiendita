import 'package:drift/drift.dart';
import 'package:tiendita/database/tienditaDatabase.dart';

class CompanyModel{
  final int? idCompany;
  final String nameCompany;
  final String? logoCompany;
  final String addressCompany;
  final String phoneNumberCompany;
  final String? rfcCompany;
  final String emailCompany;

  CompanyModel({
    this.idCompany,
    required this.nameCompany,
    this.logoCompany,
    required this.addressCompany,
    required this.phoneNumberCompany,
    this.rfcCompany,
    required this.emailCompany
  });

  //insert and update
  CompanyCompanion toCompanion(){
    return CompanyCompanion(
      id_company: idCompany != null ? Value(idCompany!) : const Value.absent(),
      name_company: Value(nameCompany),
      logo_company: logoCompany != null ? Value(logoCompany!) : const Value.absent(),
      address_company: Value(addressCompany),
      phone_number_company: Value(phoneNumberCompany),
      rfc_company: rfcCompany != null ? Value(rfcCompany!) : const Value.absent(),
      email_company: Value(emailCompany)
    );
  }

  factory CompanyModel.fromRow(CompanyData row){
    return CompanyModel(
        idCompany: row.id_company,
        nameCompany: row.name_company,
        logoCompany: row.logo_company,
        addressCompany: row.address_company,
        phoneNumberCompany: row.phone_number_company,
        emailCompany: row.email_company,
        rfcCompany: row.rfc_company
    );
  }
}