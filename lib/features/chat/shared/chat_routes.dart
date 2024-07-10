import 'package:go_router/go_router.dart';

import '../../core/domain.dart';
import '../../core/shared/goroute_model.dart';
import '../presentation.dart';
import '../presentation/widgets/chat_widget.dart';

/// Chat Feature Routes
class ChatRoutes extends ApplicationRoutes {
  /// Root Page des Chats
  static const GoRouteModel chatRootPage =
      GoRouteModel(path: '/chat', name: 'chatRootPage');

  /// Root Page des Chats
  static const GoRouteModel messagePage =
      GoRouteModel(path: 'message', name: 'messagePage');

  @override
  List<GoRoute> get routes => throw Exception(
      'No GoRouter Routes available for this Route Configuration');

  @override
  StatefulShellBranch get secureRoutes => StatefulShellBranch(
        routes: [
          GoRoute(
            path: chatRootPage.path,
            pageBuilder: (_, __) => getPage(
              const ChatPage(),
            ),
            routes: [
              GoRoute(
                path: messagePage.path,
                pageBuilder: (_, GoRouterState state) {
                  return getPage(
                    ChatWidget(
                      isNewChat: state.uri.queryParameters['new'] == 'true',
                      receiverUserId:
                          state.uri.queryParameters['receiverUserId']!,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      );
}
