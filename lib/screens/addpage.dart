import 'package:flutter/material.dart';
import 'package:flutter_form/screens/listpage.dart';

import '../services/firebase_crud.dart';

class AddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPage();
  }
}

class _AddPage extends State<AddPage> {
  final _employee_name = TextEditingController();
  final _employee_position = TextEditingController();
  final _employee_contact = TextEditingController();
  final _employee_city = TextEditingController();
  final _employee_area = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
        controller: _employee_name,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final positionField = TextFormField(
        controller: _employee_position,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Position",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final contactField = TextFormField(
        controller: _employee_contact,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          } else if (value.length < 6) {
            return 'The length of id no shall be more than 6';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "ID Number",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

////////////////////////////////
    final List<String> cities = ['Bethlehem', 'Jerusalem', 'Hebron'];
    String? _currentCity = cities[0];

    final cityField = DropdownButtonFormField(
        value: _currentCity!.isNotEmpty ? _currentCity : null,
        items: cities.map((sugar) {
          return DropdownMenuItem(
            value: sugar,
            child: Text('$sugar cities'),
          );
        }).toList(),
        onChanged: (val) => setState(() {
              // print(val);
              _currentCity = val;
            }));

    ////////////////////////////////
    final List<String> areas = ['Tuqu', 'Halhoul', 'Janata'];
    String? _currentArea = areas[0];

    final areaField = DropdownButtonFormField(
        value: _currentArea!.isNotEmpty ? _currentArea : null,
        items: areas.map((sugar) {
          return DropdownMenuItem(
            value: sugar,
            child: Text('$sugar cities'),
          );
        }).toList(),
        onChanged: (val) => setState(() {
              // print(val);
              _currentArea = val;
            }));
////////////////////////////
    final viewListbutton = TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ListPage(),
            ),
            (route) => false, //To disable back feature set to false
          );
        },
        child: const Text('View List of Employee'));

    final SaveButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var response = await FirebaseCrud.addEmployee(
                name: _employee_name.text,
                position: _employee_position.text,
                contactno: _employee_contact.text,
                city: _employee_city.text,
                area: _employee_area.text);
            if (response.code != 200) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            }
          }
        },
        child: Text(
          "Save",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Flutter Form'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  nameField,
                  const SizedBox(height: 25.0),
                  positionField,
                  const SizedBox(height: 35.0),
                  contactField,
                  const SizedBox(height: 35.0),
                  cityField,
                  const SizedBox(height: 35.0),
                  areaField,
                  const SizedBox(height: 35.0),
                  viewListbutton,
                  const SizedBox(height: 45.0),
                  SaveButon,
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
