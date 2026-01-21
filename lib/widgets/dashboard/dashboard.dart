import 'package:flutter/material.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/widgets/dashboard/metric_card.dart';
import 'package:tiendita/widgets/dashboard/quick_actions_grid.dart';


class Dashboard extends StatelessWidget{
  Dashboard({super.key});

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dashboard",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Resumen $kDate", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          Row(
              children: [
                Expanded(
                    child: MetricCard(
                        title: "Ventas hoy",
                        value: '\$0.00',
                        icon: Icons.attach_money,
                        color: Colors.green
                    )
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: MetricCard(
                        title: "Productos",
                        value: "0",
                        icon: Icons.inventory_2,
                        color: Colors.blue
                    )
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: MetricCard(
                        title: "Stock Bajo",
                        value: "2",
                        icon: Icons.warning_amber_rounded,
                        color: Colors.orangeAccent
                    )
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: MetricCard(
                        title: "Ganancias",
                        value: "\$10.00",
                        icon: Icons.trending_up,
                        color: Colors.purple
                    )
                )
              ],
          ),
          const SizedBox(height: 24),
          Text(
            'Acciones Rápidas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          QuickActionsGrid(),
        ],
      ),
    );
  }
}

