import 'package:flutter/material.dart';
import 'package:wikipediarama/Home.dart';

final navKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
      MaterialApp(
        navigatorKey: navKey,
    home: Home(),
  ));
}