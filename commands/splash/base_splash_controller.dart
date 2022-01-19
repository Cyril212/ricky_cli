import 'package:meta/meta.dart';
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

  @protected
  String get sourceImagePath => kSourceImagePath;

  @protected
  String? get darkSourceImagePath => hasDarkMode ? kDarkSourceImagePath : null;

  @protected
  void generateSplashLogo();

  @protected
  void applySplashBackground();

  @override
  Future<void> execute() {
    applySplashBackground();
    generateSplashLogo();

    return Future.value(null);
  }
}
