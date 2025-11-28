import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});
  static String id = "sales_screen";

  @override 
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is sales screen'),
      ),
    );
  }
  
}