import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/providers/shopping_provider.dart';
import 'package:tiendita/widgets/company_avatar.dart';
import 'package:tiendita/providers/expenses_provider.dart';
import 'package:tiendita/screens/dashboard/metric_card.dart';
import 'package:tiendita/screens/dashboard/quick_actions_grid.dart';
import '../../providers/salesProviders.dart';
import '../../widgets/company_name.dart';

class Dashboard extends ConsumerStatefulWidget {
  Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard>{

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
     _refreshData();
    });
  }

  Future<void> _refreshData() async {
    ref.read(salesNotifierProvider.notifier).loadSalesPerDay(now);
    ref.read(shopsNotifierProvider.notifier).loadShopsForDay(now);
    ref.read(expenseNotifierProvider.notifier).loadExpensesPerDay(now);

    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context){
    final sales = ref.watch(salesNotifierProvider);
    final shops = ref.watch(shopsNotifierProvider);
    final expenses = ref.watch(expenseNotifierProvider);

    double totalSales = 0.0;
    bool isLoadingSales = false;
    sales.when(
      data: (sales) => totalSales = sales.fold(0.0, (sum, sale) => sum + (sale?.total ?? 0.0)),
      loading: () => isLoadingSales = true,
      error: (e, stack) => print("Error loading sales: $e"),
    );

    double totalShops = 0.0;
    bool isLoadingShops = false;
    shops.when(
      data: (shops) => totalShops = shops.fold(0.0, (sum, shop) => sum + (shop?.total ?? 0.0)),
      loading: () => isLoadingShops = true,
      error: (e, stack) => print("Error loading shops: $e"),
    );

    double totalExpenses = 0.0;
    bool isLoadingExpenses = false;
    expenses.when(
        data: (exp) => totalExpenses = exp.fold(0.0, (sum, exp) => sum + (exp?.amount ?? 0.0)),
        error: (e, stack) => print("Error loading shops: $e"),
        loading: () => isLoadingExpenses = true,
    );

    double profit = totalSales - totalShops - totalExpenses;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: kActiveColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  CompanyAvatar(),
                  SizedBox(height: 10),
                  CompanyName(Colors.black, 20),
                ],
              ),
              const SizedBox(height: 8),
              Text("Resumen $kDate", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              Row(
                  children: [
                            Expanded(
                                child: MetricCard(
                                    title: "Ganancias",
                                    value: '\$${profit.toStringAsFixed(2)}',
                                    icon: Icons.trending_up,
                                    color: profit >= 0 ? Colors.blue : Colors.red,
                                    isLoading: isLoadingSales,
                                )
                            ),
                    const SizedBox(width: 16),
                            Expanded(
                                child: MetricCard(
                                    title: "Invertido",
                                    value: "${totalShops.toStringAsFixed(2)}",
                                    icon: Icons.monetization_on_outlined,
                                    color: Colors.green,
                                  isLoading: isLoadingShops,
                                ),
                            ),
                  ],
              ),
              const SizedBox(height: 24),
              Text(
                'Menu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              QuickActionsGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

