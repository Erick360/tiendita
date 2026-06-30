import 'package:flutter/material.dart';
import 'package:tiendita/models/category_model.dart';

import 'edit_category.dart';

class CategoryDataSource extends DataTableSource {
  final List<CategoryModel?> categories;
  final BuildContext context;
  final Function(int) onDelete;

  CategoryDataSource({
    required this.categories,
    required this.context,
    required this.onDelete
  });

  @override
  DataRow? getRow(int index){
    if(index >= categories.length)return null;
    final category = categories[index];
    
    return DataRow(
      cells: [
        DataCell(
          Text(
            category?.CategoryName ?? "Sin nombre",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: Colors.blueAccent,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder:(context) => EditCategory(category!)));
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              if(category?.idCategory != null){
                onDelete(category!.idCategory!);
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categories.length;

  @override
  int get selectedRowCount => 0;
}