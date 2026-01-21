import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/category_provider.dart';

import '../../models/category_model.dart';

class EditCategory extends ConsumerStatefulWidget {
  final CategoryModel _categoryToEdit;
  const EditCategory(this._categoryToEdit,{super.key});
  static String id = "edit_category";

  ConsumerState<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends ConsumerState<EditCategory> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _editCategory;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _editCategory = TextEditingController(text: widget._categoryToEdit.CategoryName);
  }

  @override
  void dispose() {
    _editCategory.dispose();
    super.dispose();
  }


  Future<void> _updateCategory() async{
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final category = CategoryModel(
        idCategory: widget._categoryToEdit.idCategory,
        CategoryName: _editCategory.text.trim(),
      );

      ref.read(categoryNotifierProvider.notifier).saveCategory(category);
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cambios guardados'),
            backgroundColor: Colors.green,
          ),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar cambios: $e'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
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
              'Editar categoria',
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _editCategory,
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
                if (value.length < 3) {
                  return "El nombre es muy corto";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _updateCategory,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? 'Guardando...' : 'Guardar cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
