import 'dart:io';

import 'package:image/image.dart';
import 'package:xml/xml.dart';

import '../../../core/models/icon_template_model.dart';
import '../../../core/logger.dart';

import 'android_version.dart';
import '../../../utils/app_image_utils.dart';
import '../base_splash_controller.dart';
import '../../../core/constants.dart';

class AndroidSplashController extends BaseSplashController<AndroidIconTemplateModel> {
  AndroidSplashController({required String backgroundColor}) : super(backgroundColor);

  @override
  String get platform => kAndroidPlatform;

  @override
  List<AndroidIconTemplateModel> get splashIconList => AndroidIconTemplateModel.generateSplashIconTemplateModelList(<AndroidIconTemplateModel>[
        AndroidIconTemplateModel(path: 'mipmap-mdpi', dimens: 1.0),
        AndroidIconTemplateModel(path: 'mipmap-hdpi', dimens: 1.5),
        AndroidIconTemplateModel(path: 'mipmap-xhdpi', dimens: 2.0),
        AndroidIconTemplateModel(path: 'mipmap-xxhdpi', dimens: 3.0),
        AndroidIconTemplateModel(path: 'mipmap-xxxhdpi', dimens: 4.0),
      ]);

  @override
  void applySplashBackground() {
    _createBackgroundColor();
    _createLaunchBackground();
  }

  void _createLaunchBackground() {
    final launchBackgroundV21File = File(kAndroidV21LaunchBackgroundFile);
    if (launchBackgroundV21File.existsSync()) {
      log('Removing drawable-v21 folder');
      launchBackgroundV21File.delete();
    }

    log('Creating $kAndroidLaunchBackgroundFile with splash image path');
    final launchBackgroundFile = File(kAndroidLaunchBackgroundFile);
    launchBackgroundFile.createSync(recursive: true);

    final launchBackgroundDocumentBuilder = XmlBuilder();

    launchBackgroundDocumentBuilder
      ..processing('xml', 'version="1.0" encoding="utf-8"')
      ..element('layer-list', nest: () {
        launchBackgroundDocumentBuilder
          ..attribute('xmlns:android', 'http://schemas.android.com/apk/res/android')
          ..element('item', nest: () {
            launchBackgroundDocumentBuilder.attribute('android:drawable', '@colors/backgroundColor');
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
          ..attribute('android:src', '@mipmap/ic_splash');
      });
    });
    items.add(splashItemBuilder.buildFragment());

    launchBackgroundFile.writeAsStringSync(launchBackgroundDocument.toXmlString(pretty: true, indent: '    '));
  }

  void _createBackgroundColor() {
    log('Creating colors.xml');
    final launchColorsFile = File(kAndroidColorsFile);

    launchColorsFile.createSync(recursive: true);

    log('Adding background color');

    final launchColorDocumentBuilder = XmlBuilder();

    launchColorDocumentBuilder
      ..processing('xml', 'version="1.0" encoding="utf-8"')
      ..element('resources');
    final launchColorDocument = launchColorDocumentBuilder.buildDocument();

    final resources = launchColorDocument.getElement('resources');
    final List<XmlNode> items = resources!.children;

    final colorItemBuilder = XmlBuilder();
    colorItemBuilder.element('color', nest: () {
      colorItemBuilder.attribute('name', 'backgroundColor');
      colorItemBuilder.text(backgroundColor);
    });

    items.add(colorItemBuilder.buildFragment());

    launchColorsFile.writeAsStringSync(launchColorDocument.toXmlString(pretty: true, indent: '   '));

    _applyStylesXml(androidVersion: AndroidVersion.v30_and_lower, fullScreen: true, file: kAndroidStylesFile);
    _applyStylesXml(androidVersion: AndroidVersion.v31, fullScreen: true, file: kAndroidV31StylesFile);
  }

  @override
  void generateSplashLogo() {
    log('Generating splash images');

    final image = decodeImage(File(sourceImagePath).readAsBytesSync());
    if (image == null) {
      Logger.error(message: 'The file $sourceImagePath could not be read.');
      exit(1);
    }

    for (var template in splashIconList) {
      AppImageUtils.saveImage(resFolder: kAndroidResFolder, template: template, image: image);
    }
  }

  void _applyStylesXml({required AndroidVersion androidVersion, required bool fullScreen, required String file}) {
    final stylesFile = File(file);

    if (stylesFile.existsSync()) {
      stylesFile.deleteSync();
    }

    log('Creating ${androidVersion.name} styles.xml file and adding it to your Android '
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
                ..text(name == 'LaunchTheme' ? '@drawable/launch_background' : '@colors/backgroundColor');
              break;
            case AndroidVersion.v31:
              launchThemeBuilder
                ..attribute('name', 'android:windowSplashScreenBackground')
                ..text(name == 'LaunchTheme' ? '@drawable/launch_background' : '@colors/backgroundColor');
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
