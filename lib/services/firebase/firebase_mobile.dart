import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

/// Upload image to Firebase Storage (Android & Web only)
Future<String?> uploadImageToFirebase(XFile image, String path) async {
  try {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putData(await image.readAsBytes());
    return await ref.getDownloadURL();
  } catch (e) {
    debugPrint('Firebase upload error: $e');
    return null;
  }
}
