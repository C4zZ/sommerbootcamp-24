import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Generic App Alert Dialog
class AppDialog {
  /// Show Alert Dialog
  static Future<T?> showActionDialog<T>(
    BuildContext dialogContext,
    String title,
    Widget content, {
    required List<CupertinoDialogAction> cupertinoDialogActions,
    required List<Widget> androidActions,
    bool useRootNavigator = false,
  }) async {
    if (Platform.isIOS) {
      return showCupertinoDialog<T>(
        context: dialogContext,
        useRootNavigator: useRootNavigator,
        builder: (_) => CupertinoAlertDialog(
          key: const ValueKey('app-alert-dialog'),
          title: Text(title),
          content: content,
          actions: cupertinoDialogActions,
        ),
      );
    } else {
      return showDialog<T>(
        context: dialogContext,
        useRootNavigator: useRootNavigator,
        builder: (_) => AlertDialog(
          key: const ValueKey('app-alert-dialog'),
          title: Text(title),
          content: content,
          actions: androidActions,
        ),
      );
    }
  }

  static Future<void> showLoadingDialog({
    required BuildContext dialogContext,
    String? loadingInformation,
  }) async {
    final informationWidget =
        loadingInformation != null ? Text(loadingInformation) : null;
    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: dialogContext,
        builder: (_) => CupertinoAlertDialog(
          key: const ValueKey('app-loading-dialog'),
          title: informationWidget,
          content: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      );
    } else {
      return showDialog(
        context: dialogContext,
        builder: (context) {
          return const Center(child: CircularProgressIndicator.adaptive());
        },
      );
    }
  }

  static Future<void> showInformationDialog(
      {required BuildContext dialogContext,
      String? title,
      String? content,
      bool useRootNavigator = false,
      List<Widget>? androidDialogActions,
      List<Widget>? cupertinoDialogActions}) async {
    final titleWidget = title != null ? Text(title) : null;
    final contentWidget = content != null ? Text(content) : null;

    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: dialogContext,
        useRootNavigator: useRootNavigator,
        builder: (_) => CupertinoAlertDialog(
          key: const ValueKey('app-information-dialog'),
          title: titleWidget,
          content: contentWidget,
          actions: cupertinoDialogActions ??
              [
                CupertinoDialogAction(
                  child: CupertinoButton(
                    onPressed: () => dialogContext.pop(),
                    child: const Text('Ok'),
                  ),
                ),
              ],
        ),
      );
    } else {
      return showDialog(
        context: dialogContext,
        useRootNavigator: useRootNavigator,
        builder: (_) => AlertDialog(
          key: const ValueKey('app-information-dialog'),
          title: titleWidget,
          content: contentWidget,
          actions: androidDialogActions ??
              [
                TextButton(
                  onPressed: () => dialogContext.pop(),
                  child: const Text('Ok'),
                ),
              ],
        ),
      );
    }
  }
}
