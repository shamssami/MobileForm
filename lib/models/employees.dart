import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String? uid;
  String? employeename;
  String? position;
  String? id_no;
  String? city;
  String? area;

  Employee(
      {this.uid,
      this.employeename,
      this.position,
      this.id_no,
      this.city,
      this.area});

  // formatting for upload to Firbase when creating the trip
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'employee_name': employeename,
        'position': position,
        'id_no': id_no,
        'city': city,
        'area': area,
      };

  Employee.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot['uid'],
        employeename = snapshot['employee_name'],
        position = snapshot['position'],
        city = snapshot['city'],
        area = snapshot['area'],
        id_no = snapshot['id_no'];
}
