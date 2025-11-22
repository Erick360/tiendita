import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget{
  const  HomeScreen ({super.key});
  static String id = "home_screen";
  State<HomeScreen> createState() =>  _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  int _selectedIndex = 0;

  static const List<Widget> _options = <Widget>[
    Center(child: Text('Ventas', style: TextStyle(fontSize: 22))),
    Center(child: Text('Compras', style: TextStyle(fontSize: 22))),
    Center(child: Text('Mi Negocio', style: TextStyle(fontSize: 22))),
    Center(child: Text('Detalle Ventas', style: TextStyle(fontSize: 22))),
    Center(child: Text('Detallle Compras', style: TextStyle(fontSize: 22))),
    Center(child: Text('Mis Productos', style: TextStyle(fontSize: 22)))
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _options[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(decoration: BoxDecoration(
              color: Colors.blue
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text('Company Name', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            // Sales section
            ListTile(
              leading: const Icon(Icons.monetization_on),
              title: const Text('Ventas'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            // Shopping section
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Compras'),
              selected: _selectedIndex == 1,
              onTap: () =>  _onItemTapped(1),
            ),
            // Business Section
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Mi Negocio'),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            // Sales Details
            ListTile(
              leading: const Icon(Icons.list_sharp),
              title: const Text('Detalle de Ventas'),
              selected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
            // Shopping Details
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Detalle de compras'),
              selected: _selectedIndex == 4,
              onTap: () => _onItemTapped(4),
            ),
            // Products
            ListTile(
              leading: const Icon(Icons.shopping_basket),
              title: const Text('Mis Productos'),
              selected: _selectedIndex == 5,
              onTap: () => _onItemTapped(5),
            )
          ],
        ),
      ),
    );
  }

}

