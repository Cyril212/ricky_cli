import 'package:meta/meta.dart';

abstract class BaseController<T> {
  @protected
  String get platform;

  @protected
  void log(String message) => print('🔨[$platform] $message');

  @protected
  Future<void> execute();
}
