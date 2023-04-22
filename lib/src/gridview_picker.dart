import 'package:collection_picker/src/list_extension.dart';
import 'package:flutter/material.dart';

import 'picker_data.dart';
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
  }) : super(key: key);

  /// Type of picker (single, radio, or multi)
  final PickerType type;

  /// The given data in widget
  final List<T> data;

  /// Initial value which will be set as selected
  final T? initialValue;

  /// Builder function to create each item in the GridView widget.
  final PickerItemBuilder<PickerData<T>> itemBuilder;

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

  @override
  State<GridViewPicker<T>> createState() => _GridViewPickerState<T>();
}

class _GridViewPickerState<T> extends State<GridViewPicker<T>> {
  List<PickerData<T>> tempData = [];

  @override
  void initState() {
    tempData = widget.data.map((e) => PickerData(data: e)).toList();
    _setInitial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: tempData.length,
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
          child: widget.itemBuilder(item),
        );
      },
    );
  }

  void _setInitial() {
    if (widget.initialValue != null) {
      int index =
          tempData.indexWhere((element) => element.data == widget.initialValue);
      tempData[index] = PickerData(
        isSelected: true,
        index: index,
        data: widget.initialValue,
      );
      setState(() {});
    }
  }
}
