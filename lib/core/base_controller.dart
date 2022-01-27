import 'dart:io';

import 'package:image/image.dart';
import 'package:meta/meta.dart';
import '../core/logger.dart';
import '../utils/exceptions/cli_exception.dart';

abstract class BaseController<T> {
  @protected
  String get platform;

  @protected
  void log(String message) => Logger.classic(message: '🔨[$platform] $message');

  @protected
  Image get sourceImage {
    final image = decodeImage(File(sourceImagePath).readAsBytesSync());
    if (image == null) {
      throw CliException('ic_launcher.png is not found in assets/cli/app_icon/');
    }
    return image;
  }

  @protected
  String get sourceImagePath;

  @protected
  Future<bool> execute();
}
