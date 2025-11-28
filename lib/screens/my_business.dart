import 'package:flutter/material.dart';
import 'package:tiendita/database/tienditaDatabase.dart';
import 'package:drift/drift.dart' as drift;
import 'package:tiendita/widgets/company_form.dart';
import 'dart:io';

class MyBusiness extends StatefulWidget{
  const MyBusiness({super.key});

  static String id = "my_business";

  @override
  State<MyBusiness> createState() => _MyBusinessState();
}

class _MyBusinessState extends State<MyBusiness>{
  //database
  final TienditaDatabase _database = TienditaDatabase();


  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar:  AppBar(
        title: Text('This is my business '),
      ),
      body: CompanyForm(
      ),
    );
  }
}