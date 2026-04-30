import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _saveImagePermanently(image.path);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }


  Future<String?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _saveImagePermanently(image.path);
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }


  Future<String> _saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}${p.extension(imagePath)}';
    final newPath = p.join(directory.path, 'images', fileName);


    final imagesDir = Directory(p.join(directory.path, 'images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final imageFile = File(imagePath);
    await imageFile.copy(newPath);

    return newPath;
  }

  Future<bool> deleteImage(String imagePath) async {
    try {
      if (imagePath.isEmpty) return false;

      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }


  Future<bool> imageExists(String imagePath) async {
    if (imagePath.isEmpty) return false;
    final file = File(imagePath);
    return await file.exists();
  }
}