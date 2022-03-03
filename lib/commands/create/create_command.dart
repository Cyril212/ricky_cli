import 'package:ricky_cli/commands/create/create_controller.dart';
import 'package:ricky_cli/core/dialog_interactor.dart';

import '../../core/base_command.dart';

class CreateCommand extends BaseCommand<CreateCommand> {
  @override
  String? get description => 'Create new Flutter project';

  @override
  Future<void> executionBlock() async {
    DialogInteractor.instance.platformAwareInteraction(
        questions: [
          ['Type in application name', 'appName'],
          ['Type in package name (com.example)', 'appPackage'],
          ['Type in description', 'appDescription'],
        ],
        onAnswer: (answer) {},
        onPlatformAnswer: (platform, answer) {
          CreateController(parameters: answer, chosenPlatform: platform).execute();
        });
  }
}
