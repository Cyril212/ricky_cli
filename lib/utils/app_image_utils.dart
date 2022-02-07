import 'dart:io';

import 'package:image/image.dart';
import '../core/models/icon_template_model.dart';

class AppImageUtils {
  static void saveImage({required String resFolder, required IconTemplateModel template, required Image image}) {
    var resizedBaseImage = resizeImage(
        image: image,
        width: template.dimens != null ? (image.width * template.dimens! ~/ 4) : template.size!.round(),
        height: template.dimens != null ? (image.height * template.dimens! ~/ 4) : template.size!.round());

    var directory = Directory(resFolder);
    if (!directory.existsSync()) {
      directory.createSync();
    }
    var imagePath = File(resFolder + template.path);
    imagePath
      ..createSync(recursive: true)
      ..writeAsBytesSync(encodePng(resizedBaseImage));
  }

  static Image resizeImage({required Image image, required int width, required int height}) =>
      copyResize(image, width: width, height: height, interpolation: Interpolation.average);
}
