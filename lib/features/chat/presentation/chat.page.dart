import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/shared.dart';
import '../../user_profile/domain.dart' show UserProfileModel;
import '../../user_profile/shared.dart';
import '../domain/models/chat_contact_model.dart';
import '../shared.dart';

/// Chat Page
class ChatPage extends ConsumerWidget {
  /// constructor
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRepo = ref.read(ChatProviders.chatRepository);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            onPressed: () async {
              final selectedUser =
                  await showModalBottomSheet<UserProfileModel?>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                builder: (_) {
                  return const FractionallySizedBox(
                    heightFactor: 1,
                    child: _ContactList(),
                  );
                },
              );

              debugPrint(selectedUser.toString());

              if (null != selectedUser && context.mounted) {
                await context.push(
                  '/chat/message?new=true&receiverUserId=${selectedUser.userId}',
                );
              }
            },
            icon: const Icon(Icons.three_p),
          ),
        ],
      ),
      body: FutureBuilder<List<ChatContactModel>>(
        future: chatRepo.getChatContacts(),
        builder: (_, AsyncSnapshot<List<ChatContactModel>> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...snapshot.requireData.map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: ChatContactWidget(chatContactModel: e),
                    ),
                  ),
                ],
              ),
            );
          }

          if (ConnectionState.waiting == snapshot.connectionState) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Ein Fehler ist aufgetreten... ${snapshot.error}'),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

/// Chat Contact Widget
class ChatContactWidget extends StatelessWidget {
  /// constructor
  const ChatContactWidget({
    required ChatContactModel chatContactModel,
    super.key,
  }) : _chatContactModel = chatContactModel;

  final ChatContactModel _chatContactModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/chat/message?new=false&receiverUserId=${_chatContactModel.userId}',
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(width: .5),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              if (null != _chatContactModel.profileImage)
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.memory(
                      _chatContactModel.profileImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              const SizedBox(
                width: 8,
              ),
              Text(_chatContactModel.displayName),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactList extends ConsumerStatefulWidget {
  const _ContactList();

  @override
  ConsumerState<_ContactList> createState() => _ContactListState();
}

class _ContactListState extends ConsumerState<_ContactList> {
  String currentUserId = '';
  @override
  void initState() {
    super.initState();

    try {
      ref.read(CoreProviders.appwrite).account.get().then((currentUser) {
        currentUserId = currentUser.$id;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileRepository = ref.read(
      UserProfileProviders.userProfileRepository,
    );

    final appwrite = ref.read(CoreProviders.appwrite);

    debugPrint('Current Session UserId: ${appwrite.currentSession?.userId}');

    return FutureBuilder<List<UserProfileModel>>(
      future: userProfileRepository.getProfileList(),
      builder: (BuildContext fbContext,
          AsyncSnapshot<List<UserProfileModel>> snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ...snapshot.requireData
                    .where((element) => element.userId != currentUserId)
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(e);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: FutureBuilder<Uint8List>(
                                  future: userProfileRepository
                                      .getProfileImageFromUserId(e.userId),
                                  builder:
                                      (_, AsyncSnapshot<Uint8List> snapshot) {
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
                              const SizedBox(
                                width: 8,
                              ),
                              Text(e.displayName),
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return const SizedBox();
      },
    );
  }
}
