import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/company_provider.dart';
import 'package:tiendita/screens/company/company_edit_screen.dart';
import 'package:tiendita/widgets/company_data.dart';
import 'package:tiendita/model/company_model.dart';

class SettingsScreen extends ConsumerWidget{
  const SettingsScreen({super.key});
  static String id = 'settings_screen';


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company =  ref.read(companyRepositoryProvider).getCompany();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion'),
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