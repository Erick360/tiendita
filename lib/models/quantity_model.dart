import 'package:flutter/cupertino.dart';

class QuantityModel {
  final int initialQuantity;
  final int maxStock;
  final ValueChanged<int> onChanged;

  const QuantityModel({
    required this.initialQuantity,
    required this.onChanged,
    required this.maxStock
  });
}