import '../exceptions/cli_exception.dart';

extension StringExt on String {
  String removeAll(String value) {
    var newValue = replaceAll(value, '');
    return newValue;
  }
}
