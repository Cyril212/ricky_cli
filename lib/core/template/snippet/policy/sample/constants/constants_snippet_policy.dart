import 'package:ricky_cli/core/template/snippet/sample/sample_project_snippet.dart';

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
  String? get snippet => sampleSnippet[tag];

  @override
  String get classNameSection => 'AppConstant';

  @override
  String get topLevelVariableSection => 'final String kAppName = "${arguments!.appName}"';

  @override
  String get functionSection => '';
}

class TextConstantSnippetPolicy extends BaseSnippetPolicy {
  TextConstantSnippetPolicy() : super();

  @override
  String get tag => 'text_constant';

  @override
  String? get snippet => sampleSnippet[tag];

  @override
  String get classNameSection => 'TextConstant';

  @override
  String get topLevelVariableSection => '//todo:add constants';

  @override
  String get functionSection => '';
}

class ThemeConstantSnippetPolicyArgs implements BaseSnippetPolicyArgs {
  final String primaryColor;
  final String secondaryColor;
  final String shadowColor;

  const ThemeConstantSnippetPolicyArgs({required this.primaryColor, required this.secondaryColor, required this.shadowColor});
}

class ThemeConstantSnippetPolicy extends BaseSnippetPolicy<ThemeConstantSnippetPolicyArgs> {
  ThemeConstantSnippetPolicy({required arguments}) : super(arguments: arguments);

  @override
  String get tag => 'theme_constant';

  @override
  String? get snippet => sampleSnippet[tag];

  @override
  String get classNameSection => 'ThemeConstant';

  @override
  String get topLevelVariableSection => '''
  const kColorPrimary = Color(0x${arguments?.primaryColor});
  const kColorSecondary = Color(0x${arguments?.secondaryColor});
  const kColorShadow = Color(0x${arguments?.shadowColor});
  ''';

  @override
  String get functionSection => '';
}
