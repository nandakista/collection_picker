import 'package:collection_picker/src/list_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'picker_wrapper.dart';
import 'picker_typedef.dart';
import 'picker_chips.dart';

/// ListView with capabilities to select the item
/// when you select or tap the item it will be return PickerWrapper<T> data
/// that contains flag **isSelected**. With this flag you can easy customized
/// your selected item widget
class ListViewPicker<T> extends StatefulWidget {
  const ListViewPicker({
    super.key,
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
    this.padding,
    this.controller,
    this.cacheExtent,
    this.reverse = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.dragStartBehavior = DragStartBehavior.start,
    this.primary,
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

  /// Separator widget for each item in the ListView
  final Widget? separator;

  /// Scroll Direction of ListView
  final Axis scrollDirection;

  /// ShrinkWrap of the ListView
  final bool shrinkWrap;

  /// ScrollPhysics of the ListView
  final ScrollPhysics? physics;

  /// Padding of the ListView
  final EdgeInsets? padding;

  /// ScrollController of the ListView
  final ScrollController? controller;

  /// reverse data status of the ListView
  final bool reverse;

  /// cacheExtent of the ListView
  final double? cacheExtent;

  /// primary of the ListView
  final bool? primary;

  /// restorationId of the ListView
  final String? restorationId;

  /// ScrollViewKeyboardDismissBehavior of the ListView
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// clipBehavior of the ListView
  final Clip clipBehavior;

  /// findChildIndexCallback of the ListView
  final int? Function(Key)? findChildIndexCallback;

  /// DragStartBehavior of the ListView
  final DragStartBehavior dragStartBehavior;

  /// addAutomaticKeepAlives of the ListView
  final bool addAutomaticKeepAlives;

  /// addRepaintBoundaries of the ListView
  final bool addRepaintBoundaries;

  /// addSemanticIndexes of the ListView
  final bool addSemanticIndexes;

  @override
  State<ListViewPicker<T>> createState() => _ListViewPickerState<T>();
}

class _ListViewPickerState<T> extends State<ListViewPicker<T>> {
  List<PickerWrapper<T>> tempData = [];

  @override
  void initState() {
    setInitData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ListViewPicker<T> oldWidget) {
    setInitData();
    super.didUpdateWidget(oldWidget);
  }

  void setInitData() {
    tempData = widget.data
        .map((e) => PickerWrapper(data: e, isAvailable: widget.enabled))
        .toList();
    _setUnavailableDataByIndex();
    _setInitialValue();
    if (widget.initialValues != null && widget.initialValues != []) {
      _setInitialValues();
    }
    if (widget.unavailableData != null && widget.unavailableData != []) {
      _setUnavailableData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: tempData.length,
      scrollDirection: widget.scrollDirection,
      padding: widget.padding,
      controller: widget.controller,
      reverse: widget.reverse,
      cacheExtent: widget.cacheExtent,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      clipBehavior: widget.clipBehavior,
      dragStartBehavior: widget.dragStartBehavior,
      findChildIndexCallback: widget.findChildIndexCallback,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      primary: widget.primary,
      restorationId: widget.restorationId,
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

  /// The function to set initial value as selected
  void _setInitialValue() {
    if (widget.initialValue != null) {
      int index = tempData.indexWhere((e) => e.data == widget.initialValue);
      if (tempData[index].isAvailable) {
        tempData[index] = PickerWrapper(
          isSelected: true,
          data: widget.initialValue as T,
        );
      } else {
        throw "Initial value can't include in notAvailableIndex";
      }
      setState(() {});
    }
  }
}
