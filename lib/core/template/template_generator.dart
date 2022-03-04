import 'dart:io';
import 'package:ricky_cli/core/template/template.dart';

class TemplateGenerator {
  final Template _template;

  const TemplateGenerator({required template}) : _template = template;

  void generateStructure() {
    _template.structure.then((element) {
      element.forEach((element) {
        var currentFile = File(element.path)..createSync(recursive: true);

        final content = _template.fileSnippets.firstWhere((snippet) => element.tag == snippet.tag).process();
        currentFile.writeAsStringSync(content!);
      });
    });
  }
}
