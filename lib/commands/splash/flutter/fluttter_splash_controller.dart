import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:ricky_cli/core/base_controller.dart';

import '../../../core/models/icon_template_model.dart';
import '../../../utils/app_image_utils.dart';
import '../base_splash_controller.dart';
import '../../../core/constants.dart';
import '../../../core/logger.dart';

class FlutterSplashController extends BaseSplashController<FlutterTemplateModel> {
  FlutterSplashController({required Image customSourceImage}) : super(backgroundColor: '', customSourceImage: customSourceImage);

  @experimental
  FlutterSplashController.custom({required String backgroundColor, required Image customSourceImage, ErrorHandler? errorHandler, String? rootPath})
      : super.custom(backgroundColor: backgroundColor, customSourceImage: customSourceImage, errorHandler: errorHandler, rootPath: rootPath);

  @override
  String get platform => kFlutterPlatform;

  @override
  List<FlutterTemplateModel> get splashIconList => <FlutterTemplateModel>[
        FlutterTemplateModel(path: 'ic_splash.png', dimens: 1.0),
        FlutterTemplateModel(path: '1.5x/ic_splash.png', dimens: 1.5),
        FlutterTemplateModel(path: '2.0x/ic_splash.png', dimens: 2.0),
        FlutterTemplateModel(path: '3.0x/ic_splash.png', dimens: 3.0),
        FlutterTemplateModel(path: '4.0x/ic_splash.png', dimens: 4.0),
      ];

  @override
  void applySplashBackground() {}

  @override
  void generateSplashLogo() {
    Logger.debug(message: '[Flutter] Creating splash images');

    for (var template in splashIconList) {
      AppImageUtils.saveImage(resFolder: getFullPath(kSplashImageFolder), template: template, image: customSourceImage);
    }
  }
}
