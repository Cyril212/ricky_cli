import 'dart:io';

import 'package:cli_dialog/cli_dialog.dart';
import 'package:image/image.dart';

import '../../core/constants.dart';
import '../../core/base_command.dart';
import '../../core/logger.dart';

import 'android/android_app_icon_controller.dart';
import '../../utils/general_utils.dart';
import 'ios/ios_app_icon_controller.dart';
import '../../utils/exceptions/cli_exception.dart';

class AppIconCommand extends BaseCommand<AppIconCommand> {
  @override
  String? get description => 'Generate app icons';

  Future _executeAppIconGeneration({required Image image, required String backgroundColor}) async {
    await _executeAndroidAppIconGeneration(image: image, backgroundColor: backgroundColor);
    await _executeIOSAppIconGeneration(image: image, backgroundColor: backgroundColor);
  }

  Future _executeAndroidAppIconGeneration({required Image image, required String backgroundColor}) =>
      AndroidAppIconController(image: image, backgroundColor: backgroundColor).execute();

  Future _executeIOSAppIconGeneration({required Image image, required String backgroundColor}) => IOSAppIconController(image: image).execute();

  @override
  Future<void> executionBlock() async {
    final dialog = CLI_Dialog(questions: [
      ['Are in the root folder of the project, and source image is located at assets/cli/app_icon? [y/n]', 'isInRoot'],
      ['What platform would you like generate icons for? \n 1. Android. \n 2. iOS. \n 3. Both.', 'platformPreference'],
      ['Please type in background color in HEX format like: #000000', 'backgroundColor'],
    ]);

    final dialogAnswers = dialog.ask();

    final image = decodeImage(File(kSourceAppIconImagePath).readAsBytesSync());
    if (image == null) {
      throw CliException('ic_launcher.png is not found in assets/cli/app_icon/');
    }

    if (dialogAnswers['isInRoot'] != 'y') {
      Logger.debug(message: 'Make sure, you are in root folder and try it out later.');
      exit(0);
    }

    final chosenPlatformPreference = Platform.values.firstWhere((platform) => platform.index == optionAnswer(dialogAnswers['platformPreference']));
    switch (chosenPlatformPreference) {
      case Platform.android:
        await _executeAndroidAppIconGeneration(image: image, backgroundColor: dialogAnswers['backgroundColor']);
        break;
      case Platform.ios:
        await _executeIOSAppIconGeneration(image: image, backgroundColor: dialogAnswers['backgroundColor']);
        break;
      case Platform.both:
        await _executeAppIconGeneration(image: image, backgroundColor: dialogAnswers['backgroundColor']);
        break;
      default:
        throw CliException('Something went wrong');
    }
    return null;
  }
}
