// ignore_for_file: avoid_print

import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'drawable.dart';
import 'flicker.dart';
import 'package:wakelock/wakelock.dart';
import 'global_data.dart';
//import 'myMath.dart' as my_math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(ChangeNotifierProvider<GlobalData>(
    create: (BuildContext context) => GlobalData(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Flicker Project"),
        ),
        body: MyCanvas(),
      ),
    );
  }
}

class MyCanvas extends StatefulWidget {
  const MyCanvas({Key? key}) : super(key: key);

  @override
  State<MyCanvas> createState() => _MyCanvasState();
}

class _MyCanvasState extends State<MyCanvas> {
  bool isAnimating = false;
  var globalFlickerList = [];
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    final myGlobal = context.watch<GlobalData>();
    Color backGroundColor = myGlobal.backGroundColor;

    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        Provider.of<GlobalData>(context, listen: false)
            .changeColor(secondaryColor: backGroundColor);
      },
      child: Container(
        color: backGroundColor,
        child: CustomPaint(
          painter: MyPainter.acceptList(myGlobal.flickerList),
          child: Container(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
  }

  //Toggles animation of the flicker objects
  void toggleAnim() {}

  @override
  void initState() {
    super.initState();
    print("initState() called from MyCanvas");
  }
}

//Custom Painter class for rendering on the canvas
class MyPainter extends CustomPainter {
  //List<Flicker> flickerList = [];
  var list = [];

  MyPainter.acceptList(this.list);

  @override
  void paint(Canvas canvas, Size size) {
    //Generic paint operation for any object that is Drawable
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        if (list[i] is Drawable) {
          list[i].drawPaint(canvas, size);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
