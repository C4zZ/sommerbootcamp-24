import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

/// Appwrite client and associated services
class AppwriteClient {
  static Client? _client;
  static Storage? _storage;
  static Databases? _databases;
  static Account? _account;
  static Realtime? _realtime;
  static Avatars? _avatars;
  static const String _apiEndpoint = String.fromEnvironment('API_ENDPOINT');
  static const String _projectId = String.fromEnvironment('PROJECT_ID');

  /// Current User [models.Session]
  models.Session? currentSession;

  /// Get Database Id
  String get databaseId => const String.fromEnvironment('DEFAULT_DATABASE_ID');

  /// Get Post Collection Id
  String get productCollectionId =>
      const String.fromEnvironment('PRODUCT_COLLECTION_ID');

  /// Get User Profile Collection Id
  String get userProfileCollectionId => const String.fromEnvironment(
        'USERPROFILE_COLLECTION_ID',
      );

  /// Get Chat Messages Collection Id
  String get chatMessagesCollectionId =>
      const String.fromEnvironment('CHATMESSAGES_COLLECTION_ID');

  /// Get Post Bucket Id
  String get imagesBucketId =>
      const String.fromEnvironment('IMAGES_BUCKET_ID');

  /// Get User Bucket Id
  String get userBucketId =>
      const String.fromEnvironment('USER_STORAGE_BUCKET_ID');

  /// Get Appwrite Client [Client]
  Client get client =>
      _client ??
      Client(
        endPoint: _apiEndpoint,
      ).setProject(_projectId);

  /// Get Appwrite [Storage]
  Storage get storage => _storage ?? Storage(client);

  /// Get Appwrite [Databases
  Databases get databases => _databases ?? Databases(client);

  /// Get Appwrite [Account]
  Account get account => _account ?? Account(client);

  /// Get Appwrite [Realtime]
  Realtime get realtime => _realtime ?? Realtime(client);

  /// Get Appwrite [Avatars]
  Avatars get avatars => _avatars ?? Avatars(client);
}
