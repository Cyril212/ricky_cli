import 'dart:io';

import 'package:ricky_cli/core/template/structure_template.dart';

class TemplateGenerator {
  final StructureTemplate _template;

  const TemplateGenerator({required template}) : _template = template;

  void generateStructure() {
    _template.structure.then((element) {
      element.forEach((element) {
        var currentFile = File(element.path)..createSync(recursive: true);
        final sample = SampleTemplate.fromConfig();

        final content = sample.fileSnippets.where((snippet) => element.tag == snippet.tag).first.process();
        currentFile.writeAsStringSync(content!);
      });
    });
  }
}