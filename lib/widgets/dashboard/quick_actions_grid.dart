import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiendita/screens/my_sales_details.dart';
import 'package:tiendita/screens/my_shopping_details.dart';
import 'package:tiendita/screens/products/products.dart';
import 'package:tiendita/screens/sales/sales_screen.dart';
import 'package:tiendita/screens/shops/shopping_screen.dart';
import 'package:tiendita/widgets/dashboard/quick_action_button.dart';

import '../../screens/category/category_screen.dart';
import '../../screens/clients/clients_screen.dart';
import '../../screens/company/company_edit_screen.dart';
import '../../screens/purveyors/purveyors_screen.dart';

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
          title: 'Productos',
          icon: Icons.inventory_2,
          color: Colors.blue,
          onTap: () => Navigator.pushNamed(context, ProductsScreen.id),
        ),
        QuickActionButton(
            title: 'Categorias',
            icon: FontAwesomeIcons.listCheck,
            color: Colors.lightGreen,
            onTap: () => Navigator.pushNamed(context, CategoryScreen.id)
        ),
        QuickActionButton(
          title: 'Ventas',
          icon: Icons.point_of_sale,
          color: Colors.cyanAccent,
          onTap: () => Navigator.pushNamed(context, SalesScreen.id)
        ),
        QuickActionButton(
            title: 'Compras',
            icon: Icons.monetization_on,
            color: Colors.green,
            onTap: () => Navigator.pushNamed(context, ShoppingScreen.id)
        ),
        QuickActionButton(
          title: 'Gastos',
          icon: Icons.receipt,
          color: Colors.orange,
          onTap: () {},
        ),
        QuickActionButton(
            title: 'Mi Negocio',
            icon: Icons.store,
            color: Colors.redAccent,
            onTap: () => Navigator.pushNamed(context, CompanyEditScreen.id)
        ),
        QuickActionButton(
          title: 'Reportes Ventas',
          icon: Icons.bar_chart,
          color: Colors.purple,
          onTap: () => Navigator.pushNamed(context, MySalesDetails.id),
        ),
        QuickActionButton(
            title: 'Reporte Compras',
            icon: Icons.bar_chart_sharp,
            color: Colors.amberAccent,
            onTap: () => Navigator.pushNamed(context, MyShoppingDetails.id)
        ),
        QuickActionButton(
            title: 'Mis Proveedores',
            icon: FontAwesomeIcons.truckFast,
            color: Colors.indigoAccent,
            onTap: () => Navigator.pushNamed(context, PurveyorsScreen.id)
        ),
        QuickActionButton(
            title: 'Mis Clientes',
            icon: Icons.people,
            color: Colors.blueAccent,
            onTap: () => Navigator.pushNamed(context, ClientsScreen.id)
        )
      ],
    );
  }
}