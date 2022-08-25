import 'package:flutter/material.dart';
import 'main_route.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainRoute(),
    );
  }
}
