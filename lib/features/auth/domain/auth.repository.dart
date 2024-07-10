import 'package:appwrite/models.dart';

/// Abstract Class for AuthRepository
abstract class AuthRepository {
  /// checks if a valid user session is available
  Future<User?> isUserAuthenticated();

  /// login user with email and password
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// sign out from current user session. [allSessions] ends all User Sessions
  /// on all devices
  Future<void> signOut({bool allSessions = false});

  /// listen to the AuthRepository State
  Stream<User?> listen();

  /// get the current user
  User? get currentUser;

  /// get the current user session
  Session? get userSession;

  /// dispose
  void dispose();
}
