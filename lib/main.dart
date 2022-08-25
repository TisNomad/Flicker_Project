// ignore_for_file: avoid_print
// A Comment

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_world/my_app.dart';
import 'package:hello_world/settings_route.dart';
import 'package:provider/provider.dart';
import 'my_painter.dart';
//import 'flicker.dart';
import 'package:wakelock/wakelock.dart';
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
