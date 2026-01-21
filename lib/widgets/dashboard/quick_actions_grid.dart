import 'package:flutter/material.dart';
import 'package:tiendita/screens/my_sales_details.dart';
import 'package:tiendita/screens/products.dart';
import 'package:tiendita/widgets/dashboard/quick_action_button.dart';

class QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        QuickActionButton(
          title: 'Nueva Venta',
          icon: Icons.point_of_sale,
          color: Colors.green,
          onTap: () {
            // Navigate to sales screen
          },
        ),
        QuickActionButton(
          title: 'Productos',
          icon: Icons.inventory_2,
          color: Colors.blue,
          onTap: () => Navigator.pushNamed(context, MyProducts.id),
        ),
        QuickActionButton(
          title: 'Gastos',
          icon: Icons.receipt,
          color: Colors.orange,
          onTap: () {},
        ),
        QuickActionButton(
          title: 'Reportes',
          icon: Icons.bar_chart,
          color: Colors.purple,
          onTap: () => MySalesDetails.id,
        ),
      ],
    );
  }
}