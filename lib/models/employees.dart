import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String? uid;
  String? employeename;
  String? position;
  String? contactno;

  Employee({this.uid, this.employeename, this.position, this.contactno});

  // formatting for upload to Firbase when creating the trip
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'employeename': employeename,
        'position': position,
        'contactno': contactno,
      };

  // creating a Trip object from a firebase snapshot
  Employee.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot['uid'],
        employeename = snapshot['employeename'],
        position = snapshot['position'],
        contactno = snapshot['contactno'];
}
