import 'dart:io';

import 'package:meta/meta.dart';
import 'package:ricky_cli/core/logger.dart';
import 'package:ricky_cli/utils/exceptions/cli_exception.dart';
import 'package:yaml/yaml.dart';

import '../template.dart';

class InMemoryConfig extends TemplateConfig<List<TemplateElement>> {
  InMemoryConfig({required List<TemplateElement> content}) : super(source: content);

  @override
  Future<List<TemplateElement>> retrieveStructure() => Future.value(source);
}

class FileConfig extends TemplateConfig<String> {
  FileConfig({required path}) : super(source: path);

  @override
  Future<List<TemplateElement>> retrieveStructure() {
    Logger.debug(message: source);
    final yamlConfig = File(source);

    if (yamlConfig.existsSync() == false) {
      throw CliException('FileConfig is not found');
    }

    final yamlConfigAsString = yamlConfig.readAsStringSync();

    final YamlMap yamlStructure = loadYaml(yamlConfigAsString);

    final structureElementList = (yamlStructure['structure'] as YamlList).value;
    return Future.value(structureElementList.map((structure) => TemplateElement(path: structure['path'], tag: structure['tag'])).toList());
  }
}

class WebConfig extends TemplateConfig<String> {
  WebConfig({required path}) : super(source: path);

  @override
  Future<List<TemplateElement>> retrieveStructure() {
    //todo:implement fetching config from server
    return Future.value([]);
  }
}

abstract class TemplateConfig<T> {
  @protected
  final T source;

  TemplateConfig({required source, path}) : source = source;

  Future<List<TemplateElement>> retrieveStructure();
}
