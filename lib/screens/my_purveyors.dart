import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyPurveyors extends StatefulWidget{
  const MyPurveyors({super.key});
  static String id = "my_purveyors";

  @override
  State<MyPurveyors> createState() => _MyPurveyorsState();
}

class _MyPurveyorsState extends State<MyPurveyors>{

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
                FontAwesomeIcons.truck,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                'Mis Proveedores',
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