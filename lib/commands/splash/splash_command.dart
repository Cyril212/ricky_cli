import 'dart:io';

import 'package:image/image.dart';
import 'package:ricky_cli/core/constants.dart';

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
          final sourceImage = decodeImage(File(kSourceSplashImagePath).readAsBytesSync());

          //todo:handle no file found exception
          switch (platform) {
            case Platform.android:
              _executeAndroidSplashGeneration(backgroundColor: answer['backgroundColor'], customSourceImage: sourceImage!);
              break;
            case Platform.ios:
              _executeIOSSplashGeneration(backgroundColor: answer['backgroundColor'], customSourceImage: sourceImage!);
              break;
            case Platform.both:
              _executeSplashScreenGeneration(backgroundColor: answer['backgroundColor'], customSourceImage: sourceImage!);
              break;
          }
        });

    return Future.value(null);
  }

  Future _executeSplashScreenGeneration({required String backgroundColor, required Image customSourceImage}) async {
    await _executeAndroidSplashGeneration(backgroundColor: backgroundColor, customSourceImage: customSourceImage);
    await _executeIOSSplashGeneration(backgroundColor: backgroundColor, customSourceImage: customSourceImage);
  }

  Future _executeAndroidSplashGeneration({required String backgroundColor, required Image customSourceImage}) {
    return AndroidSplashController(backgroundColor: backgroundColor, customSourceImage: customSourceImage).execute();
  }

  Future _executeIOSSplashGeneration({required String backgroundColor, required Image customSourceImage}) =>
      IOSSplashController(backgroundColor: backgroundColor, customSourceImage: customSourceImage).execute();
}
