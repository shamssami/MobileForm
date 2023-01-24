import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('users');

class FirebaseCrud {
//CRUD method here

// CREATE employee record

  static Future<Response> addEmployee({
    required String name,
    required String position,
    required String contactno,
    required String city,
    required String area,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "employee_name": name,
      "position": position,
      "contact_no": contactno,
      "city": city,
      "area": area
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
  ////////////////////////////////
  ///
  // Read employee records

  static Stream<QuerySnapshot> readEmployee() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }
////////////////////////////////////
  ///Update employee record

  static Future<Response> updateEmployee({
    required String name,
    required String position,
    required String contactno,
    required String city,
    required String area,
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "employee_name": name,
      "position": position,
      "contact_no": contactno,
      "city": city,
      "area": area
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully updated Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
  //////////////////////
  ///Delete Employee record

  static Future<Response> deleteEmployee({
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully Deleted Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}
