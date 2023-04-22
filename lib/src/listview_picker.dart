import 'package:collection_picker/src/list_extension.dart';
import 'package:flutter/material.dart';

import 'picker_data.dart';
import 'picker_typedef.dart';
import 'picker_chips.dart';

class ListViewPicker<T> extends StatefulWidget {
  const ListViewPicker({
    Key? key,
    required this.type,
    required this.data,
    required this.onChanged,
    required this.itemBuilder,
    this.shrinkWrap = false,
    this.physics,
    this.separator,
    this.initialValue,
    this.initialValues,
    this.scrollDirection = Axis.vertical,
    this.unavailableDataIndex,
  }) : super(key: key);

  /// Type of picker (single, radio, or multi)
  final PickerType type;

  /// The given data in widget
  final List<T> data;

  /// Initial value which will be set as selected
  final T? initialValue;

  /// List of initial value.
  /// Use this [initialValues] if you have more than one data for initial value.
  final List<T>? initialValues;

  /// List index of element that can't be select
  final List<int>? unavailableDataIndex;

  /// Builder function to create each item in the GridView widget.
  final PickerItemBuilder<PickerWrapper<T>> itemBuilder;

  /// Called when the user select some value in the picker
  final PickerOnChanged<T> onChanged;

  /// Separator widget for each item in the ListView
  final Widget? separator;

  /// Scroll Direction of ListView
  final Axis scrollDirection;

  final bool shrinkWrap;

  final ScrollPhysics? physics;

  @override
  State<ListViewPicker<T>> createState() => _ListViewPickerState<T>();
}

class _ListViewPickerState<T> extends State<ListViewPicker<T>> {
  List<PickerWrapper<T>> tempData = [];

  @override
  void initState() {
    tempData = widget.data.map((e) => PickerWrapper(data: e)).toList();
    _setAvailableValues();
    if (widget.initialValues != null && widget.initialValue != []) {
      _setInitialValues();
    } else {
      _setInitialValue();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: tempData.length,
      scrollDirection: widget.scrollDirection,
      separatorBuilder: (BuildContext context, int index) {
        return widget.separator ?? const SizedBox.shrink();
      },
      itemBuilder: (context, index) {
        final item = tempData[index];
        return PickerChips(
          selected: item.isSelected,
          isRadio: (widget.type == PickerType.radio) ? true : false,
          onSelected: (bool isSelected) {
            if (item.isAvailable) {
              if (widget.type != PickerType.multiple) {
                for (var element in tempData) {
                  element.isSelected = false;
                }
              }
              tempData = tempData.map(
                    (otherChip) {
                  return item == otherChip
                      ? otherChip.copy(isSelected: isSelected)
                      : otherChip;
                },
              ).toList();
              widget.onChanged(
                context,
                index,
                tempData
                    .firstWhereOrNull(
                        (element) => element.isSelected && element.isAvailable)
                    ?.data,
                tempData
                    .where(
                        (element) => element.isSelected && element.isAvailable)
                    .map((e) => e.data)
                    .toList(),
              );
            }
            setState(() {});
          },
          child: widget.itemBuilder(item),
        );
      },
    );
  }

  void _setAvailableValues() {
    for (int i in widget.unavailableDataIndex ?? []) {
      tempData[i].isAvailable = false;
    }
  }

  /// The function to set list of initial value as selected
  void _setInitialValues() {
    for (var initialData in widget.initialValues!) {
      int index = tempData.indexWhere((e) => e.data == initialData);
      if (tempData[index].isAvailable) {
        tempData[index] = PickerWrapper(
          isSelected: true,
          index: index,
          data: widget.initialValue,
        );
      } else {
        throw "Initial value can't include in notAvailableIndex";
      }
    }
  }

  /// The function to set initial value as selected
  void _setInitialValue() {
    if (widget.initialValue != null) {
      int index = tempData.indexWhere((e) => e.data == widget.initialValue);
      if (tempData[index].isAvailable) {
        tempData[index] = PickerWrapper(
          isSelected: true,
          index: index,
          data: widget.initialValue,
        );
      } else {
        throw "Initial value can't include in notAvailableIndex";
      }
      setState(() {});
    }
  }
}
