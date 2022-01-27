import 'package:ricky_cli/commands/app_icon/android/android_app_icon_controller.dart';
import 'package:ricky_cli/commands/app_icon/ios/ios_app_icon_controller.dart';
import 'package:ricky_cli/commands/splash/android/android_splash_controller.dart';
import 'package:ricky_cli/core/templates/structure_template.dart';
import 'package:ricky_cli/core/templates/template_configs/configs/template_config.dart';
import 'package:ricky_cli/core/templates/template_configs/in_memory/in_memory_config.dart';
import 'package:test/test.dart';
import 'package:collection/collection.dart';

void main() {
  group('Android app icons tests', () {
    //todo: mock AndroidManifest.xml
    // test('can execute successfully with provided background in case AndroidManifest.xml is provided', () {
    //   expectLater(AndroidAppIconController(backgroundColor: '#000000').execute(), completion(true));
    // });

    test('can execute successfully with incorrectly provided background in case AndroidManifest.xml is provided', () {
      expectLater(AndroidAppIconController(backgroundColor: '43243').execute(), completion(false));
    });

    test('can execute successfully with incorrectly provided background in case AndroidManifest.xml is not provided', () {
      expectLater(AndroidAppIconController(backgroundColor: '43243').execute(), completion(false));
    });

    test('can execute successfully with provided background in case AndroidManifest.xml is not provided', () {
      expectLater(AndroidAppIconController(backgroundColor: '#000000').execute(), completion(false));
    });
  });

  group('IOS app icons tests', () {
    //todo: mock ios folder creation
    // test('can execute successfully with provided background and ios folder exist', () {
    //   expectLater(IOSAppIconController(backgroundColor: '#000000').execute(), completion(true));
    // });

    test("can execute successfully with provided background and ios folder doesn't exist", () {
      expectLater(IOSAppIconController(backgroundColor: '#000000').execute(), completion(true));
    });
  });

  group('Android splash creation tests', () {
    test('can execute successfully with provided background', () {
      expectLater(AndroidSplashController(backgroundColor: '#000000').execute(), completion(true));
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
      final inMemoryTemplate = StructureTemplate(source: InMemoryConfig(content: kBlocInMemoryConfig));

      final structure = await inMemoryTemplate.structure;

      final expectedStructure = kBlocInMemoryConfig.map((element) => StructureElement(path: element)).toList();

      expect(const ListEquality<StructureElement>().equals(structure, expectedStructure), true);
    });

    test('can read in file structure config', () async {
      final fileTemplate = StructureTemplate(source: FileConfig(path: 'lib/core/templates/template_configs/file/bloc_config.yaml'));

      final structure = await fileTemplate.structure;

      final expectedStructure = kBlocInMemoryConfig.map((element) => StructureElement(path: element)).toList();

      expect(const ListEquality<StructureElement>().equals(structure, expectedStructure), true);
    });

    //todo: implement once [WebConfig] completed.
    // test('can read in web structure config', () async {
    //   expect(true, true);
    // });
  });
}
