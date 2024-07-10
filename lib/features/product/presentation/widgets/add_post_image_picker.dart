import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Add Post Image Picker
class AddPostImagePicker extends StatelessWidget {
  /// constructor
  AddPostImagePicker({required this.onImagePicked, super.key});

  /// fires after image picket
  final void Function(Uint8List?) onImagePicked;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Uint8List? image;
    return Row(
      children: [
        const Spacer(),
        ElevatedButton(
          onPressed: () async {
            //
            // Beitrag
            final selectedFile =
                await _picker.pickImage(source: ImageSource.camera);

            if (null != selectedFile) {
              image = await selectedFile.readAsBytes();
            } else {
              image = null;
            }
            onImagePicked(image);
          },
          child: const Row(
            children: [
              Icon(Icons.camera_alt_outlined),
              Text('Kamera'),
            ],
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () async {
            final selectedFile =
                await _picker.pickImage(source: ImageSource.gallery);

            if (null != selectedFile) {
              image = await selectedFile.readAsBytes();
            } else {
              image = null;
            }
            onImagePicked(image);
          },
          child: const Row(
            children: [
              Icon(Icons.image_outlined),
              Text('Gallerie'),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
