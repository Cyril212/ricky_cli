import 'dart:io';

import 'package:colorize/colorize.dart';

import '../../core/base_command.dart';
import '../../core/cli_communication_client.dart';
import '../../core/logger.dart';

import '../../utils/find_file/find_folder_by_directory.dart';

class HelpCommand extends BaseCommand<HelpCommand> {
  @override
  String get startUpLog => '';

  @override
  String get complitionLog => '';

  @override
  String? get description => 'List of commands';

  @override
  Future<void> executionBlock() async {
    Logger.custom(message: '''   ____ ______ _      _            _____  _     _____  ____
  / / / | ___ (_)    | |          /  __ \\\| |   |_   _| \\ \\ \\
 / / /  | |_/ /_  ___| | ___   _  | /  \\\/| |     | |    \\ \\ \\
< < <   |    /| |/ __| |/ / | | | | |    | |     | |     > > >
 \\ \\ \\  | |\\ \\| | (__|   <| |_| | | \\__/\\\| |_____| |__  / / /
  \\_\\_\\ \\_| \\_|_|\\___|_| \\\_\\\__, |  \\____/\\_____/\\____/ /_/_/
                           __/  |
                           |___/''', style: Styles.BLUE);
    Logger.custom(message: 'Usage: ', style: Styles.GREEN);
    Logger.classic(message: 'ricky_cli [command...]\n');
    Logger.custom(message: 'Commands: ', style: Styles.RED);
    CLICommunicationClient.availableCommandList.entries.forEach((entry) => print('${entry.key} - ${entry.value.description}'));
    return Future.value(null);
  }
}
