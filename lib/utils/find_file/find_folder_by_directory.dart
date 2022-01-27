import 'dart:io';

/// find a folder from the name in the lib folder
Directory? findFolderByName(String root, String name) {
  var current = Directory(root);
  final list = current.listSync(recursive: true, followLinks: false);
  final contains = list.firstWhere((element) {
    if (element is Directory) {
      return element.path.contains(name);
    }
    return false;
  });
  return contains as Directory?;
}
