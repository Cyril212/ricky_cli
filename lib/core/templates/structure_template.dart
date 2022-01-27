import 'dart:io';

import 'package:meta/meta.dart';

import 'template_configs/in_memory/in_memory_config.dart';
import 'template_configs/configs/template_config.dart';

class BlocTemplate extends StructureTemplate {
  BlocTemplate.fromMemory() : super(source: InMemoryConfig(content: kBlocInMemoryConfig));

  BlocTemplate.fromConfig() : super(source: FileConfig(path: 'core/templates/template_configs/file/bloc_config.yaml'));
}

class StructureElement {
  final String path;
  final Future<bool>? predicate;

  StructureElement({required this.path, this.predicate});

  @override
  bool operator ==(Object other) {
    if (other is! StructureElement) return false;
    return path == other.path && predicate == other.predicate;
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
