import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiendita/providers/database_provider.dart';

class ImportExportDatabase extends ConsumerStatefulWidget{
  static String id = "import_database";
  ImportExportDatabase({super.key});

  @override
  ConsumerState<ImportExportDatabase> createState() => _StateImportExportDatabase();
}

class _StateImportExportDatabase extends ConsumerState<ImportExportDatabase>{
  bool _isLoading = false;

  Future<File> _getDatabase() async{
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db_tiendita.sqlite'));
    return file;
  }


  Future<void> _exportDatabase() async{
    setState(() {
      _isLoading = true;
    });
    try{
      final db = await _getDatabase();
      if(await db.exists()){
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(db.path)],
            text: "Mi base de datos",
          ),
        );
      }else{
        showErrorSnackBar(context, "Base de datos no encontrada");
      }
    }catch(e){
      showErrorSnackBar(context, "Error al exportar la base de datos");
      print("Importar error: $e");
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _importDatabase() async{
    setState(() {
      _isLoading = true;
    });
    try{
      FilePickerResult? res = await FilePicker.pickFiles(
        type: FileType.any,
      );
      if(res != null && res.files.single.path != null){
        File source = File(res.files.single.path!);
        File target = await _getDatabase();

        final database = ref.read(databaseProvider);

        await database.close();

        if(await target.exists()){
          await target.delete();
        }

        await source.copy(target.path);

        ref.invalidate(databaseProvider);
        showSuccessSnackBar(context, "Base de datos importada con exito");
      }
    }catch(e){
      showErrorSnackBar(context, "Error al importar la base de datos");
      print("Exportar error: $e");
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: kActiveColor.withOpacity(0.1),
                child: Icon(icon, color: kActiveColor, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kActiveColor,
        elevation: 1,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Bootstrap.database_add, color: Colors.white, size: 20),
            const SizedBox(width: 5),
            Text(
              'Sincronización',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Card(
                  elevation: 10,
                  shadowColor: Colors.black38,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)
                  ),
                  color: Color(0xff475569),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gestión de \nArchivos",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    height: 1.2
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.cloud_sync_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Sincroniza tus bases de datos de forma segura y profesional.",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                height: 1.4
                            ),
                          )
                        ],
                      ),
                    ),
                ),
                const SizedBox(height: 10),
                _buildActionCard(
                  title: "Exportar Base de datos",
                  subtitle: "Genera una copia de seguridad local\n completa.",
                  icon: Icons.upload_file_outlined,
                  onTap: _exportDatabase,
                ),
               _buildActionCard(
                   title: "Importar Base de Datos",
                   subtitle: "Restaura o migra datos desde un archivo de respaldo externo.",
                   icon: Icons.download_for_offline_outlined,
                   onTap: _importDatabase,
               ),
                const SizedBox(height: 30),
              ],
            ),
          ),

          if(_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}



/*
*  Center(
                  child: _isLoading ? CircularProgressIndicator() :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white60,
                                child: Icon(Icons.download_outlined, color: Colors.black),
                              ),
                              title: const Text("Exportar Base de datos"),
                              subtitle: Text("Genera una copia de seguridad local\n completa."),
                            ),
                            ElevatedButton.icon(
                              onPressed: _exportDatabase,
                              icon: const Icon(Icons.download),
                              label: const Text('Exportar Base de datos'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: Colors.white60,
                                    child: Icon(Icons.upload_outlined, color: Colors.black)
                                ),
                                title: const Text("Importar Base de datos"),
                                subtitle: Text("Restaura o migra datos externos del\n sistema."),
                              ),
                              ElevatedButton.icon(
                                onPressed: _importDatabase,
                                icon: const Icon(Icons.upload),
                                label: const Text('Importar Base de datos'),
                              ),
                            ],
                          )
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'Nota: Importar la base datos podria sobreescribir todos los datos actuales',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ),
* */