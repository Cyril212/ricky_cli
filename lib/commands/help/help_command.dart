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

  String get _localPath {
    final directory = findFolderByName('commands/help', 'logo');
    return directory?.path ?? '';
  }

  Future<File> get _localFile async {
    final path = _localPath;
    return File('$path/ascii_logo');
  }

  Future _readAndDisplayLogo() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      Logger.custom(message: contents, style: Styles.BLUE);
    } catch (e) {
      // If encountering an error, return 0
      Logger.error(message: 'Logo file is not found');
    }
    return null;
  }

  @override
  Future<void> executionBlock() async {
    await _readAndDisplayLogo();
    Logger.custom(message: 'Usage: ', style: Styles.GREEN);
    Logger.classic(message: 'ricky_cli [command...]\n');
    Logger.custom(message: 'Commands: ', style: Styles.RED);
    CLICommunicationClient.availableCommandList.entries.forEach((entry) => print('${entry.key} - ${entry.value.description}'));
    return Future.value(null);
  }
}
