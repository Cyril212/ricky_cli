import 'dart:io';

/// find a folder from the name in the lib folder
File findFileByName(String root, String name) {
  final completePath = root + name;
  var path = Uri.parse('.').resolveUri(Uri.file(completePath)).toFilePath();
  print(path);
  if (path == '') path = '.';

  return File(path);
}
