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
    this.widthItem,
    this.heightItem,
    this.shrinkWrap = false,
    this.physics,
    this.separator,
    this.initialValue,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  final PickerType type;
  final List<T> data;
  final PickerItemBuilder<PickerData<T>> itemBuilder;
  final PickerOnChanged<T> onChanged;
  final double? widthItem;
  final double? heightItem;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Widget? separator;
  final T? initialValue;
  final Axis scrollDirection;

  @override
  State<ListViewPicker<T>> createState() => _ListViewPickerState<T>();
}

class _ListViewPickerState<T> extends State<ListViewPicker<T>> {
  List<PickerData<T>> tempData = [];

  @override
  void initState() {
    tempData = widget.data.map((e) => PickerData(data: e)).toList();
    _setInitial();
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
