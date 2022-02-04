import 'dart:io';

import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:ricky_cli/core/logger.dart';
import 'package:ricky_cli/utils/exceptions/cli_exception.dart';
import '../../core/models/icon_template_model.dart';
import '../../core/base_controller.dart';
import '../../core/constants.dart';

abstract class BaseAppIconController<T extends IconTemplateModel> extends BaseController<T> {
  @protected
  Image customSourceImage;

  @protected
  String? backgroundColor;

  BaseAppIconController({this.backgroundColor, required this.customSourceImage});

  BaseAppIconController.custom({this.backgroundColor, required Image customSourceImage, errorHandler, rootPath})
      : customSourceImage = customSourceImage,
        super.custom(errorHandler: errorHandler, rootPath: rootPath);

  @protected
  List<T> get appIconList;

  @protected
  void generateAppIcon();

  @protected
  void executeConfigurationProcess();

  @override
  Future<bool> execute() {
    try {
      generateAppIcon();
      executeConfigurationProcess();
      return Future.value(true);
    } on Exception catch (e, _) {
      if (errorHandler != null) {
        errorHandler!(e);
      }
      Logger.error(message: e.toString());
    }
    return Future.value(false);
  }
}
