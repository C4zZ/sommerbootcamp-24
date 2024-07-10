import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../user_profile/domain.dart';
import '../../../user_profile/shared.dart';
import '../../domain/models/chat_model.dart';
import '../../shared/chat.providers.dart';
import 'message_bubble.dart';

/// Chat Widget
class ChatWidget extends ConsumerWidget {
  /// constructor
  ChatWidget({
    required this.receiverUserId,
    super.key,
    this.isNewChat = false,
  });

  /// initialize empty chat widget
  final bool isNewChat;

  /// receiver user id
  final String receiverUserId;

  final TextEditingController _newMessageController = TextEditingController();
  List<Widget> _messageWidgets = [];
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatController =
        ref.read(ChatProviders.chatController(receiverUserId).notifier);
    final chatState = ref.watch(ChatProviders.chatController(receiverUserId));

    chatState.messages.when(
      data: (messages) {
        _messageWidgets = messages
            .map(
              (e) => MessageBubble(
                message: e.message,
                isSender: e.isSender,
              ),
            )
            .toList();
      },
      error: (_, __) {
        _messageWidgets = [
          const Center(
            child: Text(
                'Es ist ein Fehler aufgetreten, komm doch nächste Woche wieder vorbei!'),
          ),
        ];
      },
      loading: () {
        _messageWidgets = [
          const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ];
      },
    );

    /// Realtime
    ref.watch(ChatProviders.messageStream).whenData((value) {
      if (value.events.contains(chatState.messageCreatedEvent)) {
        final chatModel = ChatModel.fromJson(value.payload);
        chatController.addMessage(chatModel);
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn,
        );
      }
    });

    final screeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: _ChatAppBarTitle(
          receiverUserId: receiverUserId,
        ),
      ),
      body: Stack(
        // alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: _messageWidgets,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: screeWidth,
              child: TextField(
                controller: _newMessageController,
                decoration: InputDecoration(
                  hintText: 'Message',
                  suffix: GestureDetector(
                    onTap: () {
                      chatController.sendMessage(
                        receiverId: receiverUserId,
                        message: _newMessageController.text,
                      );
                      _newMessageController.text = '';
                    },
                    child: const Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chat Messages AppBar Title
class _ChatAppBarTitle extends ConsumerWidget {
  /// constructor
  const _ChatAppBarTitle({required String receiverUserId, super.key})
      : _receiverUserId = receiverUserId;

  final String _receiverUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileRepository =
        ref.read(UserProfileProviders.userProfileRepository);
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: FutureBuilder<Uint8List>(
            future: userProfileRepository
                .getProfileImageFromUserId(_receiverUserId),
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
        const SizedBox(
          width: 8,
        ),
        FutureBuilder<UserProfileModel?>(
          future: userProfileRepository.getUserProfile(_receiverUserId),
          builder: (_, data) {
            if (data.hasData && null != data.requireData) {
              return Text(data.data!.displayName);
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}
