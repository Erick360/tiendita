import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/company_provider.dart';

class CompanyData extends ConsumerWidget{
  const CompanyData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final companyData = ref.watch(companyStreamProvider);
    return Text(
      companyData.value?.nameCompany ?? 'Mi Negocio',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontFamily: 'Poppins',
      ),
    );
  }
}

