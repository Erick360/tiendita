import 'package:flutter/material.dart';
import 'package:tiendita/widgets/text_data.dart';
import 'package:tiendita/models/footer_model.dart';
import '../models/text_data_model.dart';

class FooterButton extends StatelessWidget{
final FooterModel model;
const FooterButton({super.key, required this.model});

  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: model.onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: Image.asset(model.imagePath),
            ),
            const SizedBox(height: 2),
            TextData(
              model: TextDataModel(
                model.label,
                12,
                Colors.white,
                'Monserrat',
                FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

}