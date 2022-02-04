import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:ricky_cli/core/logger.dart';
import '../../core/constants.dart';
import '../../core/base_controller.dart';
import '../../core/models/icon_template_model.dart';

abstract class BaseSplashController<T extends IconTemplateModel> extends BaseController<T> {
  @protected
  Image customSourceImage;

  @protected
  String? backgroundColor;

  BaseSplashController({this.backgroundColor, required this.customSourceImage});

  BaseSplashController.custom({required this.backgroundColor, required Image customSourceImage, errorHandler, rootPath})
      : customSourceImage = customSourceImage,
        super.custom(errorHandler: errorHandler, rootPath: rootPath);

  @protected
  List<T> get splashIconList;

  @protected
  bool get hasDarkMode => false;

  @protected
  void generateSplashLogo();

  @protected
  void applySplashBackground();

  @override
  Future<bool> execute() {
    try {
      applySplashBackground();
      generateSplashLogo();

      return Future.value(true);
    } on Exception catch (message, _) {
      Logger.error(message: message);
    }
    return Future.value(false);
  }
}
