import 'package:meta/meta.dart';
import 'package:ricky_cli/core/template/snippet/policy/base_snippet_policy.dart';
import 'package:ricky_cli/core/template/snippet/policy/bloc/utils/logger_snippet.dart';

import 'in_memory/in_memory_config.dart';
import 'config/structure_config.dart';
import 'snippet/policy/bloc/constants/constants_snippet_policy.dart';

class SampleTemplate extends StructureTemplate {
  final String appName;
  final String? primaryColor;
  final String? secondaryColor;

  SampleTemplate({required this.appName, this.primaryColor, this.secondaryColor, required String source}) : super(source: source);

  SampleTemplate.fromMemory({
    required this.appName,
    this.primaryColor,
    this.secondaryColor,
  }) : super(source: InMemoryConfig(content: kBlocInMemoryConfig));

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

class StructureElement {
  final String path;
  final String tag;

  const StructureElement({required this.path, required this.tag});

  @override
  bool operator ==(Object other) {
    if (other is! StructureElement) return false;
    return path == other.path && tag == other.tag;
  }
}

class StructureTemplate {
  @protected
  final StructureConfig _source;

  StructureTemplate({required source}) : _source = source;

  Future<List<StructureElement>> get structure => _source.retrieveStructure();

  List<BaseSnippetPolicy> get fileSnippets => [];
}
