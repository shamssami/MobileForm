import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_form/users_page.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  /////////////////////////////
  // text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  String city = "";
  String village = "";

  final CollectionReference _userss =
      FirebaseFirestore.instance.collection('users');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
      _idController.text = documentSnapshot['id'].toString();
      _cityController.text = documentSnapshot['city'];
      _villageController.text = documentSnapshot['village'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'id',
                  ),
                ),
                SizedBox(
                  height: 20,
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
                        this.city = onChangedVal;
                      });
                    }, (onValidateVal) {
                      if (onValidateVal == null) {
                        return "Please Select City";
                      }
                      return null;
                    },
                        borderRadius: 10,
                        borderColor: Theme.of(context).primaryColor,
                        borderFocusColor: Theme.of(context).primaryColor),
                    SizedBox(
                      height: 20,
                    ),
                    FormHelper.dropDownWidget(
                      context,
                      "Select Area",
                      this.stateId,
                      this.states,
                      (onChangedVal) {
                        this.stateId = onChangedVal;
                        this.village = onChangedVal;
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
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? name = _nameController.text;
                    final double? id = double.tryParse(_idController.text);
                    if (name != null && id != null) {
                      if (action == 'create') {
                        // Persist a new user to Firestore
                        await _userss.add({"name": name, "id": id});
                      }

                      if (action == 'update') {
                        // Update the user
                        await _userss
                            .doc(documentSnapshot!.id)
                            .update({"name": name, "id": id});
                      }

                      // Clear the text fields
                      _nameController.text = '';
                      _idController.text = '';

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // Deleteing a user by id
  Future<void> _deleteProduct(String userId) async {
    await _userss.doc(userId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a user')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Users Form'),
          leading: IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ViewAll()));
            },
          )),
      // Using StreamBuilder to display all users from Firestore in real-time
      body: StreamBuilder(
        stream: _userss.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['id'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single user
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single user
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new user
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
