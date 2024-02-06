import 'package:collection_picker/src/list_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'picker_wrapper.dart';
import 'picker_typedef.dart';
import 'picker_chips.dart';

/// Sliver GridView with capabilities to select the item
/// when you select or tap the item it will be return PickerWrapper<T> data
/// that contains flag **isSelected**. With this flag you can easy customized
/// your selected item widget
class SliverGridViewPicker<T> extends StatefulWidget {
  const SliverGridViewPicker({
    super.key,
    required this.type,
    required this.data,
    required this.onChanged,
    required this.gridDelegate,
    required this.itemBuilder,
    this.initialValue,
    this.initialValues,
    this.unavailableDataIndex,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.findChildIndexCallback,
    this.unavailableData,
    this.enabled = true,
  });

  /// Type of picker (single, radio, or multi)
  final PickerType type;

  /// The given data in widget
  final List<T> data;

  /// Initial value which will be set as selected
  final T? initialValue;

  /// List of initial value.
  /// Use this [initialValues] if you have more than one data for initial value.
  final List<T>? initialValues;

  /// List of element that can't be select
  final List<T>? unavailableData;

  /// List index of element that can't be select
  final List<int>? unavailableDataIndex;

  /// Set to true for disable picker
  final bool enabled;

  /// Builder function to create each item in the GridView widget.
  final PickerItemBuilder<PickerWrapper<T>> itemBuilder;

  /// Called when the user select some value in the picker
  final PickerOnChanged<T> onChanged;

  /// The delegate that controls the size and position of the children
  final SliverGridDelegate gridDelegate;

  /// findChildIndexCallback of the GridView
  final int? Function(Key)? findChildIndexCallback;

  /// DragStartBehavior of the GridView
  final DragStartBehavior dragStartBehavior;

  /// addAutomaticKeepAlives of the GridView
  final bool addAutomaticKeepAlives;

  /// addRepaintBoundaries of the GridView
  final bool addRepaintBoundaries;

  /// addSemanticIndexes of the GridView
  final bool addSemanticIndexes;

  @override
  State<SliverGridViewPicker<T>> createState() =>
      _SliverGridViewPickerState<T>();
}

class _SliverGridViewPickerState<T> extends State<SliverGridViewPicker<T>> {
  List<PickerWrapper<T>> tempData = [];

  @override
  void initState() {
    setInitData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SliverGridViewPicker<T> oldWidget) {
    setInitData();
    super.didUpdateWidget(oldWidget);
  }

  /// Its called when you tet initial data from
  /// [widget.initialValue] or [widget.initialValues]
  void setInitData() {
    tempData = widget.data
        .map((e) => PickerWrapper(data: e, isAvailable: widget.enabled))
        .toList();
    _setUnavailableDataByIndex();
    _setInitialValue();
    _setUnavailableDataByIndex();
    if (widget.initialValues != null && widget.initialValue != []) {
      _setInitialValues();
    }
    if (widget.unavailableData != null && widget.unavailableData != []) {
      _setUnavailableData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: tempData.length,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      findChildIndexCallback: widget.findChildIndexCallback,
      gridDelegate: widget.gridDelegate,
      itemBuilder: (context, index) {
        final item = tempData[index];
        return PickerChips(
          isRadio: (widget.type == PickerType.radio) ? true : false,
          selected: item.isSelected,
          onSelected: (isSelected) {
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
                  .where((element) => element.isSelected && element.isAvailable)
                  .map((e) => e.data)
                  .toList(),
            );
            setState(() {});
          },
          child: widget.itemBuilder(context, index, item),
        );
      },
    );
  }

  /// To set unavailable data for selected
  void _setUnavailableData() {
    for (var unavailableData in widget.unavailableData!) {
      int index = tempData.indexWhere((e) => e.data == unavailableData);
      tempData[index] = tempData[index].copy(isAvailable: false);
    }
  }

  /// To set unavailable data for selected by index
  void _setUnavailableDataByIndex() {
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
          data: widget.initialValue as T,
        );
      } else {
        throw "Initial value can't include in notAvailableIndex";
      }
    }
  }

  /// Function to set single initial value as default selected
  void _setInitialValue() {
    if (widget.initialValue != null) {
      int index =
          tempData.indexWhere((element) => element.data == widget.initialValue);
      tempData[index] = PickerWrapper(
        isSelected: true,
        data: widget.initialValue as T,
      );
      setState(() {});
    }
  }
}
