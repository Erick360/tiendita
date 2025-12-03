
import 'dart:io';
import 'package:tiendita/providers/image_provider.dart' as img_provider;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImagePicker extends ConsumerStatefulWidget{
  final String? initialImage;
  final Function(String?) onImageSelected;
  final String label;

  const ImagePicker({
    super.key,
    this.initialImage,
    required this.onImageSelected,
    this.label = "Imagen"
  });

  @override
  ConsumerState<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends ConsumerState<ImagePicker>{
  String? _imagePath;

  @override
  void initState(){
    super.initState();
    _imagePath = widget.initialImage;
  }



Future<void> _showImageSourceDialog() async{
  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Selecciona la imagen"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: const Text("Galeria"),
              onTap: (){
                Navigator.pop(context);
                _pickImage(fromCamera: false);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: const Text("Camara"),
              onTap: (){
                Navigator.pop(context);
                _pickImage(fromCamera: false);
              },
            ),
           const SizedBox(height: 10),
           ListTile(
              leading: Icon(Icons.photo_library),
              title: const Text("Galeria"),
              onTap: (){
                Navigator.pop(context);
                _pickImage(fromCamera: false);
              },
            ),
            if(_imagePath != null )
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Eliminar Imagen"),
                onTap: (){
                  Navigator.pop(context);
                  _removeImage();
                },
              ),
          ],
        ),
      ),
  );
}
  Future<void> _pickImage({required bool fromCamera}) async {
    final imageService = ref.read(img_provider.imageServiceProvider);

    final imagePath = fromCamera
        ? await imageService.pickImageFromCamera()
        : await imageService.pickImageFromGallery();

    if (imagePath != null) {
      setState(() => _imagePath = imagePath);
      widget.onImageSelected(imagePath);
    }
  }

  void _removeImage() {
    setState(() => _imagePath = null);
    widget.onImageSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showImageSourceDialog,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: _imagePath != null && _imagePath!.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              ),
            )
                : _buildPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate,
          size: 64,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 8),
        Text(
          'Toca para agregar imagen',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

}