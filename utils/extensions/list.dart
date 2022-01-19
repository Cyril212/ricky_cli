extension ListExtension<T> on List<T> {
  List<T> replaceAll(T Function(T element) function) {
    for (var i = 0; i < length; i++) {
      this[i] = function(this[i]);
    }
    return this;
  }
}
