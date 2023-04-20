extension ListExt<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    final index = indexWhere(test);
    if (index != -1) {
      return this[index];
    }
    return null;
  }
}
