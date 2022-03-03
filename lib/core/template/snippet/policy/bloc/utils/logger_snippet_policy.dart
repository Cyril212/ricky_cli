import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:ricky_cli/core/logger.dart';
import 'package:ricky_cli/core/template/snippet/policy/base_snippet_policy.dart';

class LoggerSnippetPolicy extends BaseSnippetPolicy {
  @override
  String get importSection {
    final libraryBuilder = Library((builder) {
      builder.directives.add(Directive.import('package:colorize/colorize.dart'));
    });

    final emitter = DartEmitter();
    return DartFormatter().format('${libraryBuilder.accept(emitter)}');
  }

  @override
  String get outerClassSection {
    final enumBuilder = Enum((builder) => builder
      ..name = 'LogType'
      ..values.addAll([
        EnumValue((b) => b..name = 'classic'),
        EnumValue((b) => b..name = 'debug'),
        EnumValue((b) => b..name = 'warning'),
        EnumValue((b) => b..name = 'error'),
      ]));

    final emitter = DartEmitter();
    return DartFormatter().format('${enumBuilder.accept(emitter)}');
  }

  @override
  String get tag => 'utils_logger';

  @override
  String get classNameSection {
    final classBuilder = Class((builder) => builder
      ..name = 'Logger'
      ..methods.add(_buildLoggerFunction('classic', LogType.classic.toString()))
      ..methods.add(_buildLoggerFunction('debug', LogType.debug.toString()))
      ..methods.add(_buildLoggerFunction('warning', LogType.warning.toString()))
      ..methods.add(_buildLoggerFunction('error', LogType.error.toString()))
      ..methods.add(_customLoggerFunction())
      ..methods.add(_baseLoggerFunction()));

    return DartFormatter().format('${classBuilder.accept(DartEmitter())}');
  }

  Method _buildLoggerFunction(String name, String type) {
    final builder = Method.returnsVoid((builder) {
      builder
        ..static = true
        ..name = name
        ..requiredParameters.add((Parameter((_) => _..name = 'message')))
        ..body = Code('_log(message, $type);');
    });

    return builder;
  }

  Method _customLoggerFunction() {
    return Method.returnsVoid((builder) {
      builder
        ..static = true
        ..name = 'custom'
        ..requiredParameters.add((Parameter((_) => _
          ..type = Reference('String')
          ..name = 'message')))
        ..requiredParameters.add((Parameter((_) => _
          ..type = Reference('Styles')
          ..name = 'style')))
        ..body = Code('print(Colorize().apply(style, message));');
    });
  }

  Method _baseLoggerFunction() {
    return Method.returnsVoid((builder) {
      builder
        ..static = true
        ..name = '_log'
        ..requiredParameters.add(Parameter((_) => _..name = 'message'))
        ..requiredParameters.add(Parameter((_) => _
          ..name = 'type'
          ..type = Reference('LogType')))
        ..body = Block.of([
          const Code('switch(type)'),
          const Code('{'),
          const Code('case LogType.classic'),
          const Code(':'),
          const Code("print(Colorize('\$message').default_slyle());"),
          const Code('break;'),
          const Code('case LogType.debug'),
          const Code(':'),
          const Code("print(Colorize('ℹ️ [Info] \$message').blue());"),
          const Code('break;'),
          const Code('case LogType.warning'),
          const Code(':'),
          const Code("print(Colorize('⚠️️ [Warning] \$message').blue());"),
          const Code('break;'),
          const Code('case LogType.error'),
          const Code(':'),
          const Code("print(Colorize('⛔️ [Error] \$message').red());"),
          const Code('break;'),
          const Code('}'),
        ]);
    });
  }
}
