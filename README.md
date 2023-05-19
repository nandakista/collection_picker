<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Overview

A Package contains selectable listview and gridview widgets with 
support for single, multi, and radio picker types.

# Getting Started

Add dependency to your **pubspec.yaml**
```dart
dependencies:
  collection_picker : "^version"
```

Import it in your dart code
```dart
import 'package:collection_picker/collection_picker.dart';
```

# Usage

We use sample data with model data and lists as real to make it easier for you to understand

The sample model data given is :
```dart
class CityModel {
  String province;
  String city;

  CityModel(this.province, this.city);
}
```

And the dummy data list is :
```dart
List<CityModel> dataCity = [
  CityModel('Jakarta', 'SCBD'),
  CityModel('Jakarta', 'Tebet'),
  CityModel('Jakarta', 'Gambir'),
  CityModel('Lampung', 'Bandar Lampung'),
  CityModel('Lampung', 'Pringsewu'),
  CityModel('Bandung', 'Setrasari'),
  CityModel('Bandung', 'Gedebage'),
  CityModel('Bandung', 'Cihanjuang'),
  CityModel('Yogyakarta', 'Bantul'),
  CityModel('Yogyakarta', 'Sleman'),
];
```

### ListViewPicker

<img src="https://user-images.githubusercontent.com/47182823/233113361-7ccfebb0-28a1-4692-b3dc-3c574d651306.gif" width="800" />

```dart
ListViewPicker<CityModel>(
  type: PickerType.single,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  separator: const Divider(thickness: 1, height: 16),
  initialValue: dataCity.first,
  data: dataCity,
  itemBuilder: (PickerWrapper<CityModel> item) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${item.data?.city}'),
          (item.isSelected)
              ? const Icon(Icons.check)
              : const SizedBox.shrink()
        ],
      ),
    );
  },
  onChanged: (context, index, selectedItem, selectedListItem) {
    // when the type is single/radio, you should use this
    debugPrint('Selected item = ${selectedItem.city}');

    /// when the type is multiple, you should use this
    debugPrint('All selected item = ${selectedListItem.map((e) => e?.city)}');
  },
)
```

### GridViewPicker

Actually is same as Picker ListView but it is serves as GridView.

<img src="https://user-images.githubusercontent.com/47182823/233122729-e20c9c91-003a-4ff4-919f-6a65d6446bc0.gif" width="300" />

```dart
GridViewPicker(
  type: PickerType.multiple,
  shrinkWrap: true,
  initialValue: dataCity.first,
  data: dataCity,
  itemBuilder: (PickerWrapper<CityModel> item) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${item.data?.city}'),
          (item.isSelected)
              ? const Icon(Icons.check)
              : const SizedBox.shrink()
        ],
      ),
    );
  },
  onChanged: (context, index, selectedItem, selectedListItem) {
    // when the type is single/radio, you should use this
    debugPrint('selected item = ${selectedItem?.city}');

    /// when the type is multiple, you should use this
    debugPrint('All selected item = ${selectedListItem.map((e) => e?.city)}');
  },
)
```

# Additional information

Thank you.
Hope this package can help you.
Happy coding..