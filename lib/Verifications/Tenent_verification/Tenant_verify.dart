import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pvs/Database/Database_Helper.dart';
import '../../Module for Get Data/Inquires_response.dart';
import '../../Screens/PreviewImage.dart';
import '../../Screens/assigned_inq_screen.dart';
import '../../Widgets/Card_Widgets/Tenant_CustomCard.dart';
import '../../Widgets/Dialogbox.dart';
import '../../Widgets/Gps_Widgets/GPS.dart';
import '../../Widgets/Gps_Widgets/gps_loc.dart';
import '../../Widgets/InquiryTypes.dart';
import '../../Widgets/Inquiry_status.dart';
import '../../Widgets/Logs/Logeger.dart';

class VerificationofTenant extends StatefulWidget {
  VerificationofTenant(
      {super.key,
      this.tenentverify,
      required this.NameofPerson,
      required this.typeofPerson,
      required this.AddressofTenant,
      required this.Landmark,
      required this.tenantverID,
      required this.InqID});
  final List<TenantVerifications>? tenentverify;
  final String NameofPerson;
  final String typeofPerson;
  final String AddressofTenant;
  final String Landmark;
  final int tenantverID;
  final int InqID;

  @override
  State<VerificationofTenant> createState() => _VerificationofTenantState();
}

