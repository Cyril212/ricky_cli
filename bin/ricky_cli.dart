import '../core/cli_communication_client.dart';
import '../utils/exceptions/cli_exception.dart';

void main(List<String> arguments) {
  try {
    CLICommunicationClient().executeCommand(arguments);
  } on Exception catch (exception, _) {
    if (exception is CliException) {
      print(exception.message);
    } else {
      print(exception.toString());
    }
  }
}
