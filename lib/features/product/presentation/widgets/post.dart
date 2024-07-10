// import 'dart:typed_data';
//
// import 'package:blurhash_dart/blurhash_dart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image/image.dart' as img;
//
// import '../../../core/shared.dart';
// import '../../domain.dart' show ProductModel;
// import '../../shared.dart';
// import 'post_action.dart';
// import 'post_author.dart';
//
// /// Post Widget
// class Post extends ConsumerWidget {
//   /// constructor
//   const Post({required this.postModel, super.key});
//
//   /// Post Model [ProductModel]
//   final ProductModel postModel;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final textTheme = Theme.of(context).textTheme;
//     final appwriteClient = ref.read(CoreProviders.appwrite);
//     final feedRepository = ref.read(ProductProviders.feedRepository);
//
//     const defaultPadding = EdgeInsets.symmetric(horizontal: 4, vertical: 8);
//
//     final width = MediaQuery.of(context).size.width.toInt();
//     final height = width * 11 ~/ 16;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Padding(
//           padding: defaultPadding,
//           child: PostAuthor(
//             userId: postModel.userId,
//           ),
//         ),
//         if (null != postModel.imageId)
//           FutureBuilder(
//             future: feedRepository.getImage(
//               width: width,
//               height: height,
//               bucketId: appwriteClient.postsBucketId,
//               fileId: postModel.imageId!,
//             ),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState != ConnectionState.done) {
//                 if (null != postModel.imageBlurHash) {
//                   final image =
//                       BlurHash.decode(postModel.imageBlurHash!).toImage(35, 20);
//                   return AspectRatio(
//                     aspectRatio: 16 / 11,
//                     child: Image.memory(
//                       Uint8List.fromList(
//                         img.encodeJpg(image),
//                       ),
//                       fit: BoxFit.cover,
//                     ),
//                   );
//                 }
//               }
//               if (snapshot.hasData) {
//                 return AspectRatio(
//                   aspectRatio: 16 / 11,
//                   child: Image.memory(
//                     snapshot.requireData,
//                     fit: BoxFit.cover,
//                   ),
//                 );
//               }
//               return const SizedBox();
//             },
//           ),
//         PostAction(postModel: postModel),
//         Padding(
//           padding: defaultPadding,
//           child: Text(postModel.comment),
//         ),
//         if (null != postModel.tags)
//           Padding(
//             padding: defaultPadding,
//             child: Row(
//               children: [
//                 ...?postModel.tags?.map(
//                   (e) => Padding(
//                     padding: const EdgeInsets.only(right: 4),
//                     child: Text(
//                       e,
//                       style: textTheme.bodySmall,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }
