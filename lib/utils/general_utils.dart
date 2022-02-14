enum Platform { android, ios, both }


int optionAnswer(String answer) => (int.parse(answer) - 1);

class ColorUtils {
  static int hexToColor(String code) {
    return int.parse(code.substring(1, 7), radix: 16) + 0xFF000000;
  }
}