import '../../core/base_command.dart';

class CreateCommand extends BaseCommand<CreateCommand> {

  @override
  String? get description => 'Create new Flutter project';

  @override
  Future<void> executionBlock() async {
    return null;
  }
}
