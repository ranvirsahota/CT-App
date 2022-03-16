import 'package:flutter/material.dart';

class GameSelection extends StatefulWidget {
  const GameSelection({Key? key}) : super(key: key);

  @override
  _GameSelectionState createState() => _GameSelectionState();
}

class _GameSelectionState extends State<GameSelection> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Games Selection'),
    ),
  );
}