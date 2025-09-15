import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),
      body: Center(
        child: Text(
          'Welcome to the App!',
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ),
      backgroundColor: Colors.black, // Background color
    );
  }
}
