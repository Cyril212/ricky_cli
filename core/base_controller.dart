import 'package:meta/meta.dart';
import '../core/logger.dart';

abstract class BaseController<T> {
  @protected
  String get platform;

  @protected
  void log(String message) => Logger.classic(message: '🔨[$platform] $message');

  @protected
  Future<void> execute();
}
