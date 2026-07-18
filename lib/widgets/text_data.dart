import 'package:flutter/material.dart';
import 'package:tiendita/models/text_data_model.dart';

class TextData extends StatelessWidget{
  final TextDataModel model;
  const TextData({super.key, required this.model});

  @override
  Widget build(BuildContext context){
    return Text(
      model.text,
      style: TextStyle(
        color: model.color,
        fontSize: model.font,
        fontFamily: model.fontFamily,
        fontWeight: model.weight
      ),
    );
  }
}