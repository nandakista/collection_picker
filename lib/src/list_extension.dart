/// List extension of this collection_picker package
extension ListExt<T> on List<T> {
  /// List extension to safely find the first data in the list.
  /// If the data is not found, it will return null.
  T? firstWhereOrNull(bool Function(T) test) {
    final index = indexWhere(test);
    if (index != -1) {
      return this[index];
    }
    return null;
  }
}
