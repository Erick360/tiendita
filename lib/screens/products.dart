import 'package:flutter/material.dart';

class MyProducts extends StatefulWidget{
  const MyProducts({super.key});
  static String id = "products";

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts>{
  @override
  Widget build (BuildContext context){
    return Scaffold(
        appBar:  AppBar(
          title: Text('My products'),
        )
    );
  }
}