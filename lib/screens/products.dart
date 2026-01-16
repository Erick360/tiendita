import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProducts extends ConsumerStatefulWidget{
  const MyProducts({super.key});
  static String id = "products";

  @override
  ConsumerState<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends ConsumerState<MyProducts>{
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

        ),
      body: Column(

      ),
    );
  }
}