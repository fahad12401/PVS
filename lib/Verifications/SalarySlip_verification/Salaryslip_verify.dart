import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../Database/Database_Helper.dart';
import '../../Module for Get Data/Inquires_response.dart';
import '../../Screens/PreviewImage.dart';
import '../../Screens/assigned_inq_screen.dart';
import '../../Widgets/Card_Widgets/Salary_CustomCard.dart';
import '../../Widgets/Dialogbox.dart';
import '../../Widgets/Gps_Widgets/GPS.dart';
import '../../Widgets/Gps_Widgets/gps_loc.dart';
import '../../Widgets/InquiryTypes.dart';
import '../../Widgets/Inquiry_status.dart';
import '../../Widgets/Logs/Logeger.dart';

class SalaryVerification extends StatefulWidget {
  SalaryVerification(
      {super.key,
      this.salaryslipverify,
      required this.NameofPerson,
      required this.NameofOffice,
      required this.landmark,
      required this.typeofPerson,
      required this.AddressofOffice,
      required this.salaryverID,
      required this.inQID});
  final List<SalarySlipVerifications>? salaryslipverify;
  final String NameofPerson;
  final String NameofOffice;
  final String landmark;
  final String typeofPerson;
  final String AddressofOffice;
  final int salaryverID;
  final int inQID;

  @override
  State<SalaryVerification> createState() => _SalaryVerificationState();
}

class _SalaryVerificationState extends State<SalaryVerification> {
  GlobalKey<FormState> _salarySlipformKey = GlobalKey<FormState>();
  TextEditingController slipCommentcontroller = TextEditingController();
  String slipselectedoption = '';
  List<File> SalaryImage = [];
  String Verificationtype = InquiryTypes.SalarySlipSlipVerification;
  Future<void> CaptureSalaryImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 480,
          maxWidth: 640);
      if (image == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewImage(
                      verifyID: widget.salaryverID,
                      subVertype: Verificationtype,
                      inquiryid: widget.inQID,
                      Persntype: widget.typeofPerson,
                      Vtype: Verificationtype,
                      capimages: SalaryImage,
                    )));
        MyDialog.show(context, 'Kindly Take Photo');
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      } else {
        setState(() {
          SalaryImage = [File(image.path)];
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewImage(
                      verifyID: widget.salaryverID,
                      subVertype: Verificationtype,
                      inquiryid: widget.inQID,
                      Persntype: widget.typeofPerson,
                      Vtype: Verificationtype,
                      capimages: SalaryImage,
                    )));
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on CaptureSalaryImage SalaryVerification: ${e.toString()}");
    }
  }

  saveSalaryData() async {
    try {
      final DateTime now = DateTime.now();
      String dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      await DBHelper.updateSalarydb(
          widget.salaryverID,
          slipCommentcontroller.text.toString(),
          slipselectedoption.toString(),
          [Salarylongtitude, SalaryLatitude],
          InquiryStatus.PartialCompleted,
          dateFormat);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on saveSalaryData SalaryVerification: ${e.toString()}");
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
                            InquiryID: widget.inQID,
                          )));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Color(0xff392850),
        title: Text(
          "Salary Slip Verification (${widget.typeofPerson})",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Calibri',
              fontSize: 20.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SalarySlip_CustomCard(
                NameofPerson: widget.NameofPerson,
                NameofOffice: widget.NameofOffice,
                landmark: widget.landmark,
                typeofPerson: widget.typeofPerson,
                AddressofOffice: widget.AddressofOffice),
            Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
              child: Form(
                key: _salarySlipformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text("Comments:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 24.0,
                            fontFamily: 'Calibri')),
                    TextFormField(
                      controller: slipCommentcontroller,
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
                      maxLines: 5,
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
                    RadioListTile<String>(
                        activeColor: Color(0xff392850),
                        value: "Satisfactory",
                        title: const Text(
                          "Satisfactory",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Calibri',
                              fontSize: 18.0),
                        ),
                        groupValue: slipselectedoption,
                        onChanged: (value) {
                          setState(() {
                            slipselectedoption = value!;
                          });
                        }),
                    SizedBox(height: 1.0),
                    RadioListTile<String>(
                        activeColor: Color(0xff392850),
                        value: "Unsatisfactory",
                        title: const Text(
                          "Unsatisfactory",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Calibri',
                              fontSize: 18.0),
                        ),
                        groupValue: slipselectedoption,
                        onChanged: (value) {
                          setState(() {
                            slipselectedoption = value!;
                          });
                        }),
                    GPSLocation()
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            const Divider(),
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
                                      InquiryID: widget.inQID,
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
                          SalaryLatitude = lat;
                          Salarylongtitude = long;
                          if (_salarySlipformKey.currentState!.validate() &&
                              slipselectedoption.isNotEmpty &&
                              SalaryLatitude!.isNotEmpty &&
                              Salarylongtitude!.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return finalDialog(
                                      context,
                                      "All Fields are Completed!",
                                      "Do you want to save it?",
                                      "Take Photo", () async {
                                    saveSalaryData();
                                    await DBHelper.updatSalaryStatus(
                                        widget.inQID);
                                    await DBHelper.updateInquiryTableStatus(
                                        widget.inQID);

                                    CaptureSalaryImage();
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
                              "Exception on SalaryVerification: ${e.toString()}");
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
