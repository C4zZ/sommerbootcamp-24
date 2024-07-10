import 'models/chat_contact_model.dart';
import 'models/chat_model.dart';

/// ChatRepository
abstract class ChatRepository {
  /// send a chat message
  Future<ChatModel> sendMessage({
    required String receiverId,
    required String message,
  });

  /// Get Chat Contacts
  Future<List<ChatContactModel>> getChatContacts();

  /// Get Chat Messages
  Future<List<ChatModel>> getChatMessages(String receiverUserId);
}
