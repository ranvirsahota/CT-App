import 'package:flutter/material.dart';

const textFormFieldDecoration =  InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder (
      borderSide: BorderSide(color: Colors.white, width: 2)
  ),
  focusedBorder: OutlineInputBorder (
      borderSide: BorderSide(color: Colors.pink, width: 2)
  ),
);

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    primary:Colors.pink,
    textStyle: const TextStyle(color:Colors.white, fontSize: 20)
);