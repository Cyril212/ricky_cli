import 'package:meta/meta.dart';
import 'package:ricky_cli/core/template/config/specitifactions/template_specification.dart';
import 'package:ricky_cli/core/template/snippet/policy/base_snippet_policy.dart';
import 'package:ricky_cli/core/template/snippet/policy/bloc/utils/logger_snippet_policy.dart';

import 'config/template_config.dart';
import 'snippet/policy/bloc/constants/constants_snippet_policy.dart';

class SampleTemplate extends Template {
  final String appName;
  final String? primaryColor;
  final String? secondaryColor;

  SampleTemplate({required this.appName, this.primaryColor, this.secondaryColor, required String source}) : super(source: source);

  SampleTemplate.fromMemory({
    required this.appName,
    this.primaryColor,
    this.secondaryColor,
  }) : super(source: InMemoryConfig(content: kBlocTemplateSpecification));

  @override
  List<BaseSnippetPolicy> get fileSnippets => [
        AppConstantSnippetPolicy(arguments: AppConstantSnippetPolicyArgs(appName: appName)),
        ThemeConstantSnippetPolicy(
            arguments: ThemeConstantSnippetPolicyArgs(
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        )),
        LoggerSnippetPolicy()
      ];
}

class TemplateElement {
  final String path;
  final String tag;

  const TemplateElement({required this.path, required this.tag});

  @override
  bool operator ==(Object other) {
    if (other is! TemplateElement) return false;
    return path == other.path && tag == other.tag;
  }
}

class Template {
  @protected
  final TemplateConfig _source;

  Template({required source}) : _source = source;

  Future<List<TemplateElement>> get structure => _source.retrieveStructure();

  List<BaseSnippetPolicy> get fileSnippets => [];
}
