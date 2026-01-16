import 'package:drift/drift.dart';
import 'package:tiendita/database/tienditaDatabase.dart';
import 'package:tiendita/model/category_model.dart';

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

  Stream<CategoryModel?> watchCategory() {
    return (database.select(database.categories)..limit(1))
        .watchSingleOrNull().map((data) => data != null ? CategoryModel.fromRow(data) : null);
  }

  Future<int> updateCategoryById(CategoryModel category) async{
    if(category.idCategory == null)return 0;

    return await (database.update(database.categories)
      ..where((t) => t.id_category.equals(category.idCategory!)))
    .write(category.toCompanion());
  }

  Future<bool> categoryExits() async{
    final count = await database.categories.count().getSingle();
    return count > 0;
  }
}