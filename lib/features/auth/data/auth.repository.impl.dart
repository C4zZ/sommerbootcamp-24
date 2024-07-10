import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';

import '../../core/shared.dart';
import '../domain/auth.repository.dart';

/// Auth Repository implementation, implements [AuthRepository]
class AuthRepositoryImpl implements AuthRepository {
  /// Constructor
  AuthRepositoryImpl({required this.appwriteClient});

  /// Appwrite Project Configurations and Service
  final AppwriteClient appwriteClient;

  final StreamController<User?> _userStreamController = StreamController();
  User? _currentUser;
  Session? _currentSession;

  @override
  Future<User?> isUserAuthenticated() async {
    try {
      final user = await appwriteClient.account.get();

      // Missing hash and equals implementations in Appwrite User model,
      // so user id is checked
      if (_currentUser?.$id != user.$id) {
        _currentUser = user;
        _userStreamController.add(_currentUser);
      }
    } catch (e) {
      if (null != _currentUser) {
        _currentUser = null;
        _userStreamController.add(_currentUser);
      }
    }

    return _currentUser;
  }

  @override
  Stream<User?> listen() => _userStreamController.stream;

  @override
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _currentSession = await appwriteClient.account.createEmailSession(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    await isUserAuthenticated();
  }

  @override
  Future<void> signOut({bool allSessions = false}) async {
    dynamic result;
    try {
      if (allSessions) {
        result = await appwriteClient.account.deleteSessions();
      } else {
        final sessionId = _currentSession?.$id ?? 'current';
        result =
            await appwriteClient.account.deleteSession(sessionId: sessionId);
      }
      _userStreamController.add(null);
      debugPrint('Delete Session Result: $result');
    } catch (e) {
      debugPrint(e.toString());
    }
    _currentUser = null;
    _currentSession = null;
    _userStreamController.add(null);
  }

  @override
  void dispose() {
    _userStreamController.close();
  }

  @override
  User? get currentUser => _currentUser;

  @override
  Session? get userSession => _currentSession;
}
