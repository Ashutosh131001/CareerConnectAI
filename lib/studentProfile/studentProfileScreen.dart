import 'package:flutter/material.dart';

class StudentSetupScreen extends StatelessWidget {
  const StudentSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Setup')),
      body: const Center(
        child: Text(
          'Student Flow: Let\'s set up your commuter profile.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
