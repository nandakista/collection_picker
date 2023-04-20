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
    this.widthItem,
    this.heightItem,
    this.crossAxisSpacing,
    this.mainAxisSpacing = 0.0,
    this.shrinkWrap = false,
    this.physics,
    this.initialValue,
  }) : super(key: key);

  final PickerType type;
  final List<T> data;
  final PickerItemBuilder<PickerData<T>> itemBuilder;
  final PickerOnChanged<T> onChanged;
  final double? widthItem;
  final double? heightItem;
  final double? crossAxisSpacing;
  final double mainAxisSpacing;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final T? initialValue;

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
        maxCrossAxisExtent: widget.widthItem ?? 200,
        mainAxisExtent: widget.heightItem ?? 50,
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
