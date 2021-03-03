import 'package:flutter/material.dart';
import 'package:quick_blox_aleph/chatPage.dart';
import 'package:quick_blox_aleph/dialogsPage.dart';
import 'package:quick_blox_aleph/homepage.dart';
import 'package:quick_blox_aleph/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/homePage': (context) => HomePage(),
        '/dialogsPage': (context) => DialogsPage(),
        '/chatPage': (context) => ChatPage(),
      },
      initialRoute: "/",
    );
  }
}