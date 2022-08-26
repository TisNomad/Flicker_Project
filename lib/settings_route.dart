import 'package:flutter/material.dart';
import 'package:hello_world/global_data.dart';
import 'package:provider/provider.dart';
//import 'package:hello_world/global_data.dart';

//Can be accessed from main_route
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var settingsValueList =
        Provider.of<GlobalData>(context, listen: true).settingsValueList;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CheckboxListTile(
            title: const Text("Setting 1"),
            value: settingsValueList[0] as bool,
            onChanged: (newValue) {
              setState(() {
                settingsValueList[0] = newValue;
              });
            },
          ),
          const Divider(thickness: 1),
          CheckboxListTile(
            title: const Text("Setting 2"),
            value: settingsValueList[1] as bool,
            onChanged: (newValue) {
              setState(() {
                settingsValueList[1] = newValue;
              });
            },
          ),
        ],
      ),
    );
  }
}
