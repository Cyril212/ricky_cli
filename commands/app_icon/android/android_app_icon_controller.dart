import 'dart:io';

import 'package:image/image.dart';
import 'package:xml/xml.dart';
import '../../../core/models/icon_template_model.dart';
import '../../../utils/app_image_utils.dart';
import '../../../core/constants.dart';
import '../../../utils/exceptions/cli_exception.dart';
import '../base_app_icon_controller.dart';

class AndroidAppIconController extends BaseAppIconController<AndroidIconTemplateModel> {
  AndroidAppIconController({required Image image, required String backgroundColor}) : super(image, backgroundColor: backgroundColor);

  @override
  String get platform => kAndroidPlatform;

  @override
  List<AndroidIconTemplateModel> get appIconList =>
      AndroidIconTemplateModel.generateAppIconTemplateModelListByIconTypeList(<AndroidIconTemplateModel>[
        AndroidIconTemplateModel(path: 'mipmap-ldpi', size: 0.75),
        AndroidIconTemplateModel(path: 'mipmap-mdpi', size: 1),
        AndroidIconTemplateModel(path: 'mipmap-hdpi', size: 1.5),
        AndroidIconTemplateModel(path: 'mipmap-xhdpi', size: 2),
        AndroidIconTemplateModel(path: 'mipmap-xxhdpi', size: 3),
        AndroidIconTemplateModel(path: 'mipmap-xxxhdpi', size: 4),
      ]);

  @override
  void generateAppIcon() {
    log('Generating icons');

    final resizedBaseImage = copyResize(
      image,
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
  }

  void generateAdaptiveIconXml() {
    log('Creating adaptive icon config');
    final launcherFile = File(kAndroidLauncher);

    if (launcherFile.existsSync()) {
      launcherFile.delete(recursive: true);
    }

    launcherFile.createSync(recursive: true);

    log('Adding background color');
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

    log('Creating adaptive round icon config');
    launcherFile.copySync(kAndroidLauncherRound);
  }

  void addBackgroundColor(String backgroundColor) {
    final colorsFile = File(kAndroidColorsFile);
    if (colorsFile.existsSync()) {
      log('colors.xml existing already, add launcher background color');
      final colorsDocument = XmlDocument.parse(colorsFile.readAsStringSync());
      final resources = colorsDocument.getElement('resources')?.name;

      try {
        final launcherBackground = resources?.parent?.children
            .firstWhere((element) => (element.attributes.any((attribute) => attribute.name.toString() == 'launcherBackground')));

        launcherBackground?.innerText = backgroundColor;
      } on StateError {
        log('launcherBackground was not found in colors.xml. Adding lancherBackground color.');

        resources?.parent?.children
            .add(XmlElement(XmlName('color'), [XmlAttribute(XmlName('name'), 'launcherBackground')], [XmlText(backgroundColor)]));

        colorsFile.writeAsStringSync(colorsDocument.toXmlString(pretty: true, indent: '    '));
      }
    } else {
      log("colors.xml doesn't exist, create file and add launcher background color");
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
