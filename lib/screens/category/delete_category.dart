import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/category_model.dart';
import 'package:tiendita/providers/category_provider.dart';

class DeleteCategory extends ConsumerStatefulWidget{
  final CategoryModel _currentCategory;
  DeleteCategory(this._currentCategory,{super.key});

  ConsumerState<DeleteCategory> createState() => _StateDeleteCategory();
}

class _StateDeleteCategory extends ConsumerState<DeleteCategory>{
  bool _isLoading = false;

  Future<void> _deleteCategory() async{
    setState(() => _isLoading = true);
      try{
        if(widget._currentCategory.idCategory != null){
          await ref.read(categoryNotifierProvider.notifier).deleteCategory(widget._currentCategory.idCategory!);

          if(mounted){
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Categoria eliminada exitosamente"),
                    backgroundColor: Colors.green));

            Navigator.pop(context);
          }
        }
      }catch(e){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Error al eliminar: $e"),
                  backgroundColor: Colors.green));
        }
      }finally{
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eliminar Categoria"),
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
              "Estás a punto de eliminar la categoría:\n'${widget._currentCategory.CategoryName}'\n\nEsta acción no se puede deshacer.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: _isLoading ? null : _deleteCategory,
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