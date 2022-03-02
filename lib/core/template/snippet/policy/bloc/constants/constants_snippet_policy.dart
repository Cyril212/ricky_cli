import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import '../../base_snippet_policy.dart';

class AppConstantSnippetPolicyArgs implements BaseSnippetPolicyArgs {
  final String appName;

  const AppConstantSnippetPolicyArgs({required this.appName});
}

class AppConstantSnippetPolicy extends BaseSnippetPolicy<AppConstantSnippetPolicyArgs> {
  AppConstantSnippetPolicy({required arguments}) : super(arguments: arguments);

  @override
  String get tag => 'app_constant';

  @override
  String get importSection => '';

  @override
  String get outerClassSection => '';

  @override
  String get classNameSection {
    final classBuilder = Class((builder) => builder
      ..name = 'AppConstant'
      ..fields.add(Field((builder) {
        builder
          ..modifier = FieldModifier.final$
          ..type = refer('String')
          ..name = 'kAppName'
          ..assignment = Code('\'${arguments!.appName}\'');
      })));
    return DartFormatter().format('${classBuilder.accept(DartEmitter())}');
  }
}

class ThemeConstantSnippetPolicyArgs implements BaseSnippetPolicyArgs {
  final String? primaryColor;
  final String? secondaryColor;

  const ThemeConstantSnippetPolicyArgs({this.primaryColor, this.secondaryColor});
}

class ThemeConstantSnippetPolicy extends BaseSnippetPolicy<ThemeConstantSnippetPolicyArgs> {
  ThemeConstantSnippetPolicy({required arguments}) : super(arguments: arguments);

  @override
  String get tag => 'theme_constant';

  @override
  String get importSection {
    final libraryBuilder = Library((builder) {
      builder.directives.add(Directive.import('package:flutter/material.dart'));
    });

    final emitter = DartEmitter();
    return DartFormatter().format('${libraryBuilder.accept(emitter)}');
  }

  @override
  String get outerClassSection => '';

  @override
  String get classNameSection {
    final classBuilder = Class((builder) {
      builder.name = 'ThemeConstant';
      if (arguments?.primaryColor != null) {
        builder.fields.add(setColorField('kColorPrimary', arguments!.primaryColor!));
      }
      if (arguments?.secondaryColor != null) {
        builder.fields.add(setColorField('kColorSecondary', arguments!.secondaryColor!));
      }
    });

    return DartFormatter().format('${classBuilder.accept(DartEmitter())}');
  }

  Field setColorField(String name, String color) {
    return Field((builder) {
      builder
        ..modifier = FieldModifier.final$
        ..type = refer('Color')
        ..name = name
        ..assignment = Code('const Color(0xFF$color)');
    });
  }
}
