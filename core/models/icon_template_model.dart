/// Splash Icon template

/// [name] might be directory name or file name

enum AndroidIconTemplateModelType { ic_launcher, ic_launcher_foreground, ic_launcher_round }

class AndroidIconTemplateModel extends IconTemplateModel {
  final AndroidIconTemplateModelType _type;

  AndroidIconTemplateModel({required path, required size, AndroidIconTemplateModelType? type})
      : _type = type ?? AndroidIconTemplateModelType.ic_launcher,
        super(path: path, size: size);

  AndroidIconTemplateModelType get type => _type;

  static List<AndroidIconTemplateModel> generateAppIconTemplateModelListByIconTypeList(List<IconTemplateModel> iconList) {
    final resultingIconList = <AndroidIconTemplateModel>[];

    iconList.forEach((icon) {
      AndroidIconTemplateModelType.values.forEach((type) {
        resultingIconList.add(AndroidIconTemplateModel(path: icon.path + '/' + type.name + '.png', size: icon.size, type: type));
      });
    });

    return resultingIconList;
  }

  static List<AndroidIconTemplateModel> generateSplashIconTemplateModelList(List<IconTemplateModel> iconList) {
    final resultingIconList = <AndroidIconTemplateModel>[];

    iconList.forEach((icon) {
      resultingIconList.add(AndroidIconTemplateModel(path: icon.path + '/' + 'ic_splash.png', size: icon.size));
    });

    return resultingIconList;
  }
}

class IOSIconTemplateModel extends IconTemplateModel {
  IOSIconTemplateModel({required path, required size}) : super(path: path, size: size);
}

class FlutterTemplateModel extends IconTemplateModel {
  FlutterTemplateModel({required path, required size}) : super(path: path, size: size);
}

abstract class IconTemplateModel {
  final String path;
  final double size;

  IconTemplateModel({required this.path, required this.size});
}
