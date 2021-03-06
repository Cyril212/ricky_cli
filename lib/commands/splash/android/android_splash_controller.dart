import 'dart:io';

import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:ricky_cli/core/base_controller.dart';
import 'package:xml/xml.dart';

import '../../../core/models/icon_template_model.dart';

import 'android_version.dart';
import '../../../utils/app_image_utils.dart';
import '../base_splash_controller.dart';
import '../../../core/constants.dart';

class AndroidSplashController extends BaseSplashController<AndroidIconTemplateModel> {
  AndroidSplashController({required String backgroundColor, required Image customSourceImage})
      : super(backgroundColor: backgroundColor, customSourceImage: customSourceImage);

  @experimental
  AndroidSplashController.custom({required String backgroundColor, required Image customSourceImage, ErrorHandler? errorHandler, String? rootPath})
      : super.custom(backgroundColor: backgroundColor, customSourceImage: customSourceImage, errorHandler: errorHandler, rootPath: rootPath);

  @override
  String get platform => kAndroidPlatform;

  @override
  List<AndroidIconTemplateModel> get splashIconList => AndroidIconTemplateModel.generateSplashIconTemplateModelList(<AndroidIconTemplateModel>[
    AndroidIconTemplateModel(path: 'drawable-mdpi', dimens: 1.0),
    AndroidIconTemplateModel(path: 'drawable-hdpi', dimens: 1.5),
    AndroidIconTemplateModel(path: 'drawable-xhdpi', dimens: 2.0),
    AndroidIconTemplateModel(path: 'drawable-xxhdpi', dimens: 3.0),
    AndroidIconTemplateModel(path: 'drawable-xxxhdpi', dimens: 4.0),
  ]);

  @override
  void applySplashBackground() {
    _createBackgroundColor();
    _createLaunchBackground();
  }

  void _createLaunchBackground() {
    final launchBackgroundV21File = File(getFullPath(kAndroidV21LaunchBackgroundFile));
    if (launchBackgroundV21File.existsSync()) {
      logger('Removing drawable-v21 folder');
      launchBackgroundV21File.delete();
    }

    logger('Creating $kAndroidLaunchBackgroundFile with splash image path');
    final launchBackgroundFile = File(getFullPath(kAndroidLaunchBackgroundFile));
    launchBackgroundFile.createSync(recursive: true);

    final launchBackgroundDocumentBuilder = XmlBuilder();

    launchBackgroundDocumentBuilder
      ..processing('xml', 'version="1.0" encoding="utf-8"')
      ..element('layer-list', nest: () {
        launchBackgroundDocumentBuilder
          ..attribute('xmlns:android', 'http://schemas.android.com/apk/res/android')
          ..element('item', nest: () {
            launchBackgroundDocumentBuilder.attribute('android:drawable', '@color/backgroundColor');
          });
      });

    final launchBackgroundDocument = launchBackgroundDocumentBuilder.buildDocument();

    final layerList = launchBackgroundDocument.getElement('layer-list');
    final List<XmlNode> items = layerList!.children;

    final splashItemBuilder = XmlBuilder();

    splashItemBuilder.element('item', nest: () {
      splashItemBuilder.element('bitmap', nest: () {
        splashItemBuilder
          ..attribute('android:gravity', 'center')
          ..attribute('android:src', '@drawable/ic_splash');
      });
    });
    items.add(splashItemBuilder.buildFragment());

    launchBackgroundFile.writeAsStringSync(launchBackgroundDocument.toXmlString(pretty: true, indent: '    '));
  }

