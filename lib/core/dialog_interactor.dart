import 'package:cli_dialog/cli_dialog.dart';
import '../utils/general_utils.dart';

class DialogInteractor {
  DialogInteractor._();

  static final DialogInteractor _instance = DialogInteractor._();

  static DialogInteractor get instance => _instance;

  Map platformAwareInteraction({
    required List questions,
    required Function(Map answer) onAnswer,
    required Function(Platform platform, Map answer) onPlatformAnswer,
  }) {
    final dialog = CLI_Dialog(questions: [
      ['Choose platform \n 1. Android. \n 2. iOS. \n 3. Both.', 'platformPreference'],
      ...questions
    ]);

    final dialogAnswers = dialog.ask();

    onAnswer(dialogAnswers);

    final chosenPlatformPreference = Platform.values.firstWhere((platform) => platform.index == optionAnswer(dialogAnswers['platformPreference']));
    onPlatformAnswer(chosenPlatformPreference, dialogAnswers);

    return dialogAnswers;
  }
}
