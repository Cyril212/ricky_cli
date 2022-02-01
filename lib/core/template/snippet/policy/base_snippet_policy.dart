import 'package:meta/meta.dart';

enum SnippetPlaceholderType { clsname, tlvrb, func }

abstract class BaseSnippetPolicyArgs {}

abstract class BaseSnippetPolicy<T extends BaseSnippetPolicyArgs> {
  static const _classNamePlaceholder = '@CLSNAME@';
  static const _topLevelVariablePlaceholder = '@TLVRBL@';
  static const _functionPlaceholder = '@FUNC@';

  BaseSnippetPolicy({this.arguments});

  String get tag;

  @protected
  String get classNameSection;

  @protected
  String get topLevelVariableSection;

  @protected
  String get functionSection;

  @protected
  String? get snippet;

  @protected
  T? arguments;

  @protected
  String? process() {

    return snippet
      ?.replaceAll(_classNamePlaceholder, classNameSection)
      .replaceAll(_topLevelVariablePlaceholder, topLevelVariableSection)
      .replaceAll(_functionPlaceholder, _functionPlaceholder);
  }
}
