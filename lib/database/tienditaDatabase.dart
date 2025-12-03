import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'tienditaDatabase.g.dart';

enum ProductStatus {
  active, // 0
  inactive, // 1
  pending // val = 2
}


class Categories extends Table{
  IntColumn get id_category => integer().autoIncrement()();
  TextColumn get category => text().withLength(min: 1, max: 50)();
}

class Purveyors extends Table{
  IntColumn get id_purveyor => integer().autoIncrement()();
  TextColumn get rfc => text().withLength(min: 1, max: 12)();
  TextColumn get purveyor_name => text().withLength(min: 1, max: 100)();//razon social
  TextColumn get phone_number => text().withLength(min: 1, max: 12)();
  TextColumn get email => text().withLength(min: 1, max: 50)();
  TextColumn get address => text().withLength(min: 1, max: 100)();
// date and state
}

class Products extends Table{
  //Primary key
  IntColumn get id_product => integer().autoIncrement()();
  //Columns
  TextColumn get productName => text().withLength(min: 1, max: 100)();//nombre producto
  TextColumn get presentationProduct => text().withLength(min: 1, max: 100)();//presentacion producto
  IntColumn get units => integer()();//unidades disponibles
  TextColumn get localCoin => text().withLength(min: 1, max: 45)();//moneda
  RealColumn get price_shop => real()();//precio de compra
  RealColumn get price_sale => real()();//precio de venta
  IntColumn get stock => integer()();
  // it shows if a product is available ("Pending,active,inactive")
  IntColumn get status => intEnum<ProductStatus>().withDefault(const Constant(2))();
  TextColumn get productImage => text().withLength(min: 1, max: 255)();//storage an image
  DateTimeColumn get product_expires_at => dateTime().nullable()();

  //foreign key
  IntColumn get id_category => integer().references(Categories, #id_category, onDelete: KeyAction.cascade)();
}


class Sales extends Table{
  IntColumn get id_sales => integer().autoIncrement()();
  DateTimeColumn get sale_date => dateTime().nullable()();
  TextColumn get num_sale => text().withLength()();
  TextColumn get local_coin => text().withLength(min: 1,max: 50)();
  RealColumn get subtotal => real()();
  RealColumn get total => real()();
}

class SalesDetails extends Table{
  IntColumn get id_sales_detail => integer().autoIncrement()();
  TextColumn get local_coin => text().withLength(min: 1, max: 50)();
  RealColumn get price_sale => real()();
  RealColumn get amount_sale => real()();
  RealColumn get total_sales => real()();
  DateTimeColumn get sale_date => dateTime().nullable()();

  //foreign key
  IntColumn get id_product => integer().references(Products, #id_product, onDelete: KeyAction.cascade)();
  IntColumn get id_sale => integer().references(Sales, #id_sales, onDelete: KeyAction.cascade)();
}

class Shopping extends Table{
  IntColumn get id_shops => integer().autoIncrement()();
  DateTimeColumn get shop_date => dateTime().nullable()();
  TextColumn get num_shop => text().withLength(min: 1,max: 100)();
  TextColumn get local_coin => text().withLength(min: 1, max: 50)();
  RealColumn get subtotal => real()();
  RealColumn get total => real()();

  //foreign key
  IntColumn get id_purveyor => integer().references(Purveyors, #id_purveyor, onDelete: KeyAction.cascade)();
}

class ShoppingDetails extends Table{
  IntColumn get id_shopping_details => integer().autoIncrement()();
  TextColumn get num_shop => text().withLength(min: 1,max: 100)();
  TextColumn get rfc_purveyor => text().withLength(min: 1, max: 100)();
  TextColumn get product => text().withLength(min: 1, max: 100)();
  TextColumn get local_coin => text().withLength(min: 1, max: 100)();
  RealColumn get price_shop => real()();
  RealColumn get amount_shop => real()();
  RealColumn get discount => real()();
  DateTimeColumn get shop_date => dateTime().nullable()();

  //foreign keys
  IntColumn get id_purveyor => integer().references(Purveyors, #id_purveyor, onDelete: KeyAction.cascade)();
  IntColumn get id_category => integer().references(Categories, #id_category, onDelete: KeyAction.cascade)();
}

class Expensives extends Table{
   IntColumn get id_expensives => integer().autoIncrement()();
   TextColumn get expensive_name => text().withLength(min: 1, max: 100)();
   TextColumn get description => text().withLength(max: 255).nullable()();
   RealColumn get amount => real()();
   TextColumn get localCoin => text().withLength(max: 50, min: 1)();
   DateTimeColumn get expenseDate => dateTime().nullable()();

   //foreign key
  IntColumn get id_category => integer().references(Categories, #id_category, onDelete: KeyAction.cascade)();
}

class Company extends Table{
  IntColumn get id_company => integer().autoIncrement()();
  TextColumn get name_company => text().withLength(min: 1, max: 40)();
  TextColumn get logo_company => text().withLength(min: 1, max: 255)();
  TextColumn get address_company => text().withLength(min: 1, max: 50)();
  TextColumn get phone_number_company => text().withLength(min: 1, max: 12)();
  TextColumn get rfc_company => text().withLength(min: 1, max: 15)();
  TextColumn get email_company => text().withLength(min: 1,max:50)();

}


@DriftDatabase(tables: [
    Categories,
    Purveyors,
    Products,
    Sales,
    SalesDetails,
    Shopping,
    ShoppingDetails,
    Company
])

class TienditaDatabase extends _$TienditaDatabase {
  TienditaDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

}
  LazyDatabase _openConnection(){
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db_tiendita.sqlite'));
      return NativeDatabase(file);
    });
}

