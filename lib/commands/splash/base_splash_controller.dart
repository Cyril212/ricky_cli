import 'package:meta/meta.dart';
import 'package:ricky_cli/core/logger.dart';
import '../../core/constants.dart';
import '../../core/base_controller.dart';
import '../../core/models/icon_template_model.dart';

abstract class BaseSplashController<T extends IconTemplateModel> extends BaseController<T> {
  @protected
  String backgroundColor;

  BaseSplashController(this.backgroundColor);

  @protected
  List<T> get splashIconList;

  @protected
  bool get hasDarkMode => false;

  @override
  String get sourceImagePath => kSourceSplashImagePath;

  @protected
  String? get darkSourceImagePath => hasDarkMode ? kDarkSourceImagePath : null;

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
