import 'dart:io';

import 'package:image/image.dart';
import 'package:meta/meta.dart';
import '../core/logger.dart';
import '../utils/exceptions/cli_exception.dart';

typedef ErrorHandler = Function(Exception e);

abstract class BaseController<T> {
  @protected
  String get platform;

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
    return '$rootPath$filePath';
  }
}
