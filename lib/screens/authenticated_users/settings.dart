import 'package:flutter/material.dart';

class MSettings extends StatefulWidget {
  const MSettings({Key? key}) : super(key: key);

  @override
  _MSettings createState() => _MSettings();
}

class _MSettings extends State<MSettings> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Settings'),
    ),
  );
}