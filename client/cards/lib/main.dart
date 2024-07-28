import 'package:flutter/material.dart';
import 'package:cards/games/duren/widgets/duren_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Duren',
      home: DurenGame(),
    );
  }
}
