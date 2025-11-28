import 'package:flutter/material.dart';

class MyShoppingDetails extends StatefulWidget{
  const MyShoppingDetails({super.key});

  static String id = "my_shopping_details";

  @override
  State<MyShoppingDetails> createState() => _MyShoppingDetailsState();
}

class _MyShoppingDetailsState extends State<MyShoppingDetails>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de ventas'),
      ),
    );
  }
}