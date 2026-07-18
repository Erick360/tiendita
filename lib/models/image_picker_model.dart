class ImagePickerModel {
  final String? initialImage;
  final Function(String?) onImageSelected;
  final String label;

  const ImagePickerModel({
    this.initialImage,
    required this.onImageSelected,
    this.label = "Imagen"
  });

}