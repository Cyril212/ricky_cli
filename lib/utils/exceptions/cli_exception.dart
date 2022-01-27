class CliException implements Exception {
  String? message;

  CliException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message ?? 'Unknown error';
  }
}
