import 'dart:io';

import 'package:meta/meta.dart';

import '../templates/template_configs/in_memory/in_memory_config.dart';
import 'template_configs/configs/template_config.dart';

class BlocTemplate extends StructureTemplate {
  BlocTemplate.fromMemory() : super(source: InMemoryConfig(content: kBlocInMemoryConfig));

  BlocTemplate.fromConfig() : super(source: FileConfig(path: 'core/template_configs/bloc_config.yaml'));
}

class StructureElement {
  final String path;
  final Future<bool>? predicate;

  StructureElement({required this.path, this.predicate});
}

class StructureTemplate {
  @protected
  final StructureConfig source;

  List<StructureElement>? _structure;

  StructureTemplate({required this.source});

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