class _VerificationofTenantState extends State<VerificationofTenant> {
  final _tenantnamecontroller = TextEditingController();
  final tenantcontactcontroller = TextEditingController();
  final tenantcncController = TextEditingController();
  final tenantPeriodcontroller = TextEditingController();
  final tenantRentcontroller = TextEditingController();
  final tenantCommentcontroller = TextEditingController();
  GlobalKey<FormState> _tenantformKey = GlobalKey<FormState>();
  String radioselectedoption = '';
  List<File> TenantImage = [];
  String verificationType = InquiryTypes.TenantVerification;
  Future<void> CaptureTenantImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 480,
          maxWidth: 640);
      if (image == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewImage(
                      subVertype: verificationType,
                      inquiryid: widget.InqID,
                      Persntype: widget.typeofPerson,
                      Vtype: verificationType,
                      capimages: null,
                      verifyID: widget.tenantverID,
                    )));
        MyDialog.show(context, 'Kindly Take Photo');
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      } else {
        setState(() {
          TenantImage = [File(image.path)];
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewImage(
                      subVertype: verificationType,
                      inquiryid: widget.InqID,
                      Persntype: widget.typeofPerson,
                      Vtype: verificationType,
                      capimages: TenantImage,
                      verifyID: widget.tenantverID,
                    )));
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on CaptureTenantImage VerificationofTenant: ${e.toString()}");
    }
  }

  String TenantStatus = InquiryStatus.PartialCompleted;
  saveTenantData() async {
    try {
      final DateTime now = DateTime.now();
      String dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      await DBHelper.updateTenantDb(
          widget.tenantverID,
          _tenantnamecontroller.text.toString(),
          tenantcontactcontroller.text.toString(),
          tenantcncController.text.toString(),
          tenantPeriodcontroller.text.toString(),
          tenantRentcontroller.text.toString(),
          tenantCommentcontroller.text.toString(),
          radioselectedoption.toString(),
          dateFormat,
          [TenantLatitude.toString(), TenantLongtitude.toString()],
          TenantStatus);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on saveTenantData VerificationofTenant: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AssignedInquiries(
                            InquiryID: widget.InqID,
                          )));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Color(0xff392850),
        title: Text(
          "Tenant Verification (${widget.typeofPerson})",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Calibri',
              fontSize: 20.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Tenant_Customcard(
                NameofPerson: widget.NameofPerson,
                typeofPerson: widget.typeofPerson,
                AddressofTenant: widget.AddressofTenant,
                Landmark: widget.Landmark),
            Padding(
              padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
              child: Form(
                key: _tenantformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Tenant Name:",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    TextFormField(
                      controller: _tenantnamecontroller,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Name Here.",
                          hintStyle: TextStyle(fontFamily: 'Calibri'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff392850), width: 2.0))),
                      validator: (val) {
                        if (val == null || val.isEmpty || val.trim().isEmpty) {
                          return "Kindly fill the Field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Divider(),
                    const Text(
                      "Tenant Contact No:",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    TextFormField(
                      controller: tenantcontactcontroller,
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Number Here.",
                          hintStyle: TextStyle(fontFamily: 'Calibri'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff392850), width: 2.0))),
                      validator: (val) {
                        if (val == null ||
                            val.isEmpty ||
                            val.length != 11 ||
                            val.trim().isEmpty) {
                          return "Kindly fill the Field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Divider(),
                    const Text(
                      "Tenant CNIC:",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    TextFormField(
                      controller: tenantcncController,
                      keyboardType: TextInputType.phone,
                      maxLength: 13,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter CNIC Here.",
                          hintStyle: TextStyle(fontFamily: 'Calibri'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff392850), width: 2.0))),
                      validator: (val) {
                        if (val == null ||
                            val.isEmpty ||
                            val.length != 13 ||
                            val.trim().isEmpty) {
                          return "Kindly fill the Field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Divider(),
                    const Text(
                      "Tenancy Period:",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    TextFormField(
                      controller: tenantPeriodcontroller,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Period Here.",
                          hintStyle: TextStyle(fontFamily: 'Calibri'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff392850), width: 2.0))),
                      validator: (val) {
                        if (val == null || val.isEmpty || val.trim().isEmpty) {
                          return "Kindly fill the Field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Divider(),
                    const Text(
                      "Tenant Rent:",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    TextFormField(
                      controller: tenantRentcontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Rent Here.",
                          hintStyle: TextStyle(fontFamily: 'Calibri'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff392850), width: 2.0))),
                      validator: (val) {
                        if (val == null || val.isEmpty || val.trim().isEmpty) {
                          return "Kindly fill the Field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Divider(),
                    const Text(
                      "General Comments:",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    TextFormField(
                      controller: tenantCommentcontroller,
                      maxLines: 5,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Comments Here.",
                          hintStyle: TextStyle(fontFamily: 'Calibri'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff392850), width: 2.0))),
                      validator: (val) {
                        if (val == null || val.isEmpty || val.trim().isEmpty) {
                          return "Kindly fill the Field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Divider(),
                    const Text("Outcome of Verification:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 24.0,
                            fontFamily: 'Calibri')),
                    RadioListTile(
                        activeColor: Color(0xff392850),
                        value: "Satisfactory",
                        title: const Text(
                          "Satisfactory",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Calibri',
                              fontSize: 18.0),
                        ),
                        groupValue: radioselectedoption,
                        onChanged: (value) {
                          setState(() {
                            radioselectedoption = value!;
                          });
                        }),
                    RadioListTile(
                        activeColor: Color(0xff392850),
                        value: "Unsatisfactory",
                        title: const Text(
                          "Unsatisfactory",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Calibri',
                              fontSize: 18.0),
                        ),
                        groupValue: radioselectedoption,
                        onChanged: (value) {
                          setState(() {
                            radioselectedoption = value!;
                          });
                        }),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(),
                    GPSLocation(),
                    const Divider(),
                    const SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  height: 40.0,
                  width: 120.0,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: Color(0xff392850)),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AssignedInquiries(
                                      InquiryID: widget.InqID,
                                    )));
                      },
                      child: const Text(
                        "Back",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Calibri',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  height: 40.0,
                  width: 120.0,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: Color(0xff392850)),
                      onPressed: () {
                        try {
                          TenantLatitude = lat;
                          TenantLongtitude = long;
                          if (_tenantformKey.currentState!.validate() &&
                              radioselectedoption.isNotEmpty &&
                              TenantLatitude!.isNotEmpty &&
                              TenantLongtitude!.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return finalDialog(
                                      context,
                                      "All Fields are Completed!",
                                      "Do you want to save it?",
                                      "Take Photo", () async {
                                    saveTenantData();
                                    await DBHelper.UpdateTenantInquiryStatus(
                                        widget.InqID);
                                    await DBHelper.updateInquiryTableStatus(
                                        widget.InqID);

                                    CaptureTenantImage();
                                  });
                                });
                          } else {
                            MyDialog.show(context, 'Kindly fill all fields');
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.of(context, rootNavigator: true).pop();
                            });
                          }
                        } on Exception catch (e) {
                          EVSLogger.appendLog(
                              "Exception on VerificationofTenant: ${e.toString()}");
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Calibri',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 3.0,
            )
          ],
        ),
      ),
    );
  }
}
