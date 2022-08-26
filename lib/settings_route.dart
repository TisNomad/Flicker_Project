// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final textController = TextEditingController();
  late int defaultValueTemp = 11;
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
          ListTile(
            trailing: Container(
              width: 150,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      child: TextField(
                        controller: textController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            if (newValue != null) {
                              setState(() {
                                defaultValueTemp =
                                    int.tryParse(newValue.text) as int;
                              });
                              print(defaultValueTemp);
                            }

                            return newValue;
                          }),
                        ],
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextButton(
                      onPressed: () {
                        if (defaultValueTemp > 2) {
                          setState(() {
                            context
                                .read<GlobalData>()
                                .setDefaultHz(defaultValueTemp);
                          });
                        } else {
                          print("Please submit a value greater than 2");
                        }
                      },
                      child: Text("Submit", textAlign: TextAlign.center),
                    ),
                  )
                ],
              ),
            ),
            title: Text(
                "Default value: ${context.read<GlobalData>().getDefaultHz()}"),
          ),
          const Divider(),
          const ListTile(
            title: Text("Setting 2"),
          ),
        ],
      ),
    );
  }
}
