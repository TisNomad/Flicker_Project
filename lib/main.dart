// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_world/my_app.dart';
import 'package:provider/provider.dart';
import 'global_data.dart';
//import 'myMath.dart' as my_math;

//scattered throughout the code
//TODO: Provide concise and informative documentation

//Currently this code represents a proof of concept.
//Meant to be a playground for future ideas or methods for implementing
//better solutions in production.
//No localization is implemented.
//TODO: Implemet Locales
//This code has no provided documentation and relies on comments by the author

//Used print() function throughout the code for easy debugging and seeing
//the app's current situation through the output

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //GlobalData class holds global data for the app and is located at the peak of
  //the "Widget Tree". This class is capable of notifying widgets that are
  //listening.
  runApp(
    ChangeNotifierProvider<GlobalData>(
      create: (BuildContext context) => GlobalData(),
      child: const MyApp(),
    ),
  );
}
