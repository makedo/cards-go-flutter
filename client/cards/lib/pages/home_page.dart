import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/games/duren');
          },
          child: const Text('Duren'),
        ),
      ]),
    );
  }
}
