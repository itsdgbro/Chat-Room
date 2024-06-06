import 'package:flutter/material.dart';

AppBar myAppBar(String titleText) {
  return AppBar(
    title: Text(
      titleText,
      style: const TextStyle(color: Colors.white, fontSize: 25),
    ),
    backgroundColor: Colors.teal[500],
  );
}
