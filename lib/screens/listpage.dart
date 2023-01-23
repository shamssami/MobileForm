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
  Widget customSearchBar = const Text('My Personal Journal');
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  @override
  void initState() {
    print("((((((((((((((((((((((((((((((((((((((&&&&&&&&&&&");
    getData();
    super.initState();
    _searchController.addListener(_onSearchChanged);
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

    if (_searchController.text != "") {
      for (var usersSnapshot in _allResults) {
        var title =
            Employee.fromSnapshot(usersSnapshot).employeename!.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(usersSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getData() async {
    var data = await FirebaseFirestore.instance.collection('users').get();

    print(data);
    print("********************************************");
    setState(() {
      _allResults = data.docs;
    });
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
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'employee_name',
                      isEqualTo: _searchController.text,
                    )
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: Column(children: [
                        ListTile(
                          title: Text(
                            (snapshot.data! as dynamic).docs[index]
                                ['employee_name'],
                          ),
                          subtitle: Container(
                            child: (Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "Position: " +
                                        (snapshot.data! as dynamic).docs[index]
                                            ['position'],
                                    style: const TextStyle(fontSize: 14)),
                                Text(
                                    "ID Number: " +
                                        (snapshot.data! as dynamic).docs[index]
                                            ['contact_no'],
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
                                primary:
                                    const Color.fromARGB(255, 143, 133, 226),
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
                                        employeename:
                                            (snapshot.data! as dynamic)
                                                .docs[index]['employee_name'],
                                        position: (snapshot.data! as dynamic)
                                            .docs[index]['position'],
                                        id_no: (snapshot.data! as dynamic)
                                            .docs[index]['contact_no'],
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
                                primary:
                                    const Color.fromARGB(255, 143, 133, 226),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text('Delete'),
                              onPressed: () async {
                                var response =
                                    await FirebaseCrud.deleteEmployee(
                                        docId: _resultsList[index].id);
                                if (response.code != 200) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content:
                                              Text(response.message.toString()),
                                        );
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content:
                                              Text('Deleted Successfully!'),
                                        );
                                      });
                                }
                              },
                            ),
                          ],
                        ),
                      ]));
                    },
                  );
                },
              )
            ///////////////////////////////////  ///////////////
            : FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'employee_name',
                      isGreaterThanOrEqualTo: _searchController.text,
                    )
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: Column(children: [
                        ListTile(
                          title: Text(
                            (snapshot.data! as dynamic).docs[index]
                                ['employee_name'],
                          ),
                          subtitle: Container(
                            child: (Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "Position: " +
                                        (snapshot.data! as dynamic).docs[index]
                                            ['position'],
                                    style: const TextStyle(fontSize: 14)),
                                Text(
                                    "ID Number: " +
                                        (snapshot.data! as dynamic).docs[index]
                                            ['contact_no'],
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
                                primary:
                                    const Color.fromARGB(255, 143, 133, 226),
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
                                        employeename:
                                            (snapshot.data! as dynamic)
                                                .docs[index]['employee_name'],
                                        position: (snapshot.data! as dynamic)
                                            .docs[index]['position'],
                                        id_no: (snapshot.data! as dynamic)
                                            .docs[index]['contact_no'],
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
                                primary:
                                    const Color.fromARGB(255, 143, 133, 226),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text('Delete'),
                              onPressed: () async {
                                var response =
                                    await FirebaseCrud.deleteEmployee(
                                        docId: _resultsList[index].id);
                                if (response.code != 200) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content:
                                              Text(response.message.toString()),
                                        );
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content:
                                              Text('Deleted Successfully!'),
                                        );
                                      });
                                }
                              },
                            ),
                          ],
                        ),
                      ]));
                    },
                  );
                },
              ));
    // return Scaffold(
    //     resizeToAvoidBottomInset: false,
    //     appBar: AppBar(
    //       title: Text("customSearchBar"),
    //       automaticallyImplyLeading: false,
    //       actions: [],
    //       // centerTitle: true,
    //     ),
    //     body: Column(children: [
    //       Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    //         child: TextField(
    //           controller: _searchController,
    //           decoration: InputDecoration(
    //             border: OutlineInputBorder(),
    //             hintText: 'Enter a search term',
    //           ),
    //         ),
    //       ),

    //       Expanded(
    //           //     if (snapshot.hasData) {

    //           child: ListView.builder(
    //               itemCount: _allResults.length,
    //               itemBuilder: (context, index) => Card(
    //                       child: Column(children: [
    //                     ListTile(
    //                       title: Text('${_allResults[index]['employee_name']}'),
    //                       subtitle: Container(
    //                         child: (Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: <Widget>[
    //                             Text("Position: " + 'ssss',
    //                                 style: const TextStyle(fontSize: 14)),
    //                             Text("Contact Number: " + 'sss',
    //                                 style: const TextStyle(fontSize: 12)),
    //                           ],
    //                         )),
    //                       ),
    //                     ),
    //                     ButtonBar(
    //                       alignment: MainAxisAlignment.spaceBetween,
    //                       children: <Widget>[
    //                         TextButton(
    //                           style: TextButton.styleFrom(
    //                             padding: const EdgeInsets.all(5.0),
    //                             primary:
    //                                 const Color.fromARGB(255, 143, 133, 226),
    //                             textStyle: const TextStyle(fontSize: 20),
    //                           ),
    //                           child: const Text('Edit'),
    //                           onPressed: () {
    //                             Navigator.pushAndRemoveUntil<dynamic>(
    //                               context,
    //                               MaterialPageRoute<dynamic>(
    //                                 builder: (BuildContext context) => EditPage(
    //                                   employee: Employee(
    //                                       uid: _resultsList[index]["uid"],
    //                                       employeename: 'ssss',
    //                                       position: 'ssss',
    //                                       id_no: 'ssss'),
    //                                 ),
    //                               ),
    //                               (route) =>
    //                                   false, //if you want to disable back feature set to false
    //                             );
    //                           },
    //                         ),
    //                         TextButton(
    //                           style: TextButton.styleFrom(
    //                             padding: const EdgeInsets.all(5.0),
    //                             primary:
    //                                 const Color.fromARGB(255, 143, 133, 226),
    //                             textStyle: const TextStyle(fontSize: 20),
    //                           ),
    //                           child: const Text('Delete'),
    //                           onPressed: () async {
    //                             var response =
    //                                 await FirebaseCrud.deleteEmployee(
    //                                     docId: _resultsList[index].id);
    //                             if (response.code != 200) {
    //                               showDialog(
    //                                   context: context,
    //                                   builder: (context) {
    //                                     return AlertDialog(
    //                                       content:
    //                                           Text(response.message.toString()),
    //                                     );
    //                                   });
    //                             }
    //                           },
    //                         ),
    //                       ],
    //                     ),
    //                   ])))
    //           // ?Container(child:Text("In the name of Allah")))
    //           // Expanded(
    //           //     child: StreamBuilder(
    //           //   stream: collectionReference,
    //           //   builder:
    //           //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //           //     if (snapshot.hasData) {
    //           //       return Padding(
    //           //         padding: const EdgeInsets.only(top: 8.0),
    //           //         child: ListView(
    //           //           children: snapshot.data!.docs.map((e) {
    //           //             return e.data == null
    //           //                 ? Card(
    //           //                     child: Column(children: [
    //           //                     ListTile(
    //           //                       title: Text(e["employee_name"] ?? "Loading"),
    //           //                       subtitle: Container(
    //           //                         child: (Column(
    //           //                           crossAxisAlignment:
    //           //                               CrossAxisAlignment.start,
    //           //                           children: <Widget>[
    //           //                             Text(
    //           //                                 "Position: " + e['position'] ??
    //           //                                     "Loading",
    //           //                                 style: const TextStyle(fontSize: 14)),
    //           //                             Text(
    //           //                                 "Contact Number: " +
    //           //                                         e['id_no'] ??
    //           //                                     "Loading",
    //           //                                 style: const TextStyle(fontSize: 12)),
    //           //                           ],
    //           //                         )),
    //           //                       ),
    //           //                     ),
    //           //                     ButtonBar(
    //           //                       alignment: MainAxisAlignment.spaceBetween,
    //           //                       children: <Widget>[
    //           //                         TextButton(
    //           //                           style: TextButton.styleFrom(
    //           //                             padding: const EdgeInsets.all(5.0),
    //           //                             primary: const Color.fromARGB(
    //           //                                 255, 143, 133, 226),
    //           //                             textStyle: const TextStyle(fontSize: 20),
    //           //                           ),
    //           //                           child: const Text('Edit'),
    //           //                           onPressed: () {
    //           //                             Navigator.pushAndRemoveUntil<dynamic>(
    //           //                               context,
    //           //                               MaterialPageRoute<dynamic>(
    //           //                                 builder: (BuildContext context) =>
    //           //                                     EditPage(
    //           //                                   employee: Employee(
    //           //                                       uid: e.id,
    //           //                                       employeename:
    //           //                                           e["employee_name"],
    //           //                                       position: e["position"],
    //           //                                       id_no: e["id_no"]),
    //           //                                 ),
    //           //                               ),
    //           //                               (route) =>
    //           //                                   false, //if you want to disable back feature set to false
    //           //                             );
    //           //                           },
    //           //                         ),
    //           //                         TextButton(
    //           //                           style: TextButton.styleFrom(
    //           //                             padding: const EdgeInsets.all(5.0),
    //           //                             primary: const Color.fromARGB(
    //           //                                 255, 143, 133, 226),
    //           //                             textStyle: const TextStyle(fontSize: 20),
    //           //                           ),
    //           //                           child: const Text('Delete'),
    //           //                           onPressed: () async {
    //           //                             var response =
    //           //                                 await FirebaseCrud.deleteEmployee(
    //           //                                     docId: e.id);
    //           //                             if (response.code != 200) {
    //           //                               showDialog(
    //           //                                   context: context,
    //           //                                   builder: (context) {
    //           //                                     return AlertDialog(
    //           //                                       content: Text(response.message
    //           //                                           .toString()),
    //           //                                     );
    //           //                                   });
    //           //                             }
    //           //                           },
    //           //                         ),
    //           //                       ],
    //           //                     ),
    //           //                   ]))
    //           //                 : Container(child: Text("Ya Allah"));
    //           //           }).toList(),
    //           //         ),
    //           //       );
    //           //     }

    //           //     return Container(child: Text("Ya Allah"));
    //           //   },
    //           // )
    //           ) // ),
    //     ]));
  }
}
