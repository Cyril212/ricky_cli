import 'base_command.dart';
import '../commands/app_icon/app_icon_command.dart';
import '../commands/splash/splash_command.dart';
import '../commands/help/help_command.dart';
import '../core/logger.dart';

import '../utils/exceptions/cli_exception.dart';

class CLICommunicationClient {
  static Map<String, BaseCommand> availableCommandList = {
    'help': HelpCommand(),
    'app_icon': AppIconCommand(),
    'splash': SplashCommand(),
  };

  final List<String> args;

  CLICommunicationClient(this.args) {
    try {
      _executeCommand(args);
    } on Exception catch (exception, _) {
      if (exception is CliException) {
        Logger.error(message: exception.message);
      } else {
        Logger.error(message: exception.toString());
      }
    }
  }

  void _executeCommand(List<String> args) {
    try {
      final checkIfCommandExists = _checkIfCommandExist(args.first);
      if (checkIfCommandExists) {
        availableCommandList[args.first]!.execute();
      } else {
        availableCommandList['help']!.execute();
      }
    } catch (e) {
      availableCommandList['help']!.execute();
    }
  }

  bool _checkIfCommandExist(String command) => availableCommandList.containsKey(command);
}
