import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding for async tasks
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'ChatGPT Clone',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white, // Clean background
        textTheme: TextTheme(
          bodyText2: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
      ),
      home: ChatScreen(),
    );
  }
}
