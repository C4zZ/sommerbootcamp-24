import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// GoRouter Redirection Service
// ignore: one_member_abstracts
abstract class AuthRedirectionService {
  /// Redirect User
  Future<String?> redirect(BuildContext context, GoRouterState state);
}
