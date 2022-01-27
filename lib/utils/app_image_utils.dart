import 'dart:io';

import 'package:image/image.dart';
import '../core/models/icon_template_model.dart';

class AppImageUtils {
  static void saveImage({required String resFolder, required IconTemplateModel template, required Image image}) {
    var resizedBaseImage = copyResize(image,
        width: template.dimens != null ? (image.width * template.dimens! ~/ 4) : template.size!.round(),
        height: template.dimens != null ? (image.height * template.dimens! ~/ 4) : template.size!.round(),
        interpolation: Interpolation.average);

    var imagePath = File(resFolder + template.path);
    imagePath
      ..createSync(recursive: true)
      ..writeAsBytesSync(encodePng(resizedBaseImage));
  }
}
