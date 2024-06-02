import 'package:flutter/material.dart';
import 'package:flutter_chat/chatroom.dart';
import 'package:flutter_chat/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.teal[500],
        iconTheme: const IconThemeData(color: Colors.white),
        appBarTheme:
            const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[500],
              textStyle: const TextStyle(color: Colors.white)),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const Home(),
        '/chatroom': (ctx) => const ChatRoom(),
      },
    );
  }
}
