import 'package:cloud_firestore/cloud_firestore.dart';
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
//***************************************************************************************
//***************************************************************************************

  List _allCities = [];
  List areasList = [];
  List beth = [];
  List hebron = [];
  List jerusalem = [];
  List nablus = [];
  List gaza = [];

  List<DropdownMenuItem> cityItems = [];
  List<DropdownMenuItem> areasItems = [];
  List<DropdownMenuItem> bethItems = [];
  List<DropdownMenuItem> hebronItems = [];
  List<DropdownMenuItem> jerusalemItems = [];
  List<DropdownMenuItem> nablusItems = [];
  List<DropdownMenuItem> gazaItems = [];
  var selectedCurrency = null, selectedType, selectedTown;

  getdata() async {
    var ref = await FirebaseFirestore.instance.collection('cities').get();
    setState(() {
      _allCities = ref.docs;
      // selectedCurrency = _allCities[0].id;
      // selectedTown = _allCities[0]['areas'][0];

      for (int e = 0; e < _allCities.length; e++) {
        areasList.add(_allCities[e]['areas']);
        print(areasList[e]);
        print('---inside setstate--------------------------------------------');
        cityItems.add(
          DropdownMenuItem(
            value: "${_allCities[e].id}",
            child: Text(
              _allCities[e].id,
              style: const TextStyle(color: Color(0xff11b719)),
            ),
          ),
        );
        print(
            '***************areasList[e][e]***********************************');
      }

      for (int i = 0; i < _allCities.length; i++) {
        if (_allCities[i].id == "Bethlehem") {
          beth = areasList[i];

          for (int j = 0; j < beth.length; j++) {
            bethItems.add(
              DropdownMenuItem(
                value: "${beth[j]}",
                child: Text(
                  beth[j],
                  style: const TextStyle(color: Color(0xff11b719)),
                ),
              ),
            );
          }
          print(beth.toString());
          print('--------------------test1--------------');
        } else if (_allCities[i].id == "Gaza") {
          gaza = areasList[i];

          for (int j = 0; j < gaza.length; j++) {
            gazaItems.add(
              DropdownMenuItem(
                value: "${gaza[j]}",
                child: Text(
                  gaza[j],
                  style: const TextStyle(color: Color(0xff11b719)),
                ),
              ),
            );
          }
        } else if (_allCities[i].id == "Hebron") {
          hebron = areasList[i];

          for (int j = 0; j < hebron.length; j++) {
            hebronItems.add(
              DropdownMenuItem(
                value: "${hebron[j]}",
                child: Text(
                  hebron[j],
                  style: const TextStyle(color: Color(0xff11b719)),
                ),
              ),
            );
          }
        } else if (_allCities[i].id == "Jerusalem") {
          jerusalem = areasList[i];

          for (int j = 0; j < jerusalem.length; j++) {
            jerusalemItems.add(
              DropdownMenuItem(
                value: "${jerusalem[j]}",
                child: Text(
                  jerusalem[j],
                  style: const TextStyle(color: Color(0xff11b719)),
                ),
              ),
            );
          }
        } else if (_allCities[i].id == "Nablus") {
          nablus = areasList[i];

          for (int j = 0; j < nablus.length; j++) {
            nablusItems.add(
              DropdownMenuItem(
                value: "${nablus[j]}",
                child: Text(
                  nablus[j],
                  style: const TextStyle(color: Color(0xff11b719)),
                ),
              ),
            );
          }
        }
      }
    });
    print(
        '^^^^^^^^^^^^^^^^^^^^^^^^--##################---------------------------------');

    return "complete";
  }

//////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    getdata();

    // CountryDependentDropDown();
  }

  ////////////////////////////////////////////////////////

  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();

  List<DropdownMenuItem> temp = [];

  //***************************************************************************************
// *******************************************************************************
//***************************************************************************************
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
      items: cityItems,
      onChanged: (Value) {
        temp = [];
        final snackBar = SnackBar(
          backgroundColor: Color.fromARGB(255, 199, 180, 248),
          content: Text(
            'Selected City value is $Value',
            style: TextStyle(color: Color.fromARGB(255, 6, 6, 6)),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          //
          selectedCurrency = Value;
          _employee_city.text = selectedCurrency;
          if (selectedCurrency == "Bethlehem") {
            temp = bethItems;
            // selectedTown = temp[0];
          } else if (selectedCurrency == "Gaza") {
            temp = gazaItems;
            // selectedTown = temp[0];
          } else if (selectedCurrency == "Hebron") {
            temp = hebronItems;
            // selectedTown = temp[0];
          } else if (selectedCurrency == "Jerusalem") {
            temp = jerusalemItems;
            // selectedTown = temp[0];
          } else if (selectedCurrency == "Nablus") {
            temp = nablusItems;
            // selectedTown = temp[0];
          } else {
            temp = [];
          }
        });
      },
      value: selectedCurrency,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      isExpanded: false,
      hint: const Text(
        "Select City",
      ),
    );

    final areaField = DropdownButtonFormField(
      items: temp,
      dropdownColor: Color.fromARGB(221, 69, 68, 69),
      style: TextStyle(color: Color.fromARGB(255, 219, 216, 224)),
      onChanged: (townsValue) {
        final snackBar = SnackBar(
          backgroundColor: Color.fromARGB(255, 199, 180, 248),
          content: Text(
            'Selected Area value is $townsValue',
            style: TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          selectedTown = townsValue;
          _employee_area.text = selectedTown;
        });
      },
      value: selectedTown,
      isExpanded: true,
      hint: const Text(
        "Choose Area Type",
      ),
    );
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
    print('+++++++++++++++==');
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
