import 'dart:io';

import 'package:image/image.dart';
import '../core/models/icon_template_model.dart';

class AppImageUtils {
  static void saveImage({required String resFolder, required IconTemplateModel template, required Image image}) {
    var resizedBaseImageByDimension = copyResize(
      image,
      width: image.width * template.size ~/ 4,
      height: image.height * template.size ~/ 4,
      interpolation: Interpolation.average,
    );

    var androidSplash = File(resFolder + template.path);
    androidSplash
      ..createSync(recursive: true)
      ..writeAsBytesSync(encodePng(resizedBaseImageByDimension));
  }
}
