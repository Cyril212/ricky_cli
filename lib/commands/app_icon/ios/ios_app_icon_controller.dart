import 'dart:io';

import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:ricky_cli/core/base_controller.dart';
import 'package:ricky_cli/utils/general_utils.dart';

import '../../../core/constants.dart';
import '../../splash/templates/templates.dart';

import '../../../core/models/icon_template_model.dart';
import '../../../utils/app_image_utils.dart';
import '../base_app_icon_controller.dart';

class IOSAppIconController extends BaseAppIconController<IOSIconTemplateModel> {
  final double _resizeAmount;

  IOSAppIconController({required String backgroundColor, required Image customSourceImage})
      : _resizeAmount = 1,
        super(backgroundColor: backgroundColor, customSourceImage: customSourceImage);

  @experimental
  IOSAppIconController.custom(
      {required String backgroundColor, required Image customSourceImage, required resizeAmount, ErrorHandler? errorHandler, String? rootPath})
      : _resizeAmount = resizeAmount,
        super.custom(backgroundColor: backgroundColor, customSourceImage: customSourceImage, errorHandler: errorHandler, rootPath: rootPath);

  @override
  String get platform => kiOSPlatform;

  @override
  List<IOSIconTemplateModel> get appIconList => <IOSIconTemplateModel>[
    IOSIconTemplateModel(path: 'ic_launcher-20', size: 20.0),
    IOSIconTemplateModel(path: 'ic_launcher-20@2x', size: 40.0),
    IOSIconTemplateModel(path: 'ic_launcher-20@3x', size: 60.0),
    IOSIconTemplateModel(path: 'ic_launcher-29', size: 29.0),
    IOSIconTemplateModel(path: 'ic_launcher-29@2x', size: 58.0),
    IOSIconTemplateModel(path: 'ic_launcher-29@3x', size: 87.0),
    IOSIconTemplateModel(path: 'ic_launcher-40', size: 40.0),
    IOSIconTemplateModel(path: 'ic_launcher-40@2x', size: 80.0),
    IOSIconTemplateModel(path: 'ic_launcher-40@3x', size: 120.0),
    IOSIconTemplateModel(path: 'ic_launcher-60@2x', size: 120.0),
    IOSIconTemplateModel(path: 'ic_launcher-60@3x', size: 180.0),
    IOSIconTemplateModel(path: 'ic_launcher-76', size: 76.0),
    IOSIconTemplateModel(path: 'ic_launcher-76@2x', size: 152.0),
    IOSIconTemplateModel(path: 'ic_launcher-83.5@2x', size: 167.0),
    IOSIconTemplateModel(path: 'ic_launcher-1024', size: 1024.0),
  ];

  @override
  void executeConfigurationProcess() => _generateContentJson();

  @override
  void generateAppIcon() {
    logger('Generating app icons');

    // Create alpha layer for xxxhdpi foreground icon (the biggest dimension in android)
    final baseAlphaChannelLayerImage = Image((customSourceImage.width).toInt(), (customSourceImage.width).toInt())
      ..fillBackground(ColorUtils.hexToColor(backgroundColor!));

    final resizedBaseForegroundImage = copyResize(
      customSourceImage,
      width: (customSourceImage.width * _resizeAmount).toInt(),
      height: (customSourceImage.height * _resizeAmount).toInt(),
      interpolation: Interpolation.average,
    );

    // Define paddings for [resizedBaseForegroundImage]
    final paddingX = (baseAlphaChannelLayerImage.width - resizedBaseForegroundImage.width) ~/ 2;
    final paddingY = (baseAlphaChannelLayerImage.height - resizedBaseForegroundImage.height) ~/ 2;

    final foregroundImage = drawImage(baseAlphaChannelLayerImage, resizedBaseForegroundImage, dstX: paddingX, dstY: paddingY);

    for (var template in appIconList) {
      AppImageUtils.saveImage(resFolder: getFullPath(kiOSAppIconsImageFolder), template: template, image: foregroundImage);
    }
  }

  void _generateContentJson() {
    logger('Generating content.json file');

    final contentFile = File(getFullPath(kiOSContentFile));
    if (contentFile.existsSync()) {
      contentFile.delete(recursive: true);
    }
    contentFile
      ..createSync(recursive: true)
      ..writeAsStringSync(kiOSContentJson);
  }
}
