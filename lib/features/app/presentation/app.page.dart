import 'package:flutter/material.dart';

/// Home
class Home extends StatelessWidget {
  /// constructor
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juhu'),
      ),
      body: const Center(
        child: Text('Home from app Page'),
      ),
    );
  }
}
