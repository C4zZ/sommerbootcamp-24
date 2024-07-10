import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Interface to describe Routes in Application Features
// ignore: one_member_abstracts
abstract class ApplicationRoutes {

  /// get GoRouter [StatefulShellBranch]
  /// defines routes that are only accessible if user is logged in
  StatefulShellBranch get secureRoutes;

  /// Get Platform Page
  Page<dynamic> getPage(Widget child) {
    if (Platform.isIOS) {
      return CupertinoPage(child: child);
    }
    return MaterialPage(child: child);
  }

  /// Create [CustomTransitionPage]
  CustomTransitionPage<dynamic> buildPageWithDefaultTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  /// get a list of defined [GoRoute] routes
  /// defines routes that are accessible even if no user is logged in
  List<GoRoute> get routes;
}
