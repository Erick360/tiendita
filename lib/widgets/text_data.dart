import 'package:flutter/material.dart';

class TextData extends StatelessWidget{
  const TextData(
      this.text,
      this.font,
      this.color,
      this.fontFamily,
      this.weight,
      {Key? key}) : super(key: key);
  final double font;
  final String text;
  final Color color;
  final String fontFamily;
  final FontWeight weight;

  @override
  Widget build(BuildContext context){
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: font,
        fontFamily: fontFamily,
        fontWeight: weight
      ),
    );
  }
}