import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String? uid;
  String? employeename;
  String? position;
  String? id_no;

  Employee({this.uid, this.employeename, this.position, this.id_no});

  // formatting for upload to Firbase when creating the trip
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'employeename': employeename,
        'position': position,
        'id_no': id_no,
      };

  // creating a Trip object from a firebase snapshot
  Employee.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot['uid'],
        employeename = snapshot['employeename'],
        position = snapshot['position'],
        id_no = snapshot['id_no'];
}
