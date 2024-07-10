import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/domain/models/application_routes.dart';
import '../../core/shared/core.providers.dart';
import '../../user_profile/shared.dart';
import '../data.dart';
import '../domain.dart';
import '../domain/models/chat_model.dart';
import '../presentation/chat_widget.controller.dart';
import '../presentation/chat_widget.controller.state.dart';
import '../shared.dart';

/// Chat Feature Provider
class ChatProviders {
  // Data
  ///Chat Remote Datasource
  static final Provider<ChatDatasource> chatRemoteDatasource =
      Provider((ref) => ChatRemoteDatasource());

  // Domain
  /// Chat Repository
  static final Provider<ChatRepository> chatRepository = Provider(
    (ref) => ChatRepositoryImpl(
      appwriteClient: ref.read(
        CoreProviders.appwrite,
      ),
      userProfileRepository:
          ref.read(UserProfileProviders.userProfileRepository),
    ),
  );

  /// kein kommentar
  static final StreamProvider<RealtimeMessage> messageStream =
      StreamProvider((ref) {
    final appwrite = ref.read(CoreProviders.appwrite);
    final databaseId = appwrite.databaseId;
    final messageCollectionId = appwrite.chatMessagesCollectionId;
    final messageSubscription = appwrite.realtime.subscribe(
      [
        'databases.$databaseId.collections.$messageCollectionId.documents',
      ],
    );

    ref.onDispose(messageSubscription.close);

    return messageSubscription.stream;
  });

  static final FutureProviderFamily<List<ChatModel>, String> getInitialChats =
      FutureProviderFamily((ref, receiverUserId) {
    return ref.watch(chatRepository).getChatMessages(receiverUserId);
  });

  // Presentation

  /// Chat Widget Controller
  static final AutoDisposeStateNotifierProviderFamily<ChatWidgetController,
          ChatWidgetControllerState, String> chatController =
      StateNotifierProvider.family.autoDispose((ref, receiverUserId) {
    final initialChats = ref.watch(getInitialChats(receiverUserId));
    final appwriteClient = ref.read(CoreProviders.appwrite);
    final messageCreatedEvent =
        'databases.${appwriteClient.databaseId}.collections.${appwriteClient.chatMessagesCollectionId}.documents.*.create';

    return ChatWidgetController(
      state: ChatWidgetControllerState(
        messages: initialChats,
        messageCreatedEvent: messageCreatedEvent,
      ),
      chatRepo: ref.read(chatRepository),
      appwriteClient: ref.read(CoreProviders.appwrite),
    );
  });

  // shared
  /// Chat Feature Routes
  static final Provider<ApplicationRoutes> routes = Provider<ChatRoutes>(
    (ref) => ChatRoutes(),
  );
}
