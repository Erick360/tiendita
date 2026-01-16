import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiendita/screens/company/company_edit_screen.dart';
import 'package:tiendita/screens/products.dart';
import 'category_screen.dart';
import 'sales_screen.dart';
import 'package:tiendita/screens/my_sales_details.dart';
import 'my_shopping_details.dart';
import 'shopping_screen.dart';
import 'package:tiendita/widgets/footer.dart';
import 'package:tiendita/screens/my_purveyors.dart';
import 'package:tiendita/widgets/company_data.dart';
import 'package:tiendita/widgets/company_avatar.dart';
import 'package:tiendita/widgets/company_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = "home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    Navigator.pop(context);

    switch (index) {
      case 0:
        Navigator.pushNamed(context, HomeScreen.id);
        break;
      case 1:
        Navigator.pushNamed(context, SalesScreen.id);
        break;
      case 2:
        Navigator.pushNamed(context, ShoppingScreen.id);
        break;
      case 3:
        Navigator.pushNamed(context, CompanyEditScreen.id);
        break;
      case 4:
        Navigator.pushNamed(context, MySalesDetails.id);
        break;
      case 5:
        Navigator.pushNamed(context, MyShoppingDetails.id);
        break;
      case 6:
        Navigator.pushNamed(context, MyProducts.id);
        break;
      case 7:
        Navigator.pushNamed(context, MyPurveyors.id);
        break;
      case 8:
        Navigator.pushNamed(context, CategoryScreen.id);
        break;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: CompanyData(Colors.white, 22,),
        backgroundColor: Color(0xFFF25410),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: Icon(Icons.menu),
        ),
      ),
      body: Center(child: Text('Dashboard')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFF25410)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CompanyAvatar(),
                  SizedBox(height: 10),
                  CompanyData(Colors.white, 20),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_filled),
              title: const Text('Inicio'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            // Sales section
            ListTile(
              leading: const Icon(Icons.monetization_on),
              title: const Text('Ventas'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            // Shopping section
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Compras'),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            // Business Section
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Mi Negocio'),
              selected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
            // Sales Details
            ListTile(
              leading: const Icon(Icons.auto_graph),
              title: const Text('Reporte de Ventas'),
              selected: _selectedIndex == 4,
              onTap: () => _onItemTapped(4),
            ),
            // Shopping Details
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Reporte de compras'),
              selected: _selectedIndex == 5,
              onTap: () => _onItemTapped(5),
            ),
            // Products
            ListTile(
              leading: const Icon(Icons.shopping_basket),
              title: const Text('Mis Productos'),
              selected: _selectedIndex == 6,
              onTap: () => _onItemTapped(6),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.truckFast),
              title: const Text('Mis Proveedores'),
              selected: _selectedIndex == 7,
              onTap: () => _onItemTapped(7),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.listCheck),
              title: const Text('Categorias'),
              selected: _selectedIndex == 8,
              onTap: () => _onItemTapped(8),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
