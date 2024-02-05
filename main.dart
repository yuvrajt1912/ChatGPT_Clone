import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Clone',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ChatScreen(),
    );
  }
}
