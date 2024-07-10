import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';

/// Notify when AuthState changed
class AuthStateNotifier extends ChangeNotifier {
  /// constructor
  AuthStateNotifier({required this.userStream}) {
    _streamSubscription = userStream.listen((event) {
      notifyListeners();
    });
  }

  /// User Stream
  final Stream<User?> userStream;
  late StreamSubscription<User?> _streamSubscription;

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }
}
