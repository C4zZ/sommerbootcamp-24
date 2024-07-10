import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app_theme.dart';
import '../../../user_profile/domain.dart';
import '../../../user_profile/shared.dart';

/// Author of the Post Item
class PostAuthor extends ConsumerWidget {
  /// constructor
  const PostAuthor({required this.userId, super.key});

  /// Post UserId
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileRepo =
        ref.read(UserProfileProviders.userProfileRepository);
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.blue,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: FutureBuilder<Uint8List>(
              future: userProfileRepo.getProfileImageFromUserId(userId),
              builder: (_, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.hasData) {
                  return ClipOval(
                    child: Image.memory(
                      snapshot.requireData,
                      fit: BoxFit.contain,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        FutureBuilder<UserProfileModel?>(
          future: userProfileRepo.getUserProfile(userId),
          builder: (context, snapshot) {
            if (snapshot.hasData && null != snapshot.data) {
              return Text(snapshot.data!.displayName);
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
