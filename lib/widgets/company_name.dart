import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/company_provider.dart';

class CompanyName extends ConsumerWidget{
  const CompanyName(this.color,this.font,{
    super.key,
    this.alignment = TextAlign.start
  });

  final double font;
  final Color color;
  final TextAlign alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final companyName = ref.watch(companyStreamProvider);
    return Text(
      companyName.value?.nameCompany ?? 'Mi Negocio',
      textAlign: alignment,
      style: TextStyle(
        color: color,
        fontSize: font,
        fontFamily: 'Poppins',
      ),
    );
  }
}

