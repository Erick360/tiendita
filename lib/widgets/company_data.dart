import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/company_provider.dart';

class CompanyData extends ConsumerWidget{
  const CompanyData(this.color,this.font,{
    super.key,
    this.alignment = TextAlign.start
  });

  final double font;
  final Color color;
  final TextAlign alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final companyData = ref.watch(companyStreamProvider);
    return Text(
      companyData.value?.nameCompany ?? 'Mi Negocio',
      textAlign: alignment,
      style: TextStyle(
        color: color,
        fontSize: font,
        fontFamily: 'Poppins',
      ),
    );
  }
}

