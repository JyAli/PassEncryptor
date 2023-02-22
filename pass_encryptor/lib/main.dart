import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore_for_file: prefer_const_constructors

final Color primary = Color.fromARGB(255, 230, 230, 230);
final TextEditingController inputController = TextEditingController();
final TextEditingController outputController = TextEditingController();

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            CopyButton(),
          ],
        ),
      ),
    );
  }
}

class utils {
  static String encrypt(String input, int shift) {
    input = input.trim().toLowerCase();
    String output = "";

    for (var charInt in input.runes) {
      charInt += shift;
      if (charInt > 122) {
        charInt -= 26;
      } else if (charInt < 97) {
        charInt += 26;
      }

      String character = String.fromCharCode(charInt);
      if (output.length == input.length - 1) {
        character = character.toUpperCase();
      }
      output = character + output;
    }
    return output;
  }
}

class InputBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      onChanged: (input) {
        outputController.text = utils.encrypt(input, 1);
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
