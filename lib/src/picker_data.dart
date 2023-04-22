/// Base model for wrapping the item collection picker
class PickerWrapper<T> {
  /// Value for indicate the data is selected
  bool isSelected;

  /// Value for indicate the data is available for picker or not.
  /// If this is set to **false** then the item cannot be selected
  bool isAvailable;

  /// Index of item in collection widget
  int? index;

  /// The actual data in item of the GridView or ListView Picker
  T? data;

  PickerWrapper({
    this.isSelected = false,
    this.isAvailable = true,
    this.index,
    this.data,
  });

  PickerWrapper<T> copy({
    bool? isSelected,
    bool? isAvailable,
    int? index,
    T? data,
  }) =>
      PickerWrapper(
        isSelected: isSelected ?? this.isSelected,
        isAvailable: isAvailable ?? this.isAvailable,
        index: index ?? this.index,
        data: data ?? this.data,
      );
}
