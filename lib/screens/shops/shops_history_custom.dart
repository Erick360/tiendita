import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingHistoryCustom extends ConsumerStatefulWidget{
  const ShoppingHistoryCustom({super.key});
  static String id = "shopping_history_today";

  @override
  ConsumerState<ShoppingHistoryCustom> createState() => _ShoppingHistoryCustom();
}

class _ShoppingHistoryCustom extends ConsumerState<ShoppingHistoryCustom>{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Historial de compras"),
        centerTitle: true,
      ),
    );
  }
}