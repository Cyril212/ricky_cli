import 'dart:io';

import '../../../core/constants.dart';
import '../../splash/templates/templates.dart';

import '../../../core/models/icon_template_model.dart';
import '../../../utils/app_image_utils.dart';
import '../base_app_icon_controller.dart';

class IOSAppIconController extends BaseAppIconController<IOSIconTemplateModel> {

  @override
  String get platform => kiOSPlatform;

  @override
  List<IOSIconTemplateModel> get appIconList => <IOSIconTemplateModel>[
        IOSIconTemplateModel(path: 'ic_launcher-20', size: 20),
        IOSIconTemplateModel(path: 'ic_launcher-20@2x', size: 20),
        IOSIconTemplateModel(path: 'ic_launcher-20@3x', size: 20),
        IOSIconTemplateModel(path: 'ic_launcher-29', size: 29),
        IOSIconTemplateModel(path: 'ic_launcher-29@2x', size: 29),
        IOSIconTemplateModel(path: 'ic_launcher-29@3x', size: 29),
        IOSIconTemplateModel(path: 'ic_launcher-40', size: 40),
        IOSIconTemplateModel(path: 'ic_launcher-40@2x', size: 40),
        IOSIconTemplateModel(path: 'ic_launcher-40@3x', size: 40),
        IOSIconTemplateModel(path: 'ic_launcher-60', size: 60),
        IOSIconTemplateModel(path: 'ic_launcher-60@2x', size: 60),
        IOSIconTemplateModel(path: 'ic_launcher-60@3x', size: 60),
        IOSIconTemplateModel(path: 'ic_launcher-76', size: 76),
        IOSIconTemplateModel(path: 'ic_launcher-76@2x', size: 76),
        IOSIconTemplateModel(path: 'ic_launcher-83.5@2x', size: 83.5),
        IOSIconTemplateModel(path: 'ic_launcher-1024@2x', size: 1024),
      ];

  @override
  void executeConfigurationProcess() => _generateContentJson();

  @override
  void generateAppIcon() {
    log('Generating app icons');

    for (var template in appIconList) {
      AppImageUtils.saveImage(resFolder: kiOSAppIconsImageFolder, template: template, image: sourceImage);
    }
  }

  void _generateContentJson() {
    log('Generating content.json file');

    final contentFile = File(kiOSContentFile);
    if (contentFile.existsSync()) {
      contentFile.delete(recursive: true);
    }
    contentFile
      ..createSync(recursive: true)
      ..writeAsStringSync(kiOSContentJson);
  }
}
