import 'dart:io';
import 'dart:math';
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
  final double _resizePercentage;

  AndroidAppIconController({required String backgroundColor, required Image customSourceImage})
      : _resizePercentage = 1,
        super(backgroundColor: backgroundColor, customSourceImage: customSourceImage);

  @experimental
  AndroidAppIconController.custom(
      {required String backgroundColor, required Image customSourceImage, required resizePercentage, ErrorHandler? errorHandler, String? rootPath})
      : _resizePercentage = resizePercentage,
        super.custom(backgroundColor: backgroundColor, customSourceImage: customSourceImage, errorHandler: errorHandler, rootPath: rootPath);

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
  void generateAppIcon() async {
    logger('Generating icons');

    if (customSourceImage.height != 512 && customSourceImage.width != 512) {
      ///Resize source image to xxxhdpi
      customSourceImage = copyResize(
        customSourceImage,
        width: 512,
        height: 512,
        interpolation: Interpolation.average,
      );
    }

    //foreground
    // Create alpha layer for xxxhdpi foreground icon (the biggest dimension in android)
    final baseAlphaChannelLayerImage = Image(432, 432);

    //Resized source image by resize percentage
    final resizedBaseForegroundImage = copyResize(
      customSourceImage,
      width: (288 * _resizePercentage).toInt(),
      height: (288 * _resizePercentage).toInt(),
      interpolation: Interpolation.average,
    );

    // Define paddings for [resizedBaseForegroundImage]
    final paddingX = (432 - resizedBaseForegroundImage.width) ~/ 2;
    final paddingY = (432 - resizedBaseForegroundImage.height) ~/ 2;

    final foregroundImage = drawImage(baseAlphaChannelLayerImage, resizedBaseForegroundImage, dstX: paddingX, dstY: paddingY);
    //change padding depending on resizedBaseForegroundImage size

    //legacy
    final resizedLegacyIcon = _croppedLegacyImageFromSource(foregroundImage, foregroundImage.width ~/ 2, foregroundImage.height ~/ 2, 288, 288);

    //round
    final resizedRoundIcon = _croppedRoundImageFromSource(foregroundImage);

    for (var template in appIconList) {
      if (template.type == AndroidIconTemplateModelType.ic_launcher) {
        AppImageUtils.saveImage(resFolder: getFullPath(kAndroidResFolder), template: template, image: resizedLegacyIcon);
      } else if (template.type == AndroidIconTemplateModelType.ic_launcher_round) {
        AppImageUtils.saveImage(resFolder: getFullPath(kAndroidResFolder), template: template, image: resizedRoundIcon);
      } else {
        AppImageUtils.saveImage(resFolder: getFullPath(kAndroidResFolder), template: template, image: foregroundImage);
      }
    }
  }

  Image _croppedLegacyImageFromSource(Image source, int x, int y, int width, int height) {
    final tlx = x - 144; //topLeft.x
    final tly = y - 144; //topLeft.y

    final croppedImage = copyCrop(source, tlx, tly, width, height);
    return _croppedImageWithAlpha(croppedImage, 150, 150, 20, 20);
  }

  Image _croppedRoundImageFromSource(Image source) {
    final croppedImage = copyCropCircle(source, radius: 144);
    return _croppedImageWithAlpha(croppedImage, 178, 178, 6, 6);
  }

  Image _croppedImageWithAlpha(Image source, int resizedImageWidth, int resizedImageHeight, int paddingX, int paddingY) {
    final baseAlphaChannelLayerImage = Image(192, 192);

    final resizedRoundImage = copyResize(
      source,
      width: resizedImageWidth,
      height: resizedImageHeight,
      interpolation: Interpolation.average,
    );

    final roundPaddingX = paddingX;
    final roundPaddingY = paddingY;

    return drawImage(baseAlphaChannelLayerImage, resizedRoundImage, dstX: roundPaddingX, dstY: roundPaddingY);
  }

  @override
  void executeConfigurationProcess() {
    _generateAdaptiveIconXml();
    _applyIconParametersToManifest();
    _addBackgroundColor();
  }

  void _applyIconParametersToManifest() {
    final androidManifestFile = File(getFullPath(kAndroidManifestFile));
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

  void _generateAdaptiveIconXml() {
    logger('Creating adaptive icon config');
    final launcherFile = File(getFullPath(kAndroidLauncher));

    if (launcherFile.existsSync()) {
      launcherFile.delete(recursive: true);
    }

    launcherFile.createSync(recursive: true);

    logger('Adding background color');
    final launcherFileBuilder = XmlBuilder();

    launcherFileBuilder
      ..processing('xml', 'version="1.0" encoding="utf-8"')
      ..element('adaptive-icon');
    final launcherFileDocument = launcherFileBuilder.buildDocument();

    final adaptiveIconElement = launcherFileDocument.getElement('adaptive-icon')!
      ..setAttribute('xmlns:android', 'http://schemas.android.com/apk/res/android');
    final List<XmlNode> adaptiveIconElementChildren = adaptiveIconElement.children;

    final backgroundItemBuilder = XmlBuilder();
    backgroundItemBuilder.element('background', nest: () {
      backgroundItemBuilder.attribute('android:drawable', '@color/launcherBackground');
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
    launcherFile.copySync(getFullPath(kAndroidLauncherRound));
  }

  void _addBackgroundColor() {
    final colorsFile = File(getFullPath(kAndroidColorsFile));
    if (colorsFile.existsSync()) {
      logger('colors.xml existing already, add launcher background color');
      final colorsDocument = XmlDocument.parse(colorsFile.readAsStringSync());
      final resources = colorsDocument.getElement('resources')?.name;

      try {
        final launcherBackground =
            resources?.parent?.children.firstWhere((element) => element.attributes.any((attribute) => attribute.value == 'launcherBackground'));

        launcherBackground?.innerText = backgroundColor!;
      } on StateError {
        logger('launcherBackground was not found in colors.xml. Adding lancherBackground color.');

        resources?.parent?.children
            .add(XmlElement(XmlName('color'), [XmlAttribute(XmlName('name'), 'launcherBackground')], [XmlText(backgroundColor!)]));

        colorsFile.writeAsStringSync(colorsDocument.toXmlString(pretty: true, indent: '    '));
      }
    } else {
      logger("colors.xml doesn't exist, create file and add launcher background color");
      colorsFile.createSync(recursive: true);

      final colorsFileBuilder = XmlBuilder()
        ..processing('xml', 'version="1.0" encoding="utf-8"')
        ..element('resources');

      final colorsFileDocument = colorsFileBuilder.buildDocument();

      final colorsFileElement = colorsFileDocument.getElement('resources');

      final List<XmlNode> colorsFileElementChildren = colorsFileElement!.children;

      final backgroundItemBuilder = XmlBuilder();
      backgroundItemBuilder.element('color', nest: () {
        backgroundItemBuilder
          ..attribute('name', 'launcherBackground')
          ..text(backgroundColor!);
      });

      colorsFileElementChildren.add(backgroundItemBuilder.buildFragment());
      colorsFile.writeAsStringSync(colorsFileDocument.toXmlString(pretty: true, indent: '   '));
    }
  }
}