  void _createBackgroundColor() {
    logger('Creating colors.xml');

    final launchColorsFile = File(getFullPath(kAndroidColorsFile));
    if (launchColorsFile.existsSync()) {
      logger('colors.xml existing already, add launcher background color');
      final colorsDocument = XmlDocument.parse(launchColorsFile.readAsStringSync());
      final resources = colorsDocument.getElement('resources')?.name;

      try {
        final launcherBackground =
        resources?.parent?.children.firstWhere((element) => (element.attributes.any((attribute) => attribute.value == 'backgroundColor')));

        launcherBackground?.innerText = backgroundColor!;
      } on StateError {
        logger('launcherBackground was not found in colors.xml. Adding lancherBackground color.');

        resources?.parent?.children
            .add(XmlElement(XmlName('color'), [XmlAttribute(XmlName('name'), 'backgroundColor')], [XmlText(backgroundColor!)]));

        launchColorsFile.writeAsStringSync(colorsDocument.toXmlString(pretty: true, indent: '    '));
      }
    } else {
      logger("colors.xml doesn't exist, create file and add background color");

      launchColorsFile.createSync(recursive: true);

      logger("colors.xml doesn't exist, create file and add launcher background color");
      launchColorsFile.createSync(recursive: true);

      final colorsFileBuilder = XmlBuilder()
        ..processing('xml', 'version="1.0" encoding="utf-8"')
        ..element('resources');

      final colorsFileDocument = colorsFileBuilder.buildDocument();

      final colorsFileElement = colorsFileDocument.getElement('resources');

      final List<XmlNode> colorsFileElementChildren = colorsFileElement!.children;

      final backgroundItemBuilder = XmlBuilder();
      backgroundItemBuilder.element('color', nest: () {
        backgroundItemBuilder
          ..attribute('name', 'backgroundColor')
          ..text(backgroundColor!);
      });

      colorsFileElementChildren.add(backgroundItemBuilder.buildFragment());
      launchColorsFile.writeAsStringSync(colorsFileDocument.toXmlString(pretty: true, indent: '   '));
    }

    _applyStylesXml(androidVersion: AndroidVersion.v30_and_lower, fullScreen: true, file: getFullPath(kAndroidStylesFile));
    _applyStylesXml(androidVersion: AndroidVersion.v31, fullScreen: true, file: getFullPath(kAndroidV31StylesFile));
  }

  @override
  void generateSplashLogo() {
    logger('Generating splash images');

    for (var template in splashIconList) {
      AppImageUtils.saveImage(resFolder: getFullPath(kAndroidResFolder), template: template, image: customSourceImage);
    }
  }

  void _applyStylesXml({required AndroidVersion androidVersion, required bool fullScreen, required String file}) {
    final stylesFile = File(file);

    if (stylesFile.existsSync()) {
      stylesFile.deleteSync();
    }

    logger('Creating ${androidVersion.name} styles.xml file and adding it to your Android '
        'project');

    stylesFile.createSync(recursive: true);

    final androidStyleBuilder = XmlBuilder();
    androidStyleBuilder
      ..processing('xml', 'version="1.0" encoding="utf-8"')
      ..element('resources');

    final launchColorDocument = androidStyleBuilder.buildDocument();

    final resources = launchColorDocument.getElement('resources');
    final List<XmlNode> resourceChildren = resources!.children;

    resourceChildren
      ..add(_createAndroidStyleFragment(androidVersion: androidVersion))
      ..add(_createAndroidStyleFragment(androidVersion: androidVersion, name: 'NormalTheme'));

    stylesFile.writeAsStringSync(launchColorDocument.toXmlString(pretty: true, indent: '   '));
  }

  XmlDocumentFragment _createAndroidStyleFragment({required AndroidVersion androidVersion, bool fullScreen = true, String name = 'LaunchTheme'}) {
    final launchThemeBuilder = XmlBuilder();
    launchThemeBuilder.element('style', nest: () {
      launchThemeBuilder
        ..attribute('name', name)
        ..attribute('parent', '@android:style/Theme.Light.NoTitleBar')
        ..element('item', nest: () {
          switch (androidVersion) {
            case AndroidVersion.v30_and_lower:
              launchThemeBuilder
                ..attribute('name', 'android:windowBackground')
                ..text(name == 'LaunchTheme' ? '@drawable/launch_background' : '@color/backgroundColor');
              break;
            case AndroidVersion.v31:
              launchThemeBuilder
                ..attribute('name', 'android:windowSplashScreenBackground')
                ..text(name == 'LaunchTheme' ? '@drawable/launch_background' : '@color/backgroundColor');
              break;
          }
        });
      if (name == 'LaunchTheme') {
        launchThemeBuilder.element('item', nest: () {
          launchThemeBuilder
            ..attribute('name', 'android:windowFullscreen')
            ..text(fullScreen.toString());
        });
      }
    });

    return launchThemeBuilder.buildFragment();
  }
}
