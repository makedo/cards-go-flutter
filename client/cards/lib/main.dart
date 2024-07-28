import 'package:cards/config/config.dart';
import 'package:cards/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cards/games/duren/widgets/duren_game_widget.dart';

void main() async {
  await Config.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cards',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const HomePage(),
        '/games/duren': (BuildContext context) => const DurenGameWidget(),
      },
    );
  }
}
