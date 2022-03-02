import 'package:meta/meta.dart';
import '../core/logger.dart';

typedef ErrorHandler = Function(Exception e);

abstract class BaseController<T> {
  @protected
  String? get platform => null;

  @protected
  ErrorHandler? errorHandler;

  @protected
  final String rootPath;

  BaseController() : rootPath = '';

  BaseController.custom({this.errorHandler, rootPath}) : rootPath = rootPath ?? '';

  @protected
  void logger(String message) => Logger.classic(message: '🔨[$platform] $message');

  @protected
  Future<bool> execute();

  @protected
  String getFullPath(String filePath) {
    return rootPath.isEmpty ? filePath : '$rootPath/$filePath';
  }
}
