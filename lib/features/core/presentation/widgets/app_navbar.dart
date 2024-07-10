import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../app_theme.dart';

class AppNavBar extends StatefulWidget {
  AppNavBar({
    required this.showSelectedLabels,
    required this.showUnselectedLabels,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  }) {
    showLabels = showSelectedLabels || showUnselectedLabels;
  }

  final bool showSelectedLabels;
  final bool showUnselectedLabels;
  final Iterable<BottomNavigationBarItem> items;
  final int currentIndex;
  final void Function(int) onTap;
  late final bool showLabels;

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BottomAppBar(
      height: 50,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Row(
          children: widget.items
              .mapIndexed((index, e) => _navbarItem(e, index, themeData))
              .toList(),
        ),
      ),
    );
  }

  Widget _navbarItem(
      BottomNavigationBarItem item, int index, ThemeData themeData) {
    final isActive = index == widget.currentIndex;
    return Expanded(
      child: InkWell(
        onTap: () => widget.onTap(index),
        child: widget.showLabels
            ? ColoredBox(
          color: isActive
              ? Colors.blue
              : themeData.colorScheme.background,
          child: Column(
            children: [
              const SizedBox(height: 8),
              if (isActive) item.activeIcon else item.icon,
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0),
                child: Text(
                  item.label ?? '',
                  style:
                  Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isActive
                        ? Colors.white
                        : AppColors.blueMaterial,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
            : Container(
          height: double.infinity,
          color: isActive
              ? AppColors.blueMaterial
              : themeData.colorScheme.background,
          child: isActive ? item.activeIcon : item.icon,
        ),
      ),
    );
  }
}
