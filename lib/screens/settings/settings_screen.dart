import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/alert_settings_provider.dart';
import 'package:tiendita/providers/theme_provider.dart';
import 'package:tiendita/screens/settings/change_pin.dart';
import 'package:tiendita/screens/settings/import_export_database.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static String id = 'settings_screen';

void _showThemeDialog(BuildContext context, WidgetRef ref, ThemeMode currentTheme){
  showDialog(
      context: context,
      builder: (BuildContext ctx){
        return AlertDialog(
          title: const Text("Seleccionar Tema"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                  title: const Text("Modo Claro"),
                  value: ThemeMode.light,
                  groupValue: currentTheme,
                activeColor: const Color(0xFFF25410),
                onChanged: (value){
                    if(value != null)ref.read(themeNotifierProvider.notifier).changeTheme(value);
                    Navigator.pop(ctx);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text("Modo Oscuro"),
                value: ThemeMode.dark,
                groupValue: currentTheme,
                activeColor: const Color(0xFFF25410),
                onChanged: (value){
                  if(value != null)ref.read(themeNotifierProvider.notifier).changeTheme(value);
                  Navigator.pop(ctx);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text("Sistema"),
                value: ThemeMode.system,
                groupValue: currentTheme,
                activeColor: const Color(0xFFF25410),
                onChanged: (value){
                  if(value != null)ref.read(themeNotifierProvider.notifier).changeTheme(value);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      }
  );
}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final currentTheme = ref.watch(themeNotifierProvider);
  
  String themeText = 'Modo Claro';
  if(currentTheme == ThemeMode.dark) themeText = 'Modo Oscuro';
  if(currentTheme == ThemeMode.system) themeText = 'Sistema';

  Future<int?> showNumberDialog(BuildContext context, String title, int currentValue) {
    final TextEditingController controller = TextEditingController(text: currentValue.toString());
    return showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                Navigator.pop(ctx, value);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF25410)),
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }


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
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 5),
            const Text(
                'Configuracion',
                style: TextStyle(
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
          const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Text("Notificaciones e Inventario", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,),),
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Limite de Stock Bajo'),
            subtitle: Text('Avisar cuando queden ${ref.watch(alertSettingsProvider).stockLimit} o menos'),
            trailing: const Icon(Icons.edit, size: 20),
            onTap: () async{
              final currentLimit = ref.read(alertSettingsProvider).stockLimit;
              int? newLimit = await showNumberDialog(context, 'Limite de Stock', currentLimit);
              if(newLimit != null){
                ref.read(alertSettingsProvider.notifier).updateStockLimit(newLimit);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Aviso de Caducidad'),
            subtitle: Text('Avisar ${ref.watch(alertSettingsProvider).expiryDays} dias antes'),
            trailing: const Icon(Icons.edit, size: 20),
            onTap: () async{
              final currentDays = ref.read(alertSettingsProvider).expiryDays;
              int? newDays = await showNumberDialog(context, 'Dias de advertencia', currentDays);
              if(newDays != null){
                ref.read(alertSettingsProvider.notifier).updateExpiryDays(newDays);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security),
            title: Text('Seguridad'),
            subtitle: Text('PIN y Huella digital'),
            trailing: Icon(Icons.chevron_right),
            onTap: () =>
                Navigator.pushReplacementNamed(context, ChangePinScreen.id)
                //AppSettings.openAppSettings(type: AppSettingsType.lockAndPassword),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.brush_outlined),
            title: Text('Temas'),
            subtitle: Text(themeText),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, ref, currentTheme),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.import_export),
            title: Text("Gestion"),
            subtitle: Text("Importar u Exportar base de datos"),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, ImportExportDatabase.id),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
