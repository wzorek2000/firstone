import 'package:flutter/material.dart';

class MyThemes {
  static final List<ThemeData> themes = [
    ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue.shade100,
        primaryColor: const Color.fromARGB(255, 63, 171, 188)),
    ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.red.shade100,
        primaryColor: Colors.pink),
    ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green.shade100,
        primaryColor: const Color.fromARGB(255, 63, 188, 90)),
    ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.purple.shade100,
        primaryColor: const Color.fromARGB(255, 185, 31, 193)),
    ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.orange.shade100,
        primaryColor: const Color.fromARGB(255, 255, 165, 0)),
  ];
}
