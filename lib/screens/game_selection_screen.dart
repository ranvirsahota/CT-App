import 'package:flutter/material.dart';

class GameSelectionScreen extends StatefulWidget {
  GameSelectionScreen({Key? key}) : super(key: key);

  @override
  _GameSelectionScreenState createState() => _GameSelectionScreenState();
}

class _GameSelectionScreenState extends State<GameSelectionScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Games Selection'),
    ),
  );
}