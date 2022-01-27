/// Splash Icon template

/// [name] might be directory name or file name

enum AndroidIconTemplateModelType { ic_launcher, ic_launcher_foreground, ic_launcher_round }

class AndroidIconTemplateModel extends IconTemplateModel {
  final AndroidIconTemplateModelType _type;

  AndroidIconTemplateModel({required path, double? size, double? dimens, AndroidIconTemplateModelType? type})
      : _type = type ?? AndroidIconTemplateModelType.ic_launcher,
        super(path: path, size: size, dimens: dimens);

  AndroidIconTemplateModelType get type => _type;

  static List<AndroidIconTemplateModel> generateAppIconTemplateModelListByIconTypeList(List<IconTemplateModel> iconList) {
    final resultingIconList = <AndroidIconTemplateModel>[];

    iconList.forEach((icon) {
      AndroidIconTemplateModelType.values.forEach((type) {
        resultingIconList.add(AndroidIconTemplateModel(path: icon.path + '/' + type.name + '.png', dimens: icon.dimens, type: type));
      });
    });

    return resultingIconList;
  }

  static List<AndroidIconTemplateModel> generateSplashIconTemplateModelList(List<IconTemplateModel> iconList) {
    final resultingIconList = <AndroidIconTemplateModel>[];

    iconList.forEach((icon) {
      resultingIconList.add(AndroidIconTemplateModel(path: icon.path + '/' + 'ic_splash.png', dimens: icon.dimens));
    });

    return resultingIconList;
  }
}

class IOSIconTemplateModel extends IconTemplateModel {
  IOSIconTemplateModel({required path, double? size, double? dimens}) : super(path: path + '.png', size: size, dimens: dimens);
}

class FlutterTemplateModel extends IconTemplateModel {
  FlutterTemplateModel({required path, size, dimens}) : super(path: path, size: size, dimens: dimens);
}

abstract class IconTemplateModel {
  final String path;
  final double? size;
  final double? dimens;

  const IconTemplateModel({required this.path, this.size, this.dimens})
      : assert(size == null || dimens == null, 'Cannot provide both a size and a dimens\n');
}
