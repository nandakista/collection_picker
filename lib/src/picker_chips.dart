import 'package:flutter/material.dart';

/// Widget which wrap every item in GridView and ListView so can be used as picker widget.
class PickerChips extends StatelessWidget {
  const PickerChips({
    super.key,
    required this.onSelected,
    required this.child,
    required this.selected,
    this.isRadio = false,
  });

  /// Callback function when the item is selected.
  /// It called when the widget has been tapped.
  final void Function(bool) onSelected;

  /// Child which will be used as a picker widget
  final Widget child;

  /// Value that indicate if the widget has been selected or not
  final bool selected;

  /// Flag to use if the picker type is Radio
  final bool isRadio;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        if (selected) {
          if (!isRadio) onSelected(false);
        } else {
          onSelected(true);
        }
      },
      child: child,
    );
  }
}
