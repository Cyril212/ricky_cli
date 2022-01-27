import 'dart:io';

import 'package:cli_dialog/cli_dialog.dart';
import 'package:image/image.dart';

import '../../core/constants.dart';
import '../../core/base_command.dart';
import '../../core/logger.dart';
import '../../core/dialog_interactor.dart';

import 'android/android_app_icon_controller.dart';
import '../../utils/general_utils.dart';
import 'ios/ios_app_icon_controller.dart';

class AppIconCommand extends BaseCommand<AppIconCommand> {
  @override
  String? get description => 'Generate app icons';

  @override
  Future<void> executionBlock() async {
    DialogInteractor.instance.platformAwareInteraction(
        questions: [
          ['Are in the root folder of the project, and source image is located at assets/cli/app_icon? [y/n]', 'isInRoot'],
          ['Please type in background color in HEX format like: #000000', 'backgroundColor'],
        ],
        onAnswer: (answer) {
          if (answer['isInRoot'] != null && answer['isInRoot'] != 'y') {
            Logger.error(message: 'Make sure, you are in root folder and try it out later!');
            exit(0);
          }
        },
        onPlatformAnswer: (platform, answer) {
          switch (platform) {
            case Platform.android:
              _executeAndroidAppIconGeneration(backgroundColor: answer['backgroundColor']);
              break;
            case Platform.ios:
              _executeIOSAppIconGeneration(backgroundColor: answer['backgroundColor']);
              break;
            case Platform.both:
              _executeAppIconGeneration(backgroundColor: answer['backgroundColor']);
              break;
          }
        });

    return null;
  }

  Future _executeAppIconGeneration({required String backgroundColor}) async {
    await _executeAndroidAppIconGeneration(backgroundColor: backgroundColor);
    await _executeIOSAppIconGeneration(backgroundColor: backgroundColor);
  }

  Future _executeAndroidAppIconGeneration({required String backgroundColor}) => AndroidAppIconController(backgroundColor: backgroundColor).execute();

  Future _executeIOSAppIconGeneration({required String backgroundColor}) => IOSAppIconController().execute();
}



