import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter_form/users_page.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.

  final _formKey = GlobalKey<FormState>();
  List<dynamic> countries = [];
  String? countryId;
  List<dynamic> states = [];

  List<dynamic> stateMasters = [];
  String? stateId;
  @override
  void initState() {
    super.initState();
    this.countries.add({"id": 1, "name": "Bethlehem"});
    this.countries.add({"id": 2, "name": "Hebron"});
    // this.countries.add({"ID": 3, "Name": "Jerusalem"});

    this.stateMasters = [
      {"ID": 1, "Name": "Tuqu", "ParentId": 1},
      {"ID": 2, "Name": "Beit-Sahour", "ParentId": 1},
      {"ID": 3, "Name": "Abu Deis", "ParentId": 2},
      {"ID": 4, "Name": "Halhol", "ParentId": 2},
    ];
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    const TextStyle optionStyle =
        TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    const List<Widget> _widgetOptions = <Widget>[
      ViewAll(),
      Text(
        'Index 1: Business',
        style: optionStyle,
      ),
      Text(
        'Index 2: School',
        style: optionStyle,
      ),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  // decoration: const InputDecoration(

                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //add prefix icon
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.grey,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,
                    hintText: "username",
                  ),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter valid name';
                    } else if (value.length < 5) {
                      return 'Please enter 5 chars';
                    }
                    return null;
                  },
                ),
                ////////////////////////////////////////
                // FormHelper.dropDownWidget(
                //     context, "Select City", this.countryId, this.countries,
                //     (onChangedVal) {
                //   this.countryId = onChangedVal;
                //   this.states = this
                //       .stateMasters
                //       .where((stateItem) =>
                //           stateItem["ParentId"].toString() ==
                //           onChangedVal.toString())
                //       .toList();
                //   this.stateId = null;
                //   setState(() {});
                // }, (onValidateVal) {
                //   if (onValidateVal == null) {
                //     return "Please Select City";
                //   }
                //   return null;
                // },
                //     // optionValue: "id",
                //     // optionLabel: "name",
                //     borderRadius: 10,
                //     borderColor: Theme.of(context).primaryColor,
                //     borderFocusColor: Theme.of(context).primaryColor),
                // 2222//////////////////////////////////////////////////////////////////
                // FormHelper.dropDownWidget(
                //   context,
                //   "Select Area",
                //   this.stateId,
                //   this.states,
                //   (onChangedVal) {
                //     this.stateId = onChangedVal;
                //   },
                //   (onValidate) {
                //     return null;
                //   },
                //   borderRadius: 10,
                //   borderColor: Theme.of(context).primaryColor,
                //   borderFocusColor: Theme.of(context).primaryColor,
                //   optionValue: "ID",
                //   optionLabel: "Name",
                // ),

                ///////////////////////////////////////////////

                TextFormField(
                  // decoration: const InputDecoration(

                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //add prefix icon
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.grey,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,
                    hintText: "Email/Mobile",
                  ),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter valid phone number';
                    } else if (value.length < 5) {
                      return 'Please enter 5 chars';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  // decoration: const InputDecoration(

                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //add prefix icon
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.grey,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,
                    hintText: "Age",
                  ),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter valid number';
                    } else if (value.length < 5) {
                      return 'Please enter 5 chars';
                    }
                    return null;
                  },
                ),
                Column(
                  children: [
                    //////////////////////////////////////
                    FormHelper.dropDownWidget(
                        context, "Select City", this.countryId, this.countries,
                        (onChangedVal) {
                      this.countryId = onChangedVal;
                      this.states = this
                          .stateMasters
                          .where((stateItem) =>
                              stateItem["ParentId"].toString() ==
                              onChangedVal.toString())
                          .toList();
                      this.stateId = null;
                      setState(() {
                        this.stateId = onChangedVal;
                      });
                    }, (onValidateVal) {
                      if (onValidateVal == null) {
                        return "Please Select City";
                      }
                      return null;
                    },
                        // optionValue: "id",
                        // optionLabel: "name",
                        borderRadius: 10,
                        borderColor: Theme.of(context).primaryColor,
                        borderFocusColor: Theme.of(context).primaryColor),
                    FormHelper.dropDownWidget(
                      context,
                      "Select Area",
                      this.stateId,
                      this.states,
                      (onChangedVal) {
                        this.stateId = onChangedVal;
                      },
                      (onValidate) {
                        return null;
                      },
                      borderRadius: 10,
                      borderColor: Theme.of(context).primaryColor,
                      borderFocusColor: Theme.of(context).primaryColor,
                      optionValue: "ID",
                      optionLabel: "Name",
                    ),
                  ],
                ),

                ///print newly selected country state and city in Text Widget

                Container(
                    padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                    child: ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        // It returns true if the form is valid, otherwise returns false
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Data is in processing.')));
                          print('submitted successfully!');
                        }
                      },
                    )),
              ],
            ),
          )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Update',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
