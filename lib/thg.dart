import 'package:flutter/material.dart';
import 'pages/home_page.dart' as home_page;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'World Cup Live',
      theme: ThemeData.dark(),
      home: const home_page.HomePage(),
    );
  }
}