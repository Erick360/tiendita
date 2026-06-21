import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:tiendita/models/products_model.dart';
import '../../database/tienditaDatabase.dart';
import '../../providers/category_provider.dart';
import 'edit_products.dart';

class ProductsDataSource extends DataTableSource {
  final List<ProductsModel?> products;
  final BuildContext context;
  final Function(int) onDelete;
  final WidgetRef ref;

  ProductsDataSource({
    required this.products,
    required this.context,
    required this.onDelete,
    required this.ref
  });


  @override
  DataRow? getRow(int index) {
    if (index >= products.length) return null;

    final product = products[index];

    return DataRow(
      cells: [
        DataCell(
          Text(
            product?.productName ?? "sin Nombre",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Text(
            product?.presentation ?? "sin Presentacion",
            style: TextStyle(fontSize: 15),
          ),
        ),
        DataCell(
          Row(
              children: [
                Icon(Iconsax.ruler_outline, size: 20),
                const SizedBox(width: 4),
                Text(
                    product?.units ?? "sin medida",
                    style: TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ],
          ),
        ),
        DataCell(
          Row(
            children: [
              Icon(Icons.attach_money, size: 20),
              //SizedBox(width: 2),
              Text(
                product?.priceShop?.toStringAsFixed(2) ?? "sin precio de Compra",
                style: TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            children: [
              Icon(Icons.attach_money, size: 20),
              Text(
                product?.priceSale?.toStringAsFixed(2) ?? "sin precio de Venta",
                style: TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            children: [
              Icon(Bootstrap.bag_check, size: 20),
              const SizedBox(width: 2),
              Text(
                "${product?.stock ?? "no stock"}",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),

        ),
        DataCell(
          Row(
            children: [
              Icon(Icons.list_alt, size: 20),
              const SizedBox(width: 2),
              Text(
                product?.status==1  ? "Disponible" : "No Disponible",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),

        ),
        DataCell(
          product?.productImage != null
              ? SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.file(
                    File(product!.productImage!),
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
        DataCell(
          Text(
            product?.productExpiresAt != null
                ? DateFormat('dd/MM/yy').format(product!.productExpiresAt!)
                : "Sin fecha de caducidad",
            style: const TextStyle(fontSize: 15),
          ),
        ),
        DataCell(
          product?.idCategory != null
              ? FutureBuilder<Category?>(
                  future: ref.read(categoryRepositoryProvider).showCategory(product!.idCategory!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    if (snapshot.hasError || snapshot.data == null) {
                      return const Text(
                        "Error/Deleted",
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      );
                    }
                    return Text(
                      snapshot.data!.category,
                      style: const TextStyle(fontSize: 15),
                    );
                  },
                )
              : const Text("Sin categoria", style: TextStyle(fontSize: 15)),
        ),
        DataCell(
          IconButton(
            icon: Icon(
              FontAwesomeIcons.penToSquare,
              color: Colors.blueAccent,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProducts(product!)),
              );
            },
          ),
        ),

        DataCell(
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              if (product?.idProduct != null) {
                onDelete(product!.idProduct!);
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
  int get rowCount => products.length;

  @override
  int get selectedRowCount => 0;
}
