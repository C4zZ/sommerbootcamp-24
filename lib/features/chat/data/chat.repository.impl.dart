import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../core/shared.dart';
import '../../user_profile/domain.dart';
import '../domain/chat.repository.dart';
import '../domain/models/chat_contact_model.dart';
import '../domain/models/chat_model.dart';

/// Implementation for [ChatRepository]
class ChatRepositoryImpl implements ChatRepository {
  /// constructor
  ChatRepositoryImpl({
    required AppwriteClient appwriteClient,
    required UserProfileRepository userProfileRepository,
  })  : _userProfileRepository = userProfileRepository,
        _appwriteClient = appwriteClient;

  final AppwriteClient _appwriteClient;
  final Uuid _uuid = const Uuid();
  final UserProfileRepository _userProfileRepository;

  @override
  Future<ChatModel> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    final currentUser = await _appwriteClient.account.get();

    final newMessage = await _appwriteClient.databases.createDocument(
      databaseId: _appwriteClient.databaseId,
      collectionId: _appwriteClient.chatMessagesCollectionId,
      documentId: _uuid.v1(),
      data: {
        'sender_id': currentUser.$id,
        'receiver_id': receiverId,
        'message': message,
      },
    );

    return newMessage
        .convertTo((p0) => ChatModel.fromJson(p0 as Map<String, dynamic>));
  }

  @override
  Future<List<ChatContactModel>> getChatContacts() async {
    Set<String> contactUserIds = {};

    final currentUser = await _appwriteClient.account.get();

    final chatContacts = await Future.wait(
      [
        _appwriteClient.databases.listDocuments(
          databaseId: _appwriteClient.databaseId,
          collectionId: _appwriteClient.chatMessagesCollectionId,
          queries: [
            Query.equal('sender_id', currentUser.$id),
          ],
        ),
        _appwriteClient.databases.listDocuments(
          databaseId: _appwriteClient.databaseId,
          collectionId: _appwriteClient.chatMessagesCollectionId,
          queries: [
            Query.equal('receiver_id', currentUser.$id),
          ],
        ),
      ],
    );

    final flatChatContacts =
        chatContacts.expand((DocumentList element) => element.documents);

    for (final element in flatChatContacts) {
      if (!contactUserIds.contains(element.data['sender_id']) &&
          element.data['sender_id'] != currentUser.$id) {
        contactUserIds.add(element.data['sender_id'].toString());
      }

      if (!contactUserIds.contains(element.data['receiver_id']) &&
          element.data['receiver_id'] != currentUser.$id) {
        contactUserIds.add(element.data['receiver_id'].toString());
      }
    }

    final chatContactsModels = List<ChatContactModel>.empty(growable: true);

    for (final contactUserId in contactUserIds) {
      final userProfile =
          await _userProfileRepository.getUserProfile(contactUserId);
      final profileImage = await _userProfileRepository
          .getProfileImageFromUserId(userProfile!.userId);

      chatContactsModels.add(
        ChatContactModel(
          userId: contactUserId,
          displayName: userProfile?.displayName ?? contactUserId,
          profileImage: profileImage,
        ),
      );
    }

    debugPrint(contactUserIds.join(', '));
    return chatContactsModels;
  }

  @override
  Future<List<ChatModel>> getChatMessages(String receiverUserId) async {
    final currentUser = await _appwriteClient.account.get();
    final chatMessages = await Future.wait(
      [
        _appwriteClient.databases.listDocuments(
          databaseId: _appwriteClient.databaseId,
          collectionId: _appwriteClient.chatMessagesCollectionId,
          queries: [
            Query.equal('sender_id', currentUser.$id),
            Query.equal('receiver_id', receiverUserId),
          ],
        ),
        _appwriteClient.databases.listDocuments(
          databaseId: _appwriteClient.databaseId,
          collectionId: _appwriteClient.chatMessagesCollectionId,
          queries: [
            Query.equal('sender_id', receiverUserId),
            Query.equal('receiver_id', currentUser.$id),
          ],
        ),
      ],
    );

    final flatChatMessages =
        chatMessages.expand((DocumentList element) => element.documents);

    final chatModels = List<ChatModel>.empty(growable: true);
    for (final element in flatChatMessages) {
      var chatModel = ChatModel.fromJson(element.data);
      chatModel =
          chatModel.copyWith(isSender: chatModel.senderId == currentUser.$id);
      chatModels.add(chatModel);
    }

    chatModels.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return chatModels;
  }
}
