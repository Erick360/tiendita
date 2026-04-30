import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Footer extends StatelessWidget{
  const Footer({super.key});

  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                        'Copyright © New Horizons ${DateTime
                        .now()
                        .year}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
    );
  }
}



