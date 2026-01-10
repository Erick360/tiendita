import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tiendita/providers/company_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyAvatar extends ConsumerWidget{
  CompanyAvatar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref){
    final CompanyIcon = ref.watch(companyLogoStreamProvider).value;
    double avatarRadius = MediaQuery.of(context).size.width * 0.10;

      return CircleAvatar(
        radius: avatarRadius,
        backgroundImage: CompanyIcon != null && CompanyIcon.isNotEmpty ? FileImage(File(CompanyIcon)) as ImageProvider : null,
        child: CompanyIcon == null || CompanyIcon.isEmpty ? Icon(Icons.person, size: avatarRadius, color: Colors.blue) : null,
      );
  }
}