import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/products_provider.dart';
import 'package:tiendita/screens/products/products_data_source.dart';
import '../../constants/constants.dart';
import '../../models/text_data_model.dart';
import '../../widgets/text_data.dart';


class ProductsTable extends ConsumerStatefulWidget{
  const ProductsTable({super.key});

  @override
  ConsumerState<ProductsTable> createState() => _ProductsTableState();
}

class _ProductsTableState extends ConsumerState<ProductsTable> {
  ProductsDataSource? _dataSource;

  @override
  Widget build(BuildContext context){
    
    final products = ref.watch(productsListProvider);

    Future<void> confirmDelete(BuildContext context, int id) async{
      final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text("Eliminar Producto"),
              content: const Text("¿Estás seguro de que deseas eliminar este producto? Esta acción no se puede deshacer."),
              shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Canceler", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Eliminar", style: TextStyle(color: Colors.white))
                ),
              ],
            );
          }
      );
      if(confirm == true && context.mounted){
        await ref.read(productsNotifierProvider.notifier).deleteProduct(id);

        showSuccessSnackBar(context, 'Producto eliminado correctamente');
      }
    }

    return products.when(
        data: (products){
          if(_dataSource == null){
            _dataSource = ProductsDataSource(products: products, context: context, onDelete: (id) => confirmDelete(context, id), ref: ref);
          } else{
            _dataSource!.updateData(products);
          }
          return PaginatedDataTable(
            header: Center(
              child: Text(
                "Lista de productos",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
            headingRowHeight: 60,
            dataRowMaxHeight: 60,
            columnSpacing: 20,
            showCheckboxColumn: false,
            columns: [
              DataColumn(
                label: TextData(
                  model: TextDataModel(
                  'Producto',
                  18,
                  Colors.black,
                  "Poppins",
                  FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: TextData(
                  model: TextDataModel(
                  'Presentacion',
                  18,
                  Colors.black,
                  "Poppins",
                  FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: TextData(
                  model: TextDataModel(
                  'Unidad de\nmedida',
                  18,
                  Colors.black,
                  "Poppins",
                  FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: TextData(
                  model: TextDataModel(
                  'Precio de\ncompra',
                  18,
                  Colors.black,
                  "Poppins",
                  FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: TextData(
                  model: TextDataModel(
                  'Precio de\nventa',
                  18,
                  Colors.black,
                  "Poppins",
                  FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: TextData(
                  model: TextDataModel(
                  'Stock',
                  18,
                  Colors.black,
                  "Poppins",
                  FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: TextData(
                  model: TextDataModel(
                  'Status',
                  18,
                  Colors.black,
                  "Poppins",
                  FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: TextData(
                  model: TextDataModel(
                  'Imagen',
                  18,
                  Colors.black,
                  "Poppins",
                  FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: TextData(
                  model: TextDataModel(
                  'Fecha de\ncaducidad',
                  18,
                  Colors.black,
                  "Poppins",
                  FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: TextData(
                  model: TextDataModel(
                  'Categoria',
                  18,
                  Colors.black,
                  "Poppins",
                  FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: TextData(
                  model: TextDataModel(
                  'Editar',
                  18,
                  Colors.black,
                  "Poppins",
                  FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: TextData(
                  model: TextDataModel(
                  'Eliminar',
                  18,
                  Colors.black,
                  "Poppins",
                  FontWeight.bold,
                ),
              ),
              ),
            ],
            source: _dataSource!,
          );
        },
        error: (e, stack) => Center(child: Text('Error $e')),
        loading: () => Center(child: CircularProgressIndicator())
    );

  }
}