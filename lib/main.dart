import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/providers/theme_provider.dart';
import 'package:tiendita/screens/auth/authentication.dart';
import 'package:tiendita/screens/settings/change_pin.dart';
import 'package:tiendita/screens/settings/import_export_database.dart';
import 'package:tiendita/screens/splash_screen.dart';
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
import 'screens/products/products_screen.dart';


void main() {
  runApp(const ProviderScope(
    child: TienditaApp(),
  ));
}

class TienditaApp extends ConsumerWidget {
  const TienditaApp({super.key});

  //late FlutterLocalNotificationsPlugin notification;

  /*
  @override
  void initState(){
    super.initState();
    notification = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid
    );
    notification.initialize(settings: initializationSettings);    
  }
  */

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tiendita",
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: kActiveColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: kActiveColor),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: kActiveColor,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1E1E1E)),
        colorScheme: ColorScheme.fromSeed(
            seedColor: kActiveColor,
          brightness: Brightness.dark
        )
      ),

      home:  SplashScreen(),
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
        AuthScreen.id: (context) => AuthScreen(),
        ImportExportDatabase.id: (context) => ImportExportDatabase(),
        ChangePinScreen.id: (context) => ChangePinScreen(),
      },
    );
  }
}
