import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tiendita/constants/constants.dart';

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
      appBar:  AppBar(
        backgroundColor: kActiveColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.point_of_sale_sharp,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              'Ventas',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}