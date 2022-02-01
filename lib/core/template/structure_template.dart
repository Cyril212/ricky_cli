import 'dart:io';

import 'package:meta/meta.dart';
import 'package:ricky_cli/core/template/snippet/policy/base_snippet_policy.dart';

import 'in_memory/in_memory_config.dart';
import 'config/structure_config.dart';
import 'snippet/policy/sample/constants/constants_snippet_policy.dart';

class SampleTemplate extends StructureTemplate {
  final List<BaseSnippetPolicy> fileSnippets = [
    AppConstantSnippetPolicy(arguments: AppConstantSnippetPolicyArgs(appName: "SampleName")),
    TextConstantSnippetPolicy(),
    ThemeConstantSnippetPolicy(arguments: ThemeConstantSnippetPolicyArgs(primaryColor: 'FFF444', secondaryColor: '000444', shadowColor: '00000F'))
  ];

  SampleTemplate.fromMemory() : super(source: InMemoryConfig(content: kBlocInMemoryConfig));

  SampleTemplate.fromConfig() : super(source: FileConfig(path: 'lib/core/template/file/sample_config.yaml'));
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

  List<StructureElement>? _structure;

  StructureTemplate({required source}) : _source = source;

  Future<List<StructureElement>> get structure => _source.retrieveStructure();

  bool _isPathAvailable(String path) => _structure != null && _structure!.contains(path);

  Directory? getDirectory(String path) {
    if (_isPathAvailable(path)) {
      return Directory(path);
    } else {
      return null;
    }
  }

  File? getFile(String path) {
    if (_isPathAvailable(path)) {
      return File(path);
    } else {
      return null;
    }
  }
}
