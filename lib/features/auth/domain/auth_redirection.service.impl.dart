import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../shared.dart';
import 'auth.repository.dart';
import 'auth_redirection.service.dart';

/// [AuthRedirectionService] implementation
class AuthRedirectionServiceImpl implements AuthRedirectionService {
  /// constructor
  AuthRedirectionServiceImpl({required this.authRepository});

  /// authRepository
  final AuthRepository authRepository;

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final currentUser = await authRepository.isUserAuthenticated();
    const loginRoute = AuthRoutes.loginRoute;

    if (null == currentUser) {
      return loginRoute.path;
    }

    if (loginRoute == state.fullPath) {
      return '/';
    }

    return null;
  }
}
