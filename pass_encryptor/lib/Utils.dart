// ignore_for_file: file_names

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Utils {
  static String encrypt(String input, int shift) {
    input = input.trim().toLowerCase();
    String output = "";

    for (var charInt in input.runes) {
      if (charInt >= 97 && charInt <= 122) {
        charInt += shift;
        while (charInt > 122) {
          charInt -= 26;
        }
        while (charInt < 97) {
          charInt += 26;
        }
      }
      String character = String.fromCharCode(charInt);
      if (output.length == input.length - 1) {
        character = character.toUpperCase();
      }
      output = character + output;
    }
    return output;
  }

  static Future<String> getFilePath(String fileName) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/$fileName';
    return filePath;
  }

  static void saveToFile(String text, String fileName) async {
    File file = File(await getFilePath(fileName));
    file.writeAsString(text);
  }

  static Future<String> readFromFile(String fileName) async {
    File file = File(await getFilePath(fileName));
    String fileContent = await file.readAsString();

    return fileContent;
  }
}
