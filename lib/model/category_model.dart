import 'package:drift/drift.dart';
import 'package:tiendita/database/tienditaDatabase.dart';

class CategoryModel{
  final int? idCategory;
  final String? CategoryName;

  CategoryModel({
   this.idCategory,
   required this.CategoryName
  });

  CategoriesCompanion toCompanion(){
    return CategoriesCompanion(
      id_category: idCategory != null ? Value(idCategory!) : const Value.absent(),
      category: Value(CategoryName!)
    );
  }

  factory CategoryModel.fromRow (Category row){
    return CategoryModel(
      idCategory: row.id_category,
      CategoryName: row.category
    );
  }
}