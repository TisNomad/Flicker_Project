// ignore_for_file: avoid_print
// A Comment

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_world/my_app.dart';

import 'package:provider/provider.dart';

import 'global_data.dart';
//import 'myMath.dart' as my_math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    ChangeNotifierProvider<GlobalData>(
      create: (BuildContext context) => GlobalData(),
      child: const MyApp(),
    ),
  );
}
