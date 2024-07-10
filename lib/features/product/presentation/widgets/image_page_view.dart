import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class ImagePageView extends StatefulWidget {
  /// Images to show
  final List<Uint8List> images;

  /// PageView Controller
  final PageController pageController;

  const ImagePageView({
    required this.images,
    required this.pageController,
    super.key,
  });

  @override
  State<ImagePageView> createState() => _ImagePageViewState();
}

class _ImagePageViewState extends State<ImagePageView> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.pageController,
      children: widget.images.map<Widget>(Image.memory).toList(),
    );
  }
}
