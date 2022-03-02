import 'package:ricky_cli/core/base_controller.dart';
import 'package:ricky_cli/core/template/structure_template.dart';
import 'package:ricky_cli/core/template/template_generator.dart';
import 'package:process_run/shell.dart';

import '../../utils/general_utils.dart';

class CreateController extends BaseController {
  final Map parameters;
  final Platform chosenPlatform;

  CreateController({required this.parameters, required this.chosenPlatform});

  @override
  Future<bool> execute() async {
    late String platformArg;
    switch (chosenPlatform) {
      case Platform.android:
        platformArg = '--platforms android';
        break;
      case Platform.ios:
        platformArg = '--platforms ios';
        break;
      case Platform.both:
        platformArg = '--platforms android,ios';
        break;
    }

    await Shell()
        .run(
            "flutter create --org ${parameters['appPackage']} ${parameters['appName']} -t app $platformArg --description ${parameters['appDescription']}")
        .then((value) => Shell().run('flutter pub add colorize'));

    final blocProjectTemplate = SampleTemplate.fromMemory(
        appName: parameters['appName'], primaryColor: parameters['primaryColor'], secondaryColor: parameters['secondaryColor']);

    TemplateGenerator(template: blocProjectTemplate).generateStructure();

    return Future.value(true);
  }
}
