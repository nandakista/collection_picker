import 'package:collection_picker/src/list_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'picker_wrapper.dart';
import 'picker_typedef.dart';
import 'picker_chips.dart';

class GridViewPicker<T> extends StatefulWidget {
  const GridViewPicker({
    Key? key,
    required this.type,
    required this.data,
    required this.onChanged,
    required this.itemBuilder,
    this.maxCrossAxisExtent,
    this.mainAxisExtent,
    this.crossAxisSpacing,
    this.mainAxisSpacing = 0.0,
    this.shrinkWrap = false,
    this.physics,
    this.initialValue,
    this.initialValues,
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

  /// MaxCrossAxisExtent of the GridView with default value 200
  final double? maxCrossAxisExtent;

  /// MainAxisExtent of the GridView with default value 50
  final double? mainAxisExtent;

  /// CrossAxisSpacing of the GridView with default value 8
  final double? crossAxisSpacing;

  /// MainAxisSpacing of the GridView
  final double mainAxisSpacing;

  final bool shrinkWrap;

  final ScrollPhysics? physics;

  final EdgeInsets? padding;

  final ScrollController? controller;
  final bool reverse;
  final double? cacheExtent;
  final bool? primary;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final Clip clipBehavior;
  final int? Function(Key)? findChildIndexCallback;
  final DragStartBehavior dragStartBehavior;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  @override
  State<GridViewPicker<T>> createState() => _GridViewPickerState<T>();
}

class _GridViewPickerState<T> extends State<GridViewPicker<T>> {
  List<PickerWrapper<T>> tempData = [];

  @override
  void initState() {
    setInitData();
    super.initState();
  }

  void setInitData() {
    tempData = widget.data.map((e) => PickerWrapper(data: e)).toList();
    _setAvailableValues();
    if (widget.initialValues != null && widget.initialValue != []) {
      _setInitialValues();
    } else {
      _setInitialValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    setInitData();
    return GridView.builder(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: tempData.length,
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
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: widget.maxCrossAxisExtent ?? 200,
        mainAxisExtent: widget.mainAxisExtent ?? 50,
        crossAxisSpacing: widget.crossAxisSpacing ?? 8,
        mainAxisSpacing: widget.mainAxisSpacing,
      ),
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
          data: widget.initialValue,
        );
      } else {
        throw "Initial value can't include in notAvailableIndex";
      }
    }
  }

  void _setInitialValue() {
    if (widget.initialValue != null) {
      int index =
          tempData.indexWhere((element) => element.data == widget.initialValue);
      tempData[index] = PickerWrapper(
        isSelected: true,
        data: widget.initialValue,
      );
      setState(() {});
    }
  }
}
