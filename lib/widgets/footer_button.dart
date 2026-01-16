import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiendita/widgets/text_data.dart';
class FooterButton extends StatelessWidget{
  final String label;
  final String imagePath;
  final VoidCallback onPressed;

  const FooterButton(
      this.label,
  this.imagePath,
  this.onPressed,
      {super.key});

  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: Image.asset(imagePath),
            ),
            const SizedBox(height: 2),
            TextData(label, 12, Colors.white, 'Monserrat', FontWeight.bold)
          ],
        ),
      ),
    );
  }

}