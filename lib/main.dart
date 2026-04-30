import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/screens/auth/splash_screen.dart';
import 'package:tiendita/screens/category/category_screen.dart';
import 'package:tiendita/screens/category/create_category.dart';
import 'package:tiendita/screens/clients/clients_screen.dart';
import 'package:tiendita/screens/clients/create_client.dart';
import 'package:tiendita/screens/expenses/create_expense.dart';
import 'package:tiendita/screens/expenses/expenses_screen.dart';
import 'package:tiendita/screens/products/create_products.dart';
import 'package:tiendita/screens/purveyors/create_purveyors.dart';
import 'package:tiendita/screens/purveyors/purveyors_screen.dart';
import 'package:tiendita/screens/sales/sales_history_custom.dart';
import 'package:tiendita/screens/sales/sales_history_today.dart';
import 'package:tiendita/screens/shops/shops_history_custom.dart';
import 'package:tiendita/screens/shops/shops_history_today.dart';
import 'screens/home_page.dart';
import 'screens/sales_details/my_sales_details.dart';
import 'screens/sales/sales_screen.dart';
import 'screens/shop_details/my_shopping_details.dart';
import 'screens/shops/shopping_screen.dart';
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
        SalesDetails.id: (context) => const SalesDetails(),
        SalesScreen.id: (context) => const SalesScreen(),
        ShoppingScreen.id: (context) => const ShoppingScreen(),
        ShoppingDetails.id: (context) => const ShoppingDetails(),
        ProductsScreen.id: (context) => const ProductsScreen(),
        PurveyorsScreen.id: (context) => const PurveyorsScreen(),
        CompanyEditScreen.id: (context) => const CompanyEditScreen(),
        SettingsScreen.id: (context) => const SettingsScreen(),
        CompanySetupScreen.id: (context) => const CompanySetupScreen(),
        CategoryScreen.id: (context) => const CategoryScreen(),
        CreateCategory.id: (context) => const CreateCategory(),
        CreatePurveyor.id: (context) => const CreatePurveyor(),
        CreateProducts.id: (context) => const CreateProducts(),
        ClientsScreen.id: (context) => const ClientsScreen(),
        CreateClient.id: (context) => const CreateClient(),
        ShoppingHistoryToday.id: (context) => const ShoppingHistoryToday(),
        ShoppingHistoryCustom.id: (context) => const ShoppingHistoryCustom(),
        CreateExpense.id: (context) => const CreateExpense(),
        ExpensesScreen.id: (context) => const ExpensesScreen(),
        SalesHistoryToday.id: (context) => const SalesHistoryToday(),
        SalesHistoryCustom.id: (context) => const SalesHistoryCustom(),
      },
    );
  }
}
