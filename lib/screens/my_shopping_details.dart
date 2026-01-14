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
      appBar:  AppBar(
        backgroundColor: const Color(0xFFF25410),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.list_alt,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              'Reporte de compras',
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