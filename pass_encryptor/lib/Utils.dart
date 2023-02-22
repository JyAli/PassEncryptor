class Utils {
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
