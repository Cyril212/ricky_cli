import 'package:image/image.dart';
import 'package:meta/meta.dart';
import '../../core/models/icon_template_model.dart';
import '../../core/base_controller.dart';

abstract class BaseAppIconController<T extends IconTemplateModel> extends BaseController<T> {
  @protected
  Image image;

  @protected
  String? backgroundColor;

  BaseAppIconController(this.image, {this.backgroundColor});

  @protected
  List<T> get appIconList;

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
