class PickerData<T> {
  bool isSelected;
  bool isAvailable;
  int? index;
  T? data;

  PickerData({
    this.isSelected = false,
    this.isAvailable = true,
    this.index,
    this.data,
  });

  PickerData<T> copy({
    bool? isSelected,
    bool? isAvailable,
    int? index,
    T? data,
  }) =>
      PickerData(
        isSelected: isSelected ?? this.isSelected,
        isAvailable: isAvailable ?? this.isAvailable,
        index: index ?? this.index,
        data: data ?? this.data,
      );
}
