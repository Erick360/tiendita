import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/company_provider.dart';
import 'package:tiendita/screens/company/company_edit_screen.dart';

class SettingsScreen extends ConsumerWidget{
  const SettingsScreen({super.key});
  static String id = 'settings_screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyState = ref.watch(companyNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion'),
      ),
      body: ListView(
        children: [
          companyState.when(
              data: (company) {
                if(company== null)return const SizedBox();
                return Column(
                  children: [
                    ListTile(
                        leading: Icon(Icons.business),
                      title: Text('Mi Negocio'),
                      subtitle: Text(company.nameCompany),
                      trailing:   Icon(Icons.chevron_right),
                      onTap: (){
                          Navigator.pushNamed(context, CompanyEditScreen.id);
                      },
                    ),
                    const Divider()
                  ],
                );
              },
              error: (e, _) => ListTile(
                leading: Icon(Icons.error, color: Colors.red),
                title: Text('Error: $e'),
              ),
              loading: () => const ListTile(
                leading: CircularProgressIndicator(),
                title: Text('Cargando...'),
              ),
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