import 'dart:io';

import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import '../../structure_template.dart';

class InMemoryConfig extends StructureConfig<List<String>> {
  InMemoryConfig({required List<String> content}) : super(source: content);

  @override
  Future<List<StructureElement>> retrieveStructure() => Future.value(source.map((path) => StructureElement(path: path)).toList());
}

class FileConfig extends StructureConfig<String> {
  FileConfig({required path}) : super(source: path);

  @override
  Future<List<StructureElement>> retrieveStructure() async {
    final yamlConfig = File(source);
    final yamlStructure = loadYaml(await yamlConfig.readAsString());

    return [];
    // throw UnimplementedError();
  }
}

abstract class StructureConfig<T> {
  @protected
  final T source;

  StructureConfig({required source}) : source = source;

  Future<List<StructureElement>> retrieveStructure();
}