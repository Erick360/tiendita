import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/screens/auth/splash_screen.dart';
import 'package:tiendita/screens/category/category_screen.dart';
import 'package:tiendita/screens/category/create_category.dart';
import 'package:tiendita/screens/products/create_products.dart';
import 'package:tiendita/screens/purveyors/create_purveyors.dart';
import 'package:tiendita/screens/purveyors/purveyors_screen.dart';
import 'screens/home_page.dart';
import 'screens/my_sales_details.dart';
import 'screens/sales_screen.dart';
import 'screens/my_shopping_details.dart';
import 'screens/shopping_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/company/company_edit_screen.dart';
import 'screens/company/company_setup_screen.dart';
import 'screens/products/products.dart';


void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: SplashScreen(),
      //initialRoute: SplashScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        MySalesDetails.id: (context) => const MySalesDetails(),
        SalesScreen.id: (context) => const SalesScreen(),
        ShoppingScreen.id: (context) => const ShoppingScreen(),
        MyShoppingDetails.id: (context) => const MyShoppingDetails(),
        ProductsScreen.id: (context) => const ProductsScreen(),
        PurveyorsScreen.id: (context) => const PurveyorsScreen(),
        CompanyEditScreen.id: (context) => const CompanyEditScreen(),
        SettingsScreen.id: (context) => const SettingsScreen(),
        CompanySetupScreen.id: (context) => const CompanySetupScreen(),
        CategoryScreen.id: (context) => const CategoryScreen(),
        CreateCategory.id: (context) => const CreateCategory(),
        CreatePurveyor.id: (context) => const CreatePurveyor(),
        CreateProducts.id: (context) => const CreateProducts(),
      },
    );
  }
}
