import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_navbar.dart';

class ShellScaffold extends StatelessWidget {
  const ShellScaffold({
    super.key,
    required this.shell,
    required this.tabs,
    this.showNavBarOnLandscape = true,
  });

  final StatefulNavigationShell shell;
  final Iterable<BottomNavigationBarItem> tabs;
  final bool showNavBarOnLandscape;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (_, orientation) {
        return Scaffold(
          body: shell,
          bottomNavigationBar: (false == showNavBarOnLandscape &&
                  Orientation.landscape == orientation)
              ? null
              : AppNavBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: this.tabs,
                  currentIndex: shell.currentIndex,
                  onTap: (index) {
                    debugPrint('onTap started');
                    shell.goBranch(
                      index,
                      initialLocation: index == shell.currentIndex,
                    );
                    debugPrint('onTap finished');
                  },
                ),
        );
      },
    );
  }
}
