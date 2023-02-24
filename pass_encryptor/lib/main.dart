import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Utils.dart';
// ignore_for_file: prefer_const_constructors

final Color primary = Color.fromARGB(255, 230, 230, 230);
final TextEditingController inputController = TextEditingController();
final TextEditingController outputController = TextEditingController();
final TextEditingController shiftController = TextEditingController();
int shift = 0;

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setupShift();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              width: MediaQuery.of(context).size.width * 0.8,
              child: InputBox(),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              width: MediaQuery.of(context).size.width * 0.8,
              child: OutputBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                CopyButton(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.12, 0, 0, 0),
                    child: IconButton(
                      onPressed: () {
                        openDialog(context);
                      },
                      icon: Icon(Icons.settings),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setupShift() async {
    try {
      String value = await Utils.readFromFile("shift.txt");
      shift = int.parse(value);
    } catch (e) {}
  }

  void openDialog(var context) {
    shiftController.text = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Shift"),
        content: TextField(
          controller: shiftController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: primary),
            ),
            labelText: 'New Shift Amount',
            prefixIcon: Icon(
              Icons.text_rotation_none,
              color: primary,
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                cancelShift(context);
              },
              child: Text("Cancel")),
          TextButton(
              onPressed: () {
                submitShift(context);
              },
              child: Text("Save")),
        ],
      ),
    );
  }

  Future<void> submitShift(var context) async {
    Navigator.of(context).pop();
    if (shiftController.text.isNotEmpty) {
      shift = int.parse(shiftController.text);
      outputController.text = Utils.encrypt(inputController.text, shift);
      Utils.saveToFile(shiftController.text, "shift.txt");
    }
  }

  void cancelShift(var context) {
    Navigator.of(context).pop();
  }
}

class InputBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      onChanged: (input) {
        if (shift != 0) outputController.text = Utils.encrypt(input, shift);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
        ),
        labelText: 'Input',
        prefixIcon: Icon(
          Icons.key,
          color: primary,
        ),
      ),
    );
  }
}

class OutputBox extends StatefulWidget {
  @override
  OutputBoxState createState() => OutputBoxState();
}

class OutputBoxState extends State<OutputBox> {
  bool hidePass = true;
  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (hidePass) {
      icon = Icons.visibility;
    } else {
      icon = Icons.visibility_off;
    }
    return TextField(
      controller: outputController,
      obscureText: hidePass,
      enableSuggestions: false,
      autocorrect: false,
      readOnly: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
        ),
        labelText: 'Output',
        prefixIcon: Icon(
          Icons.lock,
          color: primary,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              hidePass = !hidePass;
            });
          },
          icon: Icon(icon),
        ),
      ),
    );
  }
}

class CopyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: outputController.text));
      },
      icon: Icon(
        Icons.content_copy,
        color: primary,
      ),
      label: Text("Copy"),
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: BorderSide(width: 2.0, color: primary),
      ),
    );
  }
}
