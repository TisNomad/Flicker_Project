import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Drawable.dart';
import 'Flicker.dart';
import 'package:wakelock/wakelock.dart';
import 'global_data.dart';
import 'global.dart' as global;
import 'myMath.dart' as my_math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(Provider<GlobalData>(
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
  bool isAnimating = true;
  var globalFlickerList = [];

  @override
  Widget build(BuildContext context) {
    //print("build() called");

    //Provider.of<GlobalData>(context).initData();

    Color backGroundColor = Provider.of<GlobalData>(context).backGroundColor;
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        toggleAnim();
        globalFlickerList.add(Flicker(
            Position(details.localPosition.dx, details.localPosition.dy),
            30,
            40,
            color: Color.fromARGB(255, Random().nextInt(200) + 55,
                Random().nextInt(200) + 55, Random().nextInt(200) + 55)));
      },
      child: Container(
        color: backGroundColor,
        child: CustomPaint(
          painter: MyPainter.acceptList(globalFlickerList),
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
  void toggleAnim() {
    if (isAnimating) {
      setState(() {
        for (var element in globalFlickerList) {
          element.stopFlicker();
        }
      });
      print("Toggled to not animate");
      isAnimating = false;
    }
    // Toggle on animating
    else {
      setState(() {
        for (int i = 0; i < globalFlickerList.length; i++) {
          globalFlickerList[i].startFlicker(
              secondaryColor: Provider.of<GlobalData>(context, listen: false)
                  .backGroundColor);
        }
      });
      print("Toggled to animate");
      isAnimating = true;
    }
  }

  @override
  void initState() {
    super.initState();
    print("initState() called from MyCanvas");
    global.initData();
    globalFlickerList = global.flickerList;
    print("List size: ${globalFlickerList.length}");

    /*
    for(int i = 0; i < 5; i++){
      flickerList.add(Flicker.generateFlicker(color: Colors.white));

    }

     */

    for (int i = 0; i < globalFlickerList.length; i++) {
      globalFlickerList[i].flickerTimer.timer = Timer.periodic(
          Duration(milliseconds: 1000 ~/ globalFlickerList[i].hz), (timer) {
        setState(() {
          globalFlickerList[i].changeColor(secondaryColor: Colors.black87);
        });
      });
    }

    isAnimating = true;
  }
}




//Custom Painter class for rendering on the canvas
class MyPainter extends CustomPainter {
  //List<Flicker> flickerList = [];
  var list = [];

  MyPainter.acceptList(this.list);

  @override
  void paint(Canvas canvas, Size size) {
    //Draw list of flickers if list has elements of flicker
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
