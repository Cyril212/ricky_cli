class SplashUtils {
  static String? parseColor(var color) {
    if (color is int) color = color.toString().padLeft(6, '0');

    if (color is String) {
      color = color.replaceAll('#', '').replaceAll(' ', '');
      if (color.length == 6) return color;
    }
    if (color == null) return null;

    throw Exception('Invalid color value');
  }
}
