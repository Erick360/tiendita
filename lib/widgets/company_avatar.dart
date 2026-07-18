import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tiendita/providers/company_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyAvatar extends ConsumerWidget{
  const CompanyAvatar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref){
    final companyIcon = ref.watch(companyLogoStreamProvider).value;
    double avatarRadius = MediaQuery.of(context).size.width * 0.15;

      return CircleAvatar(
        radius: avatarRadius,
        backgroundImage: companyIcon != null && companyIcon.isNotEmpty ? FileImage(File(companyIcon)) as ImageProvider : null,
        child: companyIcon == null || companyIcon.isEmpty ? Icon(Icons.person, size: avatarRadius, color: Colors.blue) : null,
      );
  }
}