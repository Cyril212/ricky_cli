import 'package:colorize/colorize.dart';

enum LogType {
  classic,
  debug,
  warning,
  error,
}

class Logger {
  static void classic({required message}) => _log(message, LogType.classic);

  static void debug({required message}) => _log(message, LogType.debug);

  static void warning({required message}) => _log(message, LogType.warning);

  static void error({required message}) => _log(message, LogType.error);

  static void custom({required message, required Styles style}) => print(Colorize().apply(style, message));

  static void _log(String message, LogType type) {
    switch (type) {
      case LogType.classic:
        print(Colorize('$message').default_slyle());
        break;
      case LogType.debug:
        print(Colorize('ℹ️ [Info] $message').blue());
        break;
      case LogType.warning:
        print(Colorize('⚠️️ [Warning] $message').blue());
        break;
      case LogType.error:
        print(Colorize('⛔️ [Error] $message').red());
        break;
    }
  }
}
