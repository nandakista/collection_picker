import 'package:flutter/material.dart';

enum PickerType {
  single,
  multiple,
  radio,
}

typedef PickerItemBuilder<T> = Widget Function(
  T item,
);

typedef PickerOnChanged<T> = Function(
  BuildContext context,
  int index,
  T? selectedItem,
  List<T?> selectedListItem,
);
