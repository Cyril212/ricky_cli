import 'dart:io';

import 'package:meta/meta.dart';
import 'package:ricky_cli/utils/exceptions/cli_exception.dart';
import 'package:yaml/yaml.dart';

import '../structure_template.dart';

class InMemoryConfig extends StructureConfig<List<StructureElement>> {
  InMemoryConfig({required List<StructureElement> content}) : super(source: content);

  @override
  Future<List<StructureElement>> retrieveStructure() => Future.value(source);
}

class FileConfig extends StructureConfig<String> {
  FileConfig({required path}) : super(source: path);

  @override
  Future<List<StructureElement>> retrieveStructure() {
    final yamlConfig = File(source);

    if (yamlConfig.existsSync() == false) {
      throw CliException('FileConfig is not found');
    }

    final yamlConfigAsString = yamlConfig.readAsStringSync();

    final YamlMap yamlStructure = loadYaml(yamlConfigAsString);

    final structureElementList = (yamlStructure['structure'] as YamlList).value;
    return Future.value(structureElementList.map((structure) => StructureElement(path: structure['path'], tag: structure['tag'])).toList());
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
