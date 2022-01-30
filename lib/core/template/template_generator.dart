import 'dart:io';

import 'package:ricky_cli/core/template/structure_template.dart';

class TemplateGenerator {
  final StructureTemplate _template;

  TemplateGenerator({required template}) : _template = template;

  void generateStructure() {
    _template.structure.then((element) {
      element.forEach((element) {
        File(element.path).createSync(recursive: true);
      });
    });
  }
}
