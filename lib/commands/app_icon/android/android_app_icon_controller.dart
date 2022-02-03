import 'dart:io';

import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:ricky_cli/core/base_controller.dart';
import 'package:xml/xml.dart';
import '../../../core/models/icon_template_model.dart';
import 'package:ricky_cli/utils/app_image_utils.dart';
import '../../../core/constants.dart';
import '../../../utils/exceptions/cli_exception.dart';
import '../base_app_icon_controller.dart';

class AndroidAppIconController extends BaseAppIconController<AndroidIconTemplateModel> {
  AndroidAppIconController({required String backgroundColor}) : super(backgroundColor: backgroundColor);

  @experimental
  AndroidAppIconController.custom({required String backgroundColor, Image? customSourceImage, ErrorHandler? errorHandler})
      : super.custom(backgroundColor: backgroundColor, customSourceImage: customSourceImage, errorHandler: errorHandler);

  @override
  String get platform => kAndroidPlatform;

  @override
  List<AndroidIconTemplateModel> get appIconList =>
      AndroidIconTemplateModel.generateAppIconTemplateModelListByIconTypeList(<AndroidIconTemplateModel>[
        AndroidIconTemplateModel(path: 'mipmap-ldpi', dimens: 0.75),
        AndroidIconTemplateModel(path: 'mipmap-mdpi', dimens: 1.0),
        AndroidIconTemplateModel(path: 'mipmap-hdpi', dimens: 1.5),
        AndroidIconTemplateModel(path: 'mipmap-xhdpi', dimens: 2.0),
        AndroidIconTemplateModel(path: 'mipmap-xxhdpi', dimens: 3.0),
        AndroidIconTemplateModel(path: 'mipmap-xxxhdpi', dimens: 4.0),
      ]);

  @override
  void generateAppIcon() {
    logger('Generating icons');

    final resizedBaseImage = copyResize(
      sourceImage,
      width: 192,
      height: 192,
      interpolation: Interpolation.average,
    );

    final circleResizedBaseImage = copyCropCircle(resizedBaseImage);

    for (var template in appIconList) {
      if (template.type == AndroidIconTemplateModelType.ic_launcher_round) {
        AppImageUtils.saveImage(resFolder: kAndroidResFolder, template: template, image: circleResizedBaseImage);
      } else {
        AppImageUtils.saveImage(resFolder: kAndroidResFolder, template: template, image: resizedBaseImage);
      }
    }
  }

  @override
  void executeConfigurationProcess() {
    generateAdaptiveIconXml();
    applyIconParametersToManifest();
    addBackgroundColor(backgroundColor!);
  }

  void applyIconParametersToManifest() {
    final androidManifestFile = File(kAndroidManifestFile);
    if (androidManifestFile.existsSync()) {
      final androidManifestXMLDocument = XmlDocument.parse(androidManifestFile.readAsStringSync());
      final applicationElement = androidManifestXMLDocument.getElement('manifest')?..getElement('application');

      if (applicationElement == null) {
        throw CliException('$platform application element was not found. Exit.');
      }

      applicationElement.attributes
        ..removeWhere((element) => element.name.toString() == 'android:icon' || element.name.toString() == 'android:roundIcon')
        ..add(XmlAttribute(XmlName('android:icon'), '@mipmap/ic_launcher'))
        ..add(XmlAttribute(XmlName('android:roundIcon'), '@mipmap/ic_launcher_round'));

      androidManifestFile.writeAsStringSync(androidManifestXMLDocument.toXmlString(pretty: true, indent: '   '));
    } else {
      throw CliException('AndroidManifest.xml was not found. Exit.');
    }
  }

  void generateAdaptiveIconXml() {
    logger('Creating adaptive icon config');
    final launcherFile = File(kAndroidLauncher);

    if (launcherFile.existsSync()) {
      launcherFile.delete(recursive: true);
    }

    launcherFile.createSync(recursive: true);

    logger('Adding background color');
    final launcherFileBuilder = XmlBuilder();

    launcherFileBuilder
      ..processing('xml', 'version="1.0" encoding="utf-8"')
      ..element('adaptive-icon')
      ..attribute('xmlns:android', 'http://schemas.android.com/apk/res/android');
    final launcherFileDocument = launcherFileBuilder.buildDocument();

    final adaptiveIconElement = launcherFileDocument.getElement('adaptive-icon');
    final List<XmlNode> adaptiveIconElementChildren = adaptiveIconElement!.children;

    final backgroundItemBuilder = XmlBuilder();
    backgroundItemBuilder.element('background', nest: () {
      backgroundItemBuilder.attribute('android:drawable', '@colors/launcherBackground');
    });

    final foregroundItemBuilder = XmlBuilder();
    foregroundItemBuilder.element('foreground', nest: () {
      foregroundItemBuilder.attribute('android:drawable', '@mipmap/ic_launcher_foreground');
    });

    adaptiveIconElementChildren
      ..add(backgroundItemBuilder.buildFragment())
      ..add(foregroundItemBuilder.buildFragment());

    launcherFile.writeAsStringSync(launcherFileDocument.toXmlString(pretty: true, indent: '   '));

    logger('Creating adaptive round icon config');
    launcherFile.copySync(kAndroidLauncherRound);
  }

  void addBackgroundColor(String backgroundColor) {
    final colorsFile = File(kAndroidColorsFile);
    if (colorsFile.existsSync()) {
      logger('colors.xml existing already, add launcher background color');
      final colorsDocument = XmlDocument.parse(colorsFile.readAsStringSync());
      final resources = colorsDocument.getElement('resources')?.name;

      try {
        final launcherBackground = resources?.parent?.children
            .firstWhere((element) => (element.attributes.any((attribute) => attribute.name.toString() == 'launcherBackground')));

        launcherBackground?.innerText = backgroundColor;
      } on StateError {
        logger('launcherBackground was not found in colors.xml. Adding lancherBackground color.');

        resources?.parent?.children
            .add(XmlElement(XmlName('color'), [XmlAttribute(XmlName('name'), 'launcherBackground')], [XmlText(backgroundColor)]));

        colorsFile.writeAsStringSync(colorsDocument.toXmlString(pretty: true, indent: '    '));
      }
    } else {
      logger("colors.xml doesn't exist, create file and add launcher background color");
      colorsFile.createSync(recursive: true);

      final colorsFileBuilder = XmlBuilder()
        ..processing('xml', 'version="1.0" encoding="utf-8"')
        ..element('resources');

      final colorsFileDocument = colorsFileBuilder.buildDocument();

      final colorsFileElement = colorsFileDocument.getElement('adaptive-icon');

      final List<XmlNode> colorsFileElementChildren = colorsFileElement!.children;

      final backgroundItemBuilder = XmlBuilder();
      backgroundItemBuilder.element('color', nest: () {
        backgroundItemBuilder
          ..attribute('name', 'launcherBackground')
          ..text(backgroundColor);
      });

      colorsFileElementChildren.add(backgroundItemBuilder.buildFragment());
      colorsFile.writeAsStringSync(colorsFileDocument.toXmlString(pretty: true, indent: '   '));
    }
  }
}
