import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/screens/company/company_edit_screen.dart';
import 'package:tiendita/widgets/company_data.dart';


class SettingsScreen extends ConsumerWidget{
  const SettingsScreen({super.key});
  static String id = 'settings_screen';


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF25410),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.settings_applications,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 5),
            const Text(
                'Configuracion',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                )
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.business),
                      title: CompanyData(
                          Colors.black,
                          15
                      ),
                      subtitle: Text('Sobre mi negocio',style: TextStyle(
                        color: Colors.black
                      ),),
                      trailing:   Icon(Icons.chevron_right),
                      onTap: (){
                          Navigator.pushNamed(context, CompanyEditScreen.id);
                      },
                    ),
                    const Divider()
                  ],
                ),
          // Security settings
          ListTile(
            leading: const Icon(Icons.security),
            title: Text('Seguridad'),
            subtitle: Text('PIN y Huella digital'),
            trailing: Icon(Icons.chevron_right),
            onTap: (){

            },
          )
        ],
      ),
    );
  }
}