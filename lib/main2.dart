import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff11b719),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
///////////////////////////////////////////////
  String _selectedCountry = "India";
  var country = {
    'India': 'IN',
    'Pakistan': 'PAK',
    'Nepal': 'NP',
    'Bangladesh': 'BD'
  };

  List _countries = [];
  CountryDependentDropDown() {
    country.forEach((key, value) {
      _countries.add(key);
    });
  }

  String _selectedState = "";
  var state = {
    'Jharkhand': 'IN',
    'Panjab': 'IN',
    'Baluchistan': 'PAK',
    'Dhaka': 'BD',
    'Janakpur': 'NP'
  };

  List _states = [];
  StateDependentDropDown(countryShortName) {
    state.forEach((key, value) {
      if (countryShortName == value) {
        _states.add(key);
      }
    });
    _selectedState = _states[0];
  }

  String _selectedCity = "";
  var city = {
    'Ranchi': 'Jharkhand',
    'Tata': 'Jharkhand',
    'Quetta': 'Baluchistan',
    'Ludhiana': 'Panjab',
    'Amritsar': 'Panjab'
  };

  List _cities = [];
  CityDependentDropDown(stateShortName) {
    city.forEach((key, value) {
      if (stateShortName == value) {
        _cities.add(key);
      }
    });
    _selectedCity = _cities[0];
  }

///////////////////////////////////

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
  List<String> _accountType = <String>[
    'Savings',
    'Deposit',
    'Checking',
    'Brokerage'
  ];
  List<DropdownMenuItem> temp = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKeyValue,
      autovalidateMode: AutovalidateMode.always,
      // ignore: unnecessary_new
      child: new ListView(
        padding: const EdgeInsets.all(80),
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("cities").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  const Text("Loading.....");
                else {
                  // List<DropdownMenuItem> currencyItems = [];
                  // List<DropdownMenuItem> townsItems = [];
                  // List<DropdownMenuItem> cityItems = [];
                  // for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  //   DocumentSnapshot snap = snapshot.data!.docs[i];
                  //   currencyItems.add(
                  //     DropdownMenuItem(
                  //       child: Text(
                  //         snap.id,
                  //         style: TextStyle(color: Color(0xff11b719)),
                  //       ),
                  //       value: "${snap.id}",
                  //     ),
                  //   );
                  //   townsItems.add(
                  //     DropdownMenuItem(
                  //       child: Text(
                  //         snap.id[0],
                  //         style: TextStyle(color: Color(0xff11b719)),
                  //       ),
                  //       value: "${snap.id[0]}",
                  //     ),
                  //   );
                  // }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 50.0),

                      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                      DropdownButton(
                        items: cityItems,
                        onChanged: (Value) {
                          temp = [];
                          final snackBar = SnackBar(
                            content: Text(
                              'Selected City value is $Value',
                              style: TextStyle(color: Color(0xff11b719)),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          setState(() {
                            //
                            selectedCurrency = Value;
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
                        isExpanded: false,
                        hint: const Text(
                          "Choose City",
                          style: TextStyle(color: Color(0xff11b719)),
                        ),
                      ),
                      const SizedBox(
                        height: 100.0,
                      ),
                      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                      /// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                      DropdownButton(
                        items: temp,
                        onChanged: (townsValue) {
                          final snackBar = SnackBar(
                            content: Text(
                              'Selected Area value is $townsValue',
                              style: TextStyle(color: Color(0xff11b719)),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          setState(() {
                            selectedTown = townsValue;
                          });
                        },
                        value: selectedTown,
                        isExpanded: false,
                        hint: const Text(
                          "Choose Area Type",
                          style: TextStyle(color: Color(0xff11b719)),
                        ),
                      ),
                      /////////////////
                    ],
                  );
                }
                return Container();
              }),
        ],
      ),
    ));
  }
}
