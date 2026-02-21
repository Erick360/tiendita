import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/purveyors_model.dart';
import 'package:tiendita/providers/purveyor_provider.dart';

class DeletePurveyor extends ConsumerStatefulWidget{
  final PurveyorsModel _currentPurveyor;
  DeletePurveyor(this._currentPurveyor,{super.key});

  @override
  ConsumerState<DeletePurveyor> createState()=> _StateDeletePurveyor();
}

class _StateDeletePurveyor extends ConsumerState<DeletePurveyor>{
  bool _isLoading = false;

  Future<void> _deletePurveyor() async{
    setState(() {
      _isLoading = true;
    });
    try{
      if(widget._currentPurveyor.idPurveyor!=null){
         await ref.read(purveyorNotifierProvider.notifier).deletePurveyor(widget._currentPurveyor.idPurveyor!);

         if(mounted){
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Dato eliminado correctamente"),backgroundColor: Colors.green),
           );
           Navigator.pop(context);
         }
      }
    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar datos: $e"),
          backgroundColor: Colors.red),
        );
      }
    }finally{
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eliminar Proveedores"),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 80,color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              "Estas Seguro?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Estás a punto de eliminar :\n'${widget._currentPurveyor.PurveyorName}'\n\nEsta acción no se puede deshacer.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _deletePurveyor,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15)
              ),
              child: _isLoading ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              )
                  : const Text("ELIMINAR DEFINITIVAMENTE", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(fontSize: 16)),
            ),

          ],
        ),
      ),
    );
  }
}