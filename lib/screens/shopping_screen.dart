import 'package:flutter/material.dart';

class ShoppingScreen extends StatefulWidget{
  const ShoppingScreen({super.key});
  static String id = "shopping_screen";

  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:  AppBar(
        title: Text('This is shopping screen'),
      ),
    );
  }
}