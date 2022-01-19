import 'dart:io';

import 'package:colorize/colorize.dart';

import '../../core/base_command.dart';
import '../../core/cli_communication_client.dart';

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

  Future<String> _readLogo() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 'Error';
    }
  }

  @override
  Future<void> executionBlock() async {
    print('${Colorize(await _readLogo()).blue()}\n');
    print(Colorize('Usage: ').green());
    print('ricky_cli [command...]\n');
    print(Colorize('Commands:').red());
    CLICommunicationClient.availableCommandList.entries.forEach((entry) => print('${entry.key} - ${entry.value.description}'));
    return Future.value(null);
  }
}
