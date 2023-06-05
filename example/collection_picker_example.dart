import 'package:collection_picker/collection_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CollectionPickerExample(),
    );
  }
}

class CollectionPickerExample extends StatelessWidget {
  const CollectionPickerExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection Picker Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListViewPicker<CityModel>(
              type: PickerType.single,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separator: const Divider(thickness: 1, height: 16),
              initialValue: dataCity.first,
              data: dataCity,
              unavailableDataIndex: [3, 5],
              itemBuilder: (BuildContext context, int index,
                  PickerWrapper<CityModel> item) {
                return SizedBox(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.data?.city}'),
                      (!item.isAvailable)
                          ? const Text('Unavailable')
                          : (item.isSelected)
                              ? const Icon(Icons.check)
                              : const SizedBox.shrink()
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
            GridViewPicker(
              type: PickerType.multiple,
              shrinkWrap: true,
              initialValue: dataCity.first,
              data: dataCity,
              itemBuilder: (BuildContext context, int index,
                  PickerWrapper<CityModel> item) {
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
                    'All selected item = ${selectedListItem.map((e) => e?.city)}');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CityModel {
  String province;
  String city;

  CityModel(this.province, this.city);
}

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
