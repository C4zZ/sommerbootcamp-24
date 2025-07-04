import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app_theme.dart';
import 'image_page_view.dart';

class ImageSelector extends StatefulWidget {
  /// constructor
  ImageSelector({
    required this.images,
    required this.onImagePickedFromCamera,
    required this.onImagesPickedFromGallery,
    required this.onImageDeleted,
    super.key,
  });

  /// List of choosen images
  final List<Uint8List> images;
  /// fires after image ist picked
  final void Function(Uint8List image) onImagePickedFromCamera;
  /// fires after multiple images are picked
  final void Function(List<Uint8List> images) onImagesPickedFromGallery;
  /// fires after image is deleted
  final void Function(int page) onImageDeleted;


  final ImagePicker _picker = ImagePicker();

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.images.isEmpty
                  ? Colors.grey[500]!
                  : Colors.transparent,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: widget.images.isEmpty
                    ? const Text(
                        'Noch keine Bilder vorhanden',
                        style: TextStyle(color: Colors.black26),
                      )
                    : ImagePageView(
                        images: widget.images,
                        pageController: _pageController,
                      ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      if (widget.images.isEmpty)
                        const SizedBox()
                      else
                        TextButton(
                          onPressed: _deleteImage,
                          style: _buttonStyle(),
                          child: Icon(
                            Icons.delete,
                            color: AppColors.blueMaterial,
                          ),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: _pickImageFromGallery,
                        style: _buttonStyle(),
                        child: Icon(
                          Icons.photo,
                          color: AppColors.blueMaterial,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        onPressed: _pickImageFromCamera,
                        style: _buttonStyle(),
                        child: Icon(
                          Icons.photo_camera,
                          color: AppColors.blueMaterial,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    // TODO(team): Mache ein Bild mit der Kamera.
    // Option A
    // final image = await widget._picker.pickImage(
    //   source: ImageSource.camera,
    // );
    // final imageBytes = await image?.readAsBytes();
    // widget.onImagePickedFromCamera(imageBytes!);

    // Option B
    // final image = await widget._picker.pickImage(
    //   source: ImageSource.make,
    // );
    // final imageBytes = await image?.readAsBytes();
    // widget.onImagePickedFromCamera(imageBytes!);

    // Option C
    // final image = await widget._picker.pickImage(
    //   source: Camera.go()
    // );
    // final imageBytes = await image?.readAsBytes();
    // widget.onImagePickedFromCamera(imageBytes!);

    // Option D
    // final image = await widget._picker.pickImage(
    //   source: ImageSource.camera.knips(),
    // );
    // final imageBytes = await image?.readAsBytes();
    // widget.onImagePickedFromCamera(imageBytes!);
  }

  Future<void> _pickImageFromGallery() async {
    // TODO(team): Verändere die nächste Zeile so, dass sich die Bildergalerie
    //  öffnet und du mehrere Bilder für dein Produkt auswählen kannst
    final pickedImages = <XFile>[];
    final futureMap = pickedImages
        .map(
          (image) async => image.readAsBytes(),
    )
        .toList();
    final imagesBytes = await Future.wait(futureMap);
    widget.onImagesPickedFromGallery(imagesBytes);
  }

  void _deleteImage() {
    int currentPage;
    try {
      currentPage = _pageController.page!.toInt();
    } catch (_) {
      return;
    }
    widget.onImageDeleted(currentPage);
  }

  ButtonStyle _buttonStyle() => ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Theme.of(context).scaffoldBackgroundColor,
        ),
      );
}
