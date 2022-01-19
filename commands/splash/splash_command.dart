import 'dart:io';

import 'android/android_splash_controller.dart';
import 'package:cli_dialog/cli_dialog.dart';
import '../../utils/find_file/find_folder_by_directory.dart';
import '../../core/base_command.dart';

import 'ios/ios_splash_controller.dart';

class SplashCommand extends BaseCommand<SplashCommand> {

  @override
  String? get description => 'Generate native splash screen';

  @override
  Future<void> executionBlock() async {
    final dialog = CLI_Dialog(questions: [
      ['Are in the root folder of the project, and source image is located at assets/cli/splash? [y/n]', 'isInRoot'],
      ['Please type in background color in HEX format like: #000000', 'backgroundColor'],
    ]);

    final dialogAnswers = dialog.ask();
    if (dialogAnswers['isInRoot'] != 'y') {
      print('Make sure, you are in root folder and try it out later!');
      exit(0);
    }

    try {
      findFolderByName('assets/cli', 'splash')!.path;
      print('Folder is found');
    } catch (e) {
      print('Folder is not found');
      exit(0);
    }

    await AndroidSplashController(backgroundColor: dialogAnswers['backgroundColor']).execute();

    if (Directory('ios').existsSync()) {
      await IOSSplashController(backgroundColor: dialogAnswers['backgroundColor']).execute();
    } else {
      print('iOS folder not found, skipping iOS splash update...');
    }

    return Future.value(null);
  }
}
