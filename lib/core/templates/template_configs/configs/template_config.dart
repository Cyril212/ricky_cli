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
    final YamlMap yamlStructure = loadYaml(await yamlConfig.readAsString());

    final structureElementList = (yamlStructure['structure'] as YamlList).value;
    return Future.value(structureElementList.map((path) => StructureElement(path: path)).toList());
  }
}

class WebConfig extends StructureConfig<String> {
  WebConfig({required path}) : super(source: path);

  @override
  Future<List<StructureElement>> retrieveStructure() {
    //todo:implement fetching config from server
    return Future.value([]);
  }
}

abstract class StructureConfig<T> {
  @protected
  final T source;

  StructureConfig({required source, path}) : source = source;

  Future<List<StructureElement>> retrieveStructure();
}
