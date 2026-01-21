import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/category_model.dart';
import 'package:tiendita/providers/category_provider.dart';

class CreateCategory extends ConsumerStatefulWidget {
  const CreateCategory({super.key});
  static String id = "create_category";

  ConsumerState<CreateCategory> createState() => _StateCreateCategory();
}

class _StateCreateCategory extends ConsumerState<CreateCategory> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _createCategory = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _createCategory.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if(!_formKey.currentState!.validate())return;

    setState(() {
      _isLoading = true;
    });
    try {
      final category = CategoryModel(CategoryName: _createCategory.text);
      await ref.read(categoryNotifierProvider.notifier).saveCategory(category);

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
               content: Text("Categpria guardada exitosamente"),
             backgroundColor: Colors.green,
           )
        );
        Navigator.pop(context);
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al guardar los datos: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF25410),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Crear Categoría',
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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              TextFormField(
                controller: _createCategory,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: "Nombre de la categoria",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Este campo necesita llenarse';
                  }
                  if(value.length <3){
                    return "El nombre es muy corto";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveCategory,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF25410)),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white,strokeWidth: 2)
                      : const Text('Continuar', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
