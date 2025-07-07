import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// If you want to centralize all image logic, you can import your ImageService here instead
// import 'package:dogs_life/services/image_service.dart';

// To support reordering with drag handles:
import 'package:reorderables/reorderables.dart';

class MultiPhotoPickerField extends StatefulWidget {
  final List<String> initialUrls;           // Existing images (remote URLs)
  final ValueChanged<List<String>> onChanged;
  final String id;                         // Used as folder/doc id
  final String folder;                     // e.g. 'dogs', 'adoptions'
  final bool canEdit;                      // Controls add/remove/reorder UI
  final int maxImages;
  final String placeholderAsset;

  const MultiPhotoPickerField({
    super.key,
    this.initialUrls = const [],
    required this.onChanged,
    required this.id,
    required this.folder,
    this.canEdit = true,
    this.maxImages = 8,
    this.placeholderAsset = 'assets/images/placeholder_dog.png',
  });

  @override
  State<MultiPhotoPickerField> createState() => _MultiPhotoPickerFieldState();
}

class _MultiPhotoPickerFieldState extends State<MultiPhotoPickerField> {
  late List<String> _urls;
  late List<double> _progress; // Upload progress for each image (0.0-1.0)
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _urls = List<String>.from(widget.initialUrls);
    _progress = List<double>.filled(_urls.length, 1.0);
  }

  Future<void> _pickAndUploadImage({required bool fromCamera}) async {
    if (_urls.length >= widget.maxImages) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() {
      _uploading = true;
      _progress.add(0.0); // Add a progress slot
    });

    try {
      // Upload to Firebase Storage (or your ImageService abstraction)
      final url = await _uploadToFirebase(picked);
      setState(() {
        _urls.add(url);
        _progress[_progress.length - 1] = 1.0;
        _uploading = false;
      });
      widget.onChanged(_urls);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed: $e')),
      );
      setState(() {
        _progress.removeLast();
        _uploading = false;
      });
    }
  }

  Future<String> _uploadToFirebase(XFile picked) async {
    // Use Firebase Storage directly for now (or swap to ImageService later)
    final storage = FirebaseStorage.instance;
    final ref = storage
        .ref()
        .child('${widget.folder}/${widget.id}/${DateTime.now().millisecondsSinceEpoch}_${picked.name}');
    final uploadTask = ref.putFile(File(picked.path));

    uploadTask.snapshotEvents.listen((event) {
      setState(() {
        _progress[_progress.length - 1] =
            event.bytesTransferred / (event.totalBytes > 0 ? event.totalBytes : 1);
      });
    });

    await uploadTask;
    return await ref.getDownloadURL();
  }

  Future<void> _removeImage(int index) async {
    final url = _urls[index];
    setState(() {
      _urls.removeAt(index);
      _progress.removeAt(index);
    });
    widget.onChanged(_urls);

    // Optionally delete from storage
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
    } catch (_) {
      // Ignore errors for now
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    setState(() {
      final url = _urls.removeAt(oldIndex);
      final prog = _progress.removeAt(oldIndex);
      _urls.insert(newIndex, url);
      _progress.insert(newIndex, prog);
    });
    widget.onChanged(_urls);
  }

  @override
  Widget build(BuildContext context) {
    final isFull = _urls.length >= widget.maxImages;
    final canEdit = widget.canEdit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        const Text('Photos', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // Gallery with reordering
        ReorderableWrap(
          spacing: 8,
          runSpacing: 8,
          needsLongPressDraggable: true,
          onReorder: canEdit ? _onReorder : (a, b) {},
          children: [
            for (int i = 0; i < _urls.length; i++)
              Stack(
                key: ValueKey(_urls[i]),
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _progress[i] < 1.0
                        ? SizedBox(
                      width: 80,
                      height: 80,
                      child: Center(
                        child: CircularProgressIndicator(value: _progress[i]),
                      ),
                    )
                        : Image.network(
                      _urls[i],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  if (canEdit && _progress[i] == 1.0)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => _removeImage(i),
                    ),
                ],
              ),

            // "Add from gallery" button
            if (canEdit && !isFull)
              GestureDetector(
                onTap: _uploading ? null : () => _pickAndUploadImage(fromCamera: false),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Icon(Icons.add_a_photo, color: Colors.grey),
                ),
              ),
            // "Add from camera" button
            if (canEdit && !isFull)
              GestureDetector(
                onTap: _uploading ? null : () => _pickAndUploadImage(fromCamera: true),
                child: Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.grey),
                ),
              ),
          ],
        ),
        if (_urls.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Image.asset(widget.placeholderAsset, height: 80, width: 80, fit: BoxFit.cover),
          ),
      ],
    );
  }
}
