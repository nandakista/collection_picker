import 'package:flutter/material.dart';

import 'list_extension.dart';
import 'picker_wrapper.dart';
import 'picker_typedef.dart';
import 'picker_chips.dart';

class WrapPicker<T> extends StatefulWidget {
  const WrapPicker({
    super.key,
    required this.type,
    required this.data,
    required this.onChanged,
    required this.itemBuilder,
    this.initialValue,
    this.initialValues,
    this.unavailableData,
    this.unavailableDataIndex,
    this.enabled = true,
    this.spacing = 8,
    this.runSpacing = 8,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.direction = Axis.horizontal,
    this.padding,
  });

  final PickerType type;
  final List<T> data;
  final PickerOnChanged<T> onChanged;
  final PickerItemBuilder<PickerWrapper<T>> itemBuilder;

  final T? initialValue;
  final List<T>? initialValues;
  final List<T>? unavailableData;
  final List<int>? unavailableDataIndex;
  final bool enabled;

  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final Axis direction;
  final EdgeInsets? padding;

  @override
  State<WrapPicker<T>> createState() => _WrapPickerState<T>();
}

class _WrapPickerState<T> extends State<WrapPicker<T>> {
  List<PickerWrapper<T>> tempData = [];

  @override
  void initState() {
    super.initState();
    _setInitData();
  }

  @override
  void didUpdateWidget(covariant WrapPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setInitData();
  }

  void _setInitData() {
    tempData = widget.data
        .map((e) => PickerWrapper(data: e, isAvailable: widget.enabled))
        .toList();

    _setUnavailableDataByIndex();
    _setInitialValue();
    _setInitialValues();
    _setUnavailableData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Wrap(
        spacing: widget.spacing,
        runSpacing: widget.runSpacing,
        alignment: widget.alignment,
        runAlignment: widget.runAlignment,
        direction: widget.direction,
        children: List.generate(tempData.length, (index) {
          final item = tempData[index];

          return PickerChips(
            selected: item.isSelected,
            isRadio: widget.type == PickerType.radio,
            onSelected: (bool isSelected) {
              if (!item.isAvailable) return;

              if (widget.type != PickerType.multiple) {
                for (var element in tempData) {
                  element.isSelected = false;
                }
              }

              tempData[index] = item.copy(isSelected: isSelected);

              widget.onChanged(
                context,
                index,
                tempData
                    .firstWhereOrNull((e) => e.isSelected && e.isAvailable)
                    ?.data,
                tempData
                    .where((e) => e.isSelected && e.isAvailable)
                    .map((e) => e.data)
                    .toList(),
              );

              setState(() {});
            },
            child: widget.itemBuilder(context, index, item),
          );
        }),
      ),
    );
  }

  /// To set unavailable data for selected
  void _setUnavailableData() {
    if (widget.unavailableData != null && widget.unavailableData != []) {
      for (var unavailableData in widget.unavailableData!) {
        int index = tempData.indexWhere((e) => e.data == unavailableData);
        tempData[index] = tempData[index].copy(isAvailable: false);
      }
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
    if (widget.initialValues != null && widget.initialValues != []) {
      for (var initialData in widget.initialValues!) {
        int index = tempData.indexWhere((e) => e.data == initialData);
        if (tempData[index].isAvailable) {
          tempData[index] = tempData[index].copy(isSelected: true);
        } else {
          throw "Initial value can't include in notAvailableIndex";
        }
      }
    }
  }

  /// The function to set initial value as selected
  void _setInitialValue() {
    if (widget.initialValue != null) {
      int index = tempData.indexWhere((e) => e.data == widget.initialValue);
      if (tempData[index].isAvailable) {
        tempData[index] = tempData[index].copy(isSelected: true);
      } else {
        throw "Initial value can't include in notAvailableIndex";
      }
      setState(() {});
    }
  }
}
