import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/services/image_service.dart';

final imageServiceProvider = Provider<ImageService>((ref){
    return ImageService();
});