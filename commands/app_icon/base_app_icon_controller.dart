import 'package:image/image.dart';
import 'package:meta/meta.dart';
import '../../core/models/icon_template_model.dart';
import '../../core/base_controller.dart';
import '../../core/constants.dart';

abstract class BaseAppIconController<T extends IconTemplateModel> extends BaseController<T> {

  @protected
  String? backgroundColor;

  BaseAppIconController({this.backgroundColor});

  @protected
  List<T> get appIconList;

  @override
  String get sourceImagePath => kSourceAppIconImagePath;

  @protected
  void generateAppIcon();

  @protected
  void executeConfigurationProcess();

  @override
  Future<void> execute() {
    generateAppIcon();
    executeConfigurationProcess();

    return Future.value(null);
  }
}
