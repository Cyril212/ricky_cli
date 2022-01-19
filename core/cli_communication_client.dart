import 'base_command.dart';
import '../commands/app_icon/app_icon_command.dart';
import '../commands/splash/splash_command.dart';
import '../commands/help/help_command.dart';

class CLICommunicationClient {
  static Map<String, BaseCommand> availableCommandList = {
    'help': HelpCommand(),
    'app_icon': AppIconCommand(),
    'splash': SplashCommand(),
  };

  void executeCommand(List<String> args) {
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
