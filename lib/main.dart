// ignore_for_file: avoid_print
// A Comment

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
  MyCanvas({Key? key}) : super(key: key);

  @override
  State<MyCanvas> createState() => _MyCanvasState();
}

class _MyCanvasState extends State<MyCanvas> {
  bool isAnimating = false;
  var globalFlickerList = [];
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    //print("MyCanvas build method called.");
    final globalFlickerList = context.watch<GlobalData>().flickerList;
    Color backGroundColor =
        Provider.of<GlobalData>(context, listen: false).backGroundColor;
    Color buttonColor = context.watch<GlobalData>().buttonColor;
    Key buttonKey = Key("value");

    return Column(
      children: [
        Expanded(
          flex: 10,
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              toggleHzIncrease();
            },
            child: Container(
              color: backGroundColor,
              child: CustomPaint(
                painter: MyPainter.acceptList(globalFlickerList),
                child: Container(),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: OutlinedButton(
                  key: buttonKey,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: buttonColor,
                  ),
                  child: Text("Button"),
                  onPressed: () {
                    setState(() {
                      context.read<GlobalData>().changeButtonColor();
                    });
                  },
                ),
              ),
              Expanded(
                child: OutlinedButton(
                  child: Container(),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
  }

  void toggleHzIncrease() {
    context.read<GlobalData>().toggleHzIncrease();
  }

  //Toggles animation of the flicker objects
  void toggleAnim() {
    print("toggleAnim() method called.");
    context.read<GlobalData>().toggleFlicker(
        secondaryColor: context.read<GlobalData>().backGroundColor);
  }

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
    if (list.isEmpty) return;

    for (int i = 0; i < list.length; i++) {
      if (list[i] is Drawable) {
        list[i].drawPaint(canvas, size);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
