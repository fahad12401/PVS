import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

bool servicestatus = false;
bool haspermission = false;
late LocationPermission permission;
late Position position;
late StreamSubscription<Position> positionStream;
bool isdownloading = false;
String lat = '';
String long = '';
String? Banklongtitude;
String? Banklatitude;
String? Officelongtitude;
String? OfficeLatitude;
String? Salarylongtitude;
String? SalaryLatitude;
String? TenantLatitude;
String? TenantLongtitude;
String? Residencelongtitude;
String? Residencelatitude;

showalertdialog(BuildContext context, String text) {
  Widget okButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text("Ok"));
  AlertDialog alertDialog = AlertDialog(
    title: Text("Warning!"),
    content: Text(text),
    actions: [okButton],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}
