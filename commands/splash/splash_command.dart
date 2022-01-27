import 'dart:io';

import 'android/android_splash_controller.dart';
import '../../core/base_command.dart';
import '../../core/dialog_interactor.dart';

import '../../core/logger.dart';
import '../../utils/general_utils.dart';

import 'ios/ios_splash_controller.dart';

class SplashCommand extends BaseCommand<SplashCommand> {
  @override
  String? get description => 'Generate native splash screen';

  @override
  Future<void> executionBlock() {
    DialogInteractor.instance.platformAwareInteraction(
        questions: [
          ['Are in the root folder of the project, and source image is located at assets/cli/splash? [y/n]', 'isInRoot'],
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
              _executeAndroidSplashGeneration(backgroundColor: answer['backgroundColor']);
              break;
            case Platform.ios:
              _executeIOSSplashGeneration(backgroundColor: answer['backgroundColor']);
              break;
            case Platform.both:
              _executeSplashScreenGeneration(backgroundColor: answer['backgroundColor']);
              break;
          }
        });

    return Future.value(null);
  }

  Future _executeSplashScreenGeneration({required String backgroundColor}) async {
    await _executeAndroidSplashGeneration(backgroundColor: backgroundColor);
    await _executeIOSSplashGeneration(backgroundColor: backgroundColor);
  }

  Future _executeAndroidSplashGeneration({required String backgroundColor}) => AndroidSplashController(backgroundColor: backgroundColor).execute();

  Future _executeIOSSplashGeneration({required String backgroundColor}) => IOSSplashController(backgroundColor: backgroundColor).execute();
}
