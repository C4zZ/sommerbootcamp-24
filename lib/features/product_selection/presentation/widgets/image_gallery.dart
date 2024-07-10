import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/shared.dart';
import '../../../product/shared/product.providers.dart';

class ImageGallery extends ConsumerStatefulWidget {
  /// constructor
  ImageGallery({
    required this.imageIds,
    super.key,
  });

  /// List of choosen images
  final List<String?> imageIds;

  @override
  ConsumerState<ImageGallery> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends ConsumerState<ImageGallery> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appwriteClient = ref.read(CoreProviders.appwrite);
    final productRepository = ref.read(ProductProviders.productRepository);

    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: PageView(
                  controller: _pageController,
                  children: widget.imageIds
                      .map<Widget>(
                        (imageId) => FutureBuilder(
                          future: productRepository.getImage(
                            bucketId: appwriteClient.imagesBucketId,
                            fileId: imageId!,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child:
                                      CircularProgressIndicator.adaptive(),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              return AspectRatio(
                                aspectRatio: 16 / 11,
                                child: Image.memory(
                                  snapshot.requireData,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
