import 'package:flutter/material.dart';

/// Type of picker (single, radio, or multi)
enum PickerType {
  single,
  multiple,
  radio,
}

/// Builder function to create each item in the GridView widget.
typedef PickerItemBuilder<T> = Widget Function(
  T item,
);

/// Called when the user select some value in the picker
typedef PickerOnChanged<T> = Function(
  BuildContext context,
  int index,
  T? selectedItem,
  List<T?> selectedListItem,
);
