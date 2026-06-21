import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/dashboard_provider.dart';

class WeeklySalesChart extends ConsumerWidget{
  const WeeklySalesChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final chartDataAsync = ref.watch(weeklyChartProvider);

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ventas vs Gastos (Esta Semana)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: chartDataAsync.when(
                  data: (data){
                    double maxSale = data.map((e) => e.sales).reduce((a,b) => a > b ? a : b);
                    double maxExpenses = data.map((e) => e.expenses).reduce((a,b) => a > b ? a : b);
                    double maxY = (maxSale > maxExpenses ? maxSale : maxExpenses) * 1.2;
                    if(maxY == 0)maxY = 1000;

                    return BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxY,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex){
                              return BarTooltipItem(
                                  '\$${rod.toY.toStringAsFixed(2)}',
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              );
                            }
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta){
                                const days = ['Lun','Mar','Mie','Jue','Vie','Sab','Dom'];
                                return Padding(
                                    padding: const EdgeInsetsGeometry.only(top: 8.0),
                                  child: Text(
                                    days[value.toInt()],
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),

                        barGroups: data.map((dayData){
                          return _makeGroupData(
                            dayData.dayIndex,
                            dayData.sales,
                            dayData.expenses
                          );
                        }).toList(),
                      ),
                    );
                  },
                  error: (e, stack) => Center(child: Text("Error al cargar grafica: $e"),),
                  loading:() => Center(child: const CircularProgressIndicator()),
              ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(const Color(0xFFF25410), 'Ventas'),
              const SizedBox(width: 20),
              _buildLegend(Colors.grey.shade400, 'Gastos')
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double sales, double expenses){
    return BarChartGroupData(
        x: x,
      barRods: [
        BarChartRodData(
            toY: sales,
          color: const Color(0xFFF25410),
          width: 12,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
            toY: expenses,
          color: Colors.grey.shade400,
          width: 12,
          borderRadius: BorderRadius.circular(4),
        )
      ],
    );
  }

  Widget _buildLegend(Color color, String text){
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
      ],
    );
  }

}