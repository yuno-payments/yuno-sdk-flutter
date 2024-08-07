import 'package:flutter/material.dart';
import 'package:yuno/yuno.dart';

void main() {
  // final injector = YunoServiceLocator();
  // final channels = YunoChannels();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Yuno(
        child: Scaffold(
          body: Center(
            child: Text('Hello World!'),
          ),
        ),
      ),
    );
  }
}
