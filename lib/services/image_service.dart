import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'firebase/firebase_mobile.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery or camera
  Future<XFile?> pickImage({bool fromCamera = false}) async {
    try {
      return await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );
    } catch (e) {
      debugPrint('Image pick error: $e');
      return null;
    }
  }

  /// Upload image to Firebase Storage, returns download URL or null
  Future<String?> uploadImage(XFile image, String path) async {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
      return await uploadImageToFirebase(image, path);
    } else {
      debugPrint('Image upload not supported on this platform.');
      return null;
    }
  }
}
