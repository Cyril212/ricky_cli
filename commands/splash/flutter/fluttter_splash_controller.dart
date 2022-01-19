import 'dart:io';

import 'package:image/image.dart';

import '../../../core/models/icon_template_model.dart';
import '../../../utils/app_image_utils.dart';
import '../base_splash_controller.dart';
import '../../../core/constants.dart';

class FlutterSplashController extends BaseSplashController<FlutterTemplateModel> {
  FlutterSplashController() : super('');

  @override
  String get platform => kFlutterPlatform;

  @override
  List<FlutterTemplateModel> get splashIconList => <FlutterTemplateModel>[
        FlutterTemplateModel(path: '', size: 1),
        FlutterTemplateModel(path: '1.5x', size: 1.5),
        FlutterTemplateModel(path: '2.0x', size: 2),
        FlutterTemplateModel(path: '3.0x', size: 3),
        FlutterTemplateModel(path: '4.0x', size: 4),
      ];

  @override
  void applySplashBackground() {}

  @override
  void generateSplashLogo() {
    print('[Flutter] Creating ' + (hasDarkMode ? 'dark mode ' : '') + 'splash images');

    final image = decodeImage(File(sourceImagePath).readAsBytesSync());
    if (image == null) {
      print('The file $sourceImagePath could not be read.');
      exit(1);
    }
    for (var template in splashIconList) {
      AppImageUtils.saveImage(resFolder: sourceImagePath, template: template, image: image);
    }
  }
}
