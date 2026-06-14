import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yyzouinvblkcurczgvzv.supabase.co',
    publishableKey: 'sb_publishable_IuGD_m5NdTq49kJzUsK96Q_8_TUKUh9',
  );

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
      home: HomePage(),
    );
  }
}