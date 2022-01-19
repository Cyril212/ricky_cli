import 'package:meta/meta.dart';

@immutable
abstract class BaseCommand<T> {
  @protected
  String get startUpLog => '⚙️ ===== $tag executed ===== ⚙️';

  @protected
  String get complitionLog => '🏁 ===== $tag completed successfully ===== 🏁';

  @protected
  String get tag => T.toString();

  @protected
  String? get description;

  @protected
  Future<void> executionBlock();

  Future<void> execute() async {
    print(startUpLog);
    await executionBlock();
    print(complitionLog);
  }
}
