import 'dart:ui';

class FooterModel {
  final String label;
  final String imagePath;
  final VoidCallback onPressed;

  const FooterModel(
      this.label,
      this.imagePath,
      this.onPressed,
      );

}