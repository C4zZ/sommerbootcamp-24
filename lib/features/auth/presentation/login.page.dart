import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/login_screen.dart';

/// Login Page to authenticate User in Application
class LoginPage extends ConsumerWidget {
  /// Constructor
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: LoginScreen(),
    );
  }
}
