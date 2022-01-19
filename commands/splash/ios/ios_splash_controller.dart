import 'dart:io';

import 'package:image/image.dart';
import 'package:xml/xml.dart';

import '../../../core/models/icon_template_model.dart';
import '../../../utils/app_image_utils.dart';
import '../base_splash_controller.dart';
import '../../../core/constants.dart';
import '../utils/splash_utils.dart';

class IOSSplashController extends BaseSplashController<IOSIconTemplateModel> {

  IOSSplashController({
    required String backgroundColor,
  }) : super(backgroundColor);

  @override
  String get platform => kiOSPlatform;

  @override
  List<IOSIconTemplateModel> get splashIconList => <IOSIconTemplateModel>[
        IOSIconTemplateModel(path: 'LaunchImage.png', size: 1.0),
        IOSIconTemplateModel(path: 'LaunchImage@2x.png', size: 2.0),
        IOSIconTemplateModel(path: 'LaunchImage@3x.png', size: 3.0),
      ];

  @override
  void applySplashBackground() {
    log('Applying background color');

    _setBackgroundColor(backgroundColor);
  }

  void _setBackgroundColor(String? colorString) {
    if (colorString != null) {
      final parsedColor = SplashUtils.parseColor(colorString);

      var redChannel = ((int.parse(parsedColor!.substring(0, 2), radix: 16)) / 255).toString();
      var greenChannel = ((int.parse(parsedColor.substring(2, 4), radix: 16)) / 255).toString();
      var blueChannel = ((int.parse(parsedColor.substring(4, 6), radix: 16)) / 255).toString();

      final launchStoryBoardFile = File(kiOSLaunchScreenStoryboardFile);
      final parsedLaunchStoryBoardXMLDocument = XmlDocument.parse(launchStoryBoardFile.readAsStringSync());

      // Find root xml element
      final documentElement = parsedLaunchStoryBoardXMLDocument.getElement('document');

      // Get through children elements till we get to color element
      final scenesElement = documentElement?.getElement('scenes');
      final sceneElement = scenesElement?.getElement('scene');
      final objectsElement = sceneElement?.getElement('objects');
      final viewControllerElement = objectsElement?.getElement('viewController');
      final viewElement = viewControllerElement?.getElement('view');

      // Set attributes to color element
      viewElement?.getElement('color')
        ?..setAttribute('red', redChannel)
        ..setAttribute('green', greenChannel)
        ..setAttribute('blue', blueChannel)
        ..setAttribute('alpha', '1.0');

      // Save changes
      launchStoryBoardFile.writeAsStringSync(parsedLaunchStoryBoardXMLDocument.toXmlString());
    }
  }

  @override
  void generateSplashLogo() {
    log('Generating splash images');

    _applyImageIOSByMode();
  }

  void _applyImageIOSByMode() {
    _applyImageIOS(sourceImagePath);
  }

  /// Create splash screen images for original size, @2x and @3x
  void _applyImageIOS(String imagePath) {
    final image = decodeImage(File(imagePath).readAsBytesSync());
    if (image == null) {
      log(imagePath + ' could not be loaded.');
      exit(1);
    }
    for (var template in splashIconList) {
      AppImageUtils.saveImage(resFolder: kiOSAssetsLaunchImageFolder, template: template, image: image);
    }
  }
}
