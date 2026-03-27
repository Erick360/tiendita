import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiendita/constants/constants.dart';

class ShoppingHistoryToday extends ConsumerStatefulWidget{
  const ShoppingHistoryToday({super.key});
  static String id = "shopping_history_today";

  @override
  ConsumerState<ShoppingHistoryToday> createState() => _ShoppingHistoryToday();
}

class _ShoppingHistoryToday extends ConsumerState<ShoppingHistoryToday>{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kActiveColor,
        elevation: 0,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.history, color: Colors.white, size: 20),
            const SizedBox(width: 5),
            Text("Historial de compras "),
          ]
        ),
        centerTitle: true,
        ),
      );
  }
}