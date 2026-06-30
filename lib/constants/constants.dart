import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kActiveColor = Color(0xFFF36618);

final now = DateTime.now();
var kDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

var kExcel = Excel.createExcel();
var kFileBytes = kExcel.save();



///////////////////////////////////////////

String getDay(String date){
  String res = '';
  switch(date){
    case 'Monday':
      res = 'Lunes';
      break;
      case 'Tuesday':
      res = 'Martes';
      break;
    case 'Wednesday':
      res = 'Miercoles';
      break;
      case 'Thursday':
      res = 'Jueves';
      break;
    case 'Friday':
      res = 'Viernes';
      break;
    case 'Saturday':
      res = 'Sabado';
      break;
      case 'Sunday':
        res = 'Domingo';
        break;
  }
  return res;
}

String getMonth(String date){
  String res = '';
  switch(date){
    case 'January':
      res = 'Enero';
      break;
    case 'February':
      res = 'Febrero';
      break;
    case 'March':
      res = 'Marzo';
      break;
    case 'April':
      res = 'Abril';
      break;
      case 'May':
      res = 'Mayo';
      break;
    case 'June':
      res = 'Junio';
      break;
    case 'July':
      res = 'Julio';
      break;
    case 'August':
      res = 'Agosto';
      break;
      case 'September':
      res = 'Septiembre';
      break;
    case 'October':
      res = 'Octubre';
      break;
    case 'November':
      res = 'Noviembre';
      break;
    case 'December':
      res = 'Diciembre';
      break;
  }
  return res;
}

/////////////////////////////////////////////////

//Success Message
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.green.shade600,
      elevation: 6.0,
      content: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

//Error Message
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.red.shade600,
      elevation: 6.0,
      content: Row(
        children: [
          const Icon(
            Icons.error_outline_sharp,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}