import 'dart:io';

import 'package:image/image.dart';
import 'package:ricky_cli/commands/app_icon/android/android_app_icon_controller.dart';
import 'package:ricky_cli/commands/app_icon/ios/ios_app_icon_controller.dart';
import 'package:ricky_cli/commands/splash/android/android_splash_controller.dart';
import 'package:ricky_cli/core/constants.dart';
import 'package:ricky_cli/core/template/template.dart';
import 'package:ricky_cli/core/template/config/template_config.dart';
import 'package:ricky_cli/core/template/in_memory/in_memory_config_specification.dart';
import 'package:ricky_cli/core/template/template_generator.dart';
import 'package:test/test.dart';
import 'package:collection/collection.dart';

void main() {
  group('Android app icons tests', () {
    //todo: mock AndroidManifest.xml
    // test('can execute successfully with provided background in case AndroidManifest.xml is provided', () {
    //   expectLater(AndroidAppIconController(backgroundColor: '#000000').execute(), completion(true));
    // });
    final sourceImage = decodeImage(File(kSourceAppIconImagePath).readAsBytesSync());

    test('can execute successfully with incorrectly provided background in case AndroidManifest.xml is provided', () {
      expectLater(AndroidAppIconController(backgroundColor: '43243', customSourceImage: sourceImage!).execute(), completion(false));
    });

    test('can execute successfully with incorrectly provided background in case AndroidManifest.xml is not provided', () {
      expectLater(AndroidAppIconController(backgroundColor: '43243', customSourceImage: sourceImage!).execute(), completion(false));
    });

    test('can execute successfully with provided background in case AndroidManifest.xml is not provided', () {
      expectLater(AndroidAppIconController(backgroundColor: '#000000', customSourceImage: sourceImage!).execute(), completion(false));
    });
  });

  group('IOS app icons tests', () {
    //todo: mock ios folder creation
    // test('can execute successfully with provided background and ios folder exist', () {
    //   expectLater(IOSAppIconController(backgroundColor: '#000000').execute(), completion(true));
    // });

    final sourceImage = decodeImage(File(kSourceAppIconImagePath).readAsBytesSync());

    test("can execute successfully with provided background and ios folder doesn't exist", () {
      expectLater(IOSAppIconController(backgroundColor: '#000000', customSourceImage: sourceImage!).execute(), completion(true));
    });
  });

  group('Android splash creation tests', () {
    final sourceImage = decodeImage(File(kSourceSplashImagePath).readAsBytesSync());

    test('can execute successfully with provided background', () {
      expectLater(AndroidSplashController(backgroundColor: '#000000',customSourceImage: sourceImage!).execute(), completion(true));
    });
  });

  group('IOS splash creation tests', () {
    //todo: mock ios folder creation
    // test('can execute successfully with provided background and ios folder exist', () {
    //   expectLater(IOSSplashController(backgroundColor: '#000000').execute(), completion(true));
    // });
  });

  group('Structure templates tests', () {
    test('can read in memory structure config', () async {
      final inMemoryTemplate = Template(source: InMemoryConfig(content: kBlocInMemoryConfig));

      final structure = await inMemoryTemplate.structure;

      final expectedStructure = kBlocInMemoryConfig.map((element) => TemplateElement(path: element.path, tag: '')).toList();

      expect(const ListEquality<TemplateElement>().equals(structure, expectedStructure), true);
    });

    test('can read in file structure config', () async {
      final fileTemplate = Template(source: FileConfig(path: 'lib/core/template/file/sample_config.yaml'));

      final structure = await fileTemplate.structure;

      final expectedStructure = kBlocInMemoryConfig;

      expect(const ListEquality<TemplateElement>().equals(structure, expectedStructure), true);
    });

    //todo: implement once [WebConfig] completed.
    // test('can read in web structure config', () async {
    //   expect(true, true);
    // });
  });

  group('Test template generator', () {
    final fileTemplate = Template(source: FileConfig(path: 'lib/core/template/file/sample_config.yaml'));

    test(('generate template from FileConfig'), () {
      TemplateGenerator(template: fileTemplate).generateStructure();
    });
  });

  tearDown(() {
    if (Directory('android').existsSync()) {
      Directory('android').deleteSync(recursive: true);
    }

    if (Directory('ios').existsSync()) {
      Directory('ios').deleteSync(recursive: true);
    }
  });
}
