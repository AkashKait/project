import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_music_player/screens/home_tab.dart';

import 'screens/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      initialRoute: Homepage.id,
      routes: {
        Homepage.id: (context) => Homepage(),
      },
    );
  }
}
