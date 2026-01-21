import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/database/tienditaDatabase.dart';
import 'package:tiendita/models/category_model.dart';

class CategoryRepository{
  final TienditaDatabase database;
  CategoryRepository(this.database);

  //CRUD operations
  Future<int> createCategory(CategoryModel model) async{
    final category = model.toCompanion();
    return await database.into(database.categories).insert(category);
  }


  Future<CategoryModel?> getCategory() async{
    final categoryData = await (database.select(database.categories)..limit(1)).getSingleOrNull();
    if(categoryData == null)throw new Exception("No se encontro ninguna categoria");
    return CategoryModel.fromRow(categoryData);
  }


  Stream<List<CategoryModel?>> watchAllCategories() {
    return (database.select(database.categories)).watch().map(
            (rows) => rows.map((row) => CategoryModel.fromRow(row)).toList());
  }

  Future<bool> updateCategoryById(CategoryModel category) async{
    if(category.idCategory == null)return false;

    final res = await (database.update(database.categories)
      ..where((t) => t.id_category.equals(category.idCategory!)))
    .write(category.toCompanion());

    return res > 0;
  }

  Future<bool> categoryExits() async{
    final count = await database.categories.count().getSingle();
    return count > 0;
  }

  Future<int> deleteCategory(int id) async{
    return await (database.delete(database.categories)
      ..where((t) => t.id_category.equals(id))).go();
  }

}