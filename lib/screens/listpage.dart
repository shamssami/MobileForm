import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form/screens/editpage.dart';

import '../models/employees.dart';
import '../services/firebase_crud.dart';
import 'addpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<ListPage> {
  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readEmployee();
  //FirebaseFirestore.instance.collection('Employee').snapshots();
  TextEditingController _searchController = TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  @override
  void initState() {
    print("((((((((((((((((((((((((((((((((((((((&&&&&&&&&&&");
    getData();
    super.initState();
    _searchController.addListener(_onSearchChanged);
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getData();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text.isNotEmpty) {
      for (int i = 0; i < _allResults.length; i++) {
        String title = _allResults[i]["employee_name"].toLowerCase();
        String position = _allResults[i]["position"].toLowerCase();
        String id = _allResults[i]["contact_no"];

        print(title);
        print(title.contains(_searchController.text.toLowerCase()));

        if (title.contains(_searchController.text.toLowerCase()) ||
            position.contains(_searchController.text.toLowerCase()) ||
            id.contains(_searchController.text.toLowerCase())) {
          // showResults.add(_allResults[i]["employee_name"].toLowerCase());
          showResults.add(_allResults[i]);

          print(showResults[0]);
          print(title);
        }
      }
    } else {
      showResults = List.from(_allResults);
      print(showResults[0]['employee_name']);
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    }
    setState(() {
      _resultsList = showResults;
      // print(_resultsList[0]['employee_name']);
      // print(showResults[0]['employee_name']);
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    });
  }

  getData() async {
    var data = await FirebaseFirestore.instance.collection('users').get();

    setState(() {
      _allResults = data.docs;
    });
    print('-----------------------------------------------');
    print(_allResults[0]['employee_name']);
    searchResultsList();
    return "complete";
  }

  bool isShowUsers = false;

  //////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Form(
            child: TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(
                  labelText: 'Search',
                  icon: Icon(Icons.search, color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
              onFieldSubmitted: (String _) {
                setState(() {
                  isShowUsers = true;
                });
                print(_);
              },
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => AddPage(),
                  ),
                  (route) =>
                      false, //if you want to disable back feature set to false
                );
              },
            )
          ],
        ),
        body: ListView.builder(
          itemCount: _resultsList.length,
          itemBuilder: (context, index) {
            return Expanded(
                child: Card(
                    child: Column(children: [
              ListTile(
                title: Text(_resultsList[index]["employee_name"]),
                subtitle: Container(
                  child: (Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_resultsList[index]["position"],
                          style: const TextStyle(fontSize: 14)),
                      Text(_resultsList[index]["contact_no"],
                          style: const TextStyle(fontSize: 12)),
                    ],
                  )),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(5.0),
                      primary: const Color.fromARGB(255, 143, 133, 226),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Edit'),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => EditPage(
                            employee: Employee(
                              uid: _resultsList[index].id,
                              employeename: _resultsList[index]
                                  ['employee_name'],
                              position: _resultsList[index]['position'],
                              id_no: _resultsList[index]['contact_no'],
                            ),
                          ),
                        ),
                        (route) =>
                            false, //if you want to disable back feature set to false
                      );
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(5.0),
                      primary: const Color.fromARGB(255, 143, 133, 226),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Delete'),
                    onPressed: () async {
                      var response = await FirebaseCrud.deleteEmployee(
                          docId: _resultsList[index].id);
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
                                content: Text('Deleted Successfully!'),
                              );
                            });
                      }
                    },
                  ),
                ],
              ),
            ])));
          },
        ));
  }
}
