import 'package:flutter/material.dart';

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
          title: Text('Purveyors List'),
        )
    );
  }
}