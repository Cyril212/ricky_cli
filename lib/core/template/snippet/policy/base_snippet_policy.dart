import 'package:meta/meta.dart';

abstract class BaseSnippetPolicyArgs {}

abstract class BaseSnippetPolicy<T extends BaseSnippetPolicyArgs> {
  static const _importPlaceholder = '@IMPRT@';
  static const _outerClassPlaceholder = '@OUTCLS@';
  static const _classNamePlaceholder = '@CLSNAME@';
  static const _topLevelVariablePlaceholder = '@TLVRBL@';
  static const _functionPlaceholder = '@FUNC@';

  BaseSnippetPolicy({this.arguments});

  String get tag;

  @protected
  String get importSection => '';

  @protected
  String get outerClassSection => '';

  @protected
  String get classNameSection => '';

  String get topLevelVariableSection => '';

  @protected
  String get functionSection => '';

  @protected
  String? get snippet => '''
  $_importPlaceholder
  
  $_outerClassPlaceholder
  
  $_classNamePlaceholder
  
  $_topLevelVariablePlaceholder
  
  $_functionPlaceholder
  ''';

  @protected
  T? arguments;

  String? process() {
    return snippet
        ?.replaceAll(_importPlaceholder, importSection)
        .replaceAll(_outerClassPlaceholder, outerClassSection)
        .replaceAll(_classNamePlaceholder, classNameSection)
        .replaceAll(_topLevelVariablePlaceholder, topLevelVariableSection)
        .replaceAll(_functionPlaceholder, functionSection);
  }
}
