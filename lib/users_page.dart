import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dropdownfield/dropdownfield.dart';

class ViewAll extends StatefulWidget {
  const ViewAll({super.key});

  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  final List<String> items = List<String>.generate(10000, (i) => '$i');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          DropDownField(
              // value: formData['City'],
              // autovalidateMode: AutovalidateMode.always,
              // icon: Icon(Icons.location_city),
              // required: true,
              hintText: 'Choose a city',
              labelText: 'City *',
              enabled: true,
              itemsVisibleInDropdown: 4,
              items: cities,

              // strict: false,
              onValueChanged: (val) {
                setState(() {
                  selectCity = val;
                });
              }),
          Divider(height: 10.0, color: Theme.of(context).primaryColor),
          // DropDownField(
          //     value: formData['Country'],
          //     icon: Icon(Icons.map),
          //     required: false,
          //     hintText: 'Choose a country',
          //     labelText: 'Country',
          //     items: countries,
          //     setter: (dynamic newValue) {
          //       formData['Country'] = newValue;
          //     }),
        ],
      )),
    );
  }
}

List<String> cities = [
  'Bethlehem',
  'Hebron',
  'Jerusalem',
  'Gaza',
  'Ramallah',
  'Nablus',
];
String selectCity = "";
List<String> countries = [
  'Palestine',
  'Jordan',
  'JAPAN',
];
