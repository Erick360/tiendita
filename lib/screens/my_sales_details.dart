import 'package:flutter/material.dart';

class MySalesDetails extends StatefulWidget{
  const MySalesDetails({super.key});

  static String id = "my_sales_details";
  @override
  State<MySalesDetails> createState() => _MySalesDetailsState();
}

class _MySalesDetailsState extends State<MySalesDetails>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de ventas'),
      ),
    );
  }
}