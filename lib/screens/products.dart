import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          backgroundColor: const Color(0xFFF25410),
          elevation: 0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.bagShopping,
                  color: Colors.white,
                  size: 20,
                ),
              const SizedBox(width: 5),
              Text(
                  'Mis productos',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                ),
              ),
              ],
          ),

        )
    );
  }
}