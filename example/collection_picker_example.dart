import 'package:collection_picker/collection_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CollectionPickerExample());
  }
}

class CollectionPickerExample extends StatelessWidget {
  const CollectionPickerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Collection Picker Example')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListViewPicker<CityModel>(
              type: PickerType.single,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separator: (BuildContext context, int index) =>
                  const Divider(thickness: 1, height: 0),
              initialValue: dataCity.first,
              data: dataCity,
              unavailableDataIndex: [3, 5],
              itemBuilder: (
                BuildContext context,
                int index,
                PickerWrapper<CityModel> item,
              ) {
                return SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.data.city),
                      (!item.isAvailable)
                          ? const Text('Unavailable')
                          : (item.isSelected)
                              ? const Icon(Icons.check)
                              : const SizedBox.shrink(),
                    ],
                  ),
                );
              },
              onChanged: (context, index, selectedItem, selectedListItem) {
                // when the type is single/radio, you should use this
                debugPrint('Selected item = $selectedItem');

                /// when the type is multiple, you should use this
                debugPrint('All selected item = $selectedListItem');
              },
            ),
            GridViewPicker<CityModel>(
              type: PickerType.multiple,
              shrinkWrap: true,
              initialValue: dataCity.first,
              data: dataCity,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisExtent: 50,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (
                BuildContext context,
                int index,
                PickerWrapper<CityModel> item,
              ) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.data.city),
                      if (item.isSelected) const Icon(Icons.check),
                    ],
                  ),
                );
              },
              onChanged: (context, index, selectedItem, selectedListItem) {
                // when the type is single/radio, you should use this
                debugPrint('selected item = ${selectedItem?.city}');

                /// when the type is multiple, you should use this
                debugPrint(
                  'All selected item = ${selectedListItem.map((e) => e.city)}',
                );
              },
            ),
            WrapPicker<CityModel>(
              type: PickerType.multiple,
              initialValue: dataCity.first,
              data: dataCity,
              onChanged: (context, index, selectedItem, selectedListItem) {
                // when the type is single/radio, you should use this
                debugPrint('selected item = ${selectedItem?.city}');

                /// when the type is multiple, you should use this
                debugPrint(
                  'All selected item = ${selectedListItem.map((e) => e.city)}',
                );
              },
              itemBuilder: (context, index, item) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Wrap(
                    spacing: 4,
                    children: [
                      Text(item.data.city),
                      if (item.isSelected) const Icon(Icons.check, size: 18),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CityModel {
  final String province;
  final String city;

  const CityModel(this.province, this.city);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CityModel &&
        other.province == province &&
        other.city == city;
  }

  @override
  int get hashCode => province.hashCode ^ city.hashCode;

  @override
  String toString() => 'CityModel(province: $province, city: $city)';
}

List<CityModel> dataCity = [
  CityModel('Jakarta', 'Menteng'),
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
