import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../Database/Database_Helper.dart';
import '../../Module for Get Data/Inquires_response.dart';
import '../../Screens/PreviewImage.dart';
import '../../Screens/assigned_inq_screen.dart';
import '../../Widgets/Card_Widgets/Bank_Customcard.dart';
import '../../Widgets/Dialogbox.dart';
import '../../Widgets/Gps_Widgets/GPS.dart';
import '../../Widgets/Gps_Widgets/gps_loc.dart';
import '../../Widgets/InquiryTypes.dart';
import '../../Widgets/Inquiry_status.dart';
import '../../Widgets/Logs/Logeger.dart';

class BankVerificationofStatment extends StatefulWidget {
  BankVerificationofStatment(
      {super.key,
      this.bankofficeverified,
      required this.NameOfBank,
      required this.NameOfPerson,
      required this.typeofPerson,
      required this.landmark,
      required this.bankverID,
      required this.InqID});
  final List<BankStatementVerifications>? bankofficeverified;
  final String NameOfBank;
  final String NameOfPerson;
  final String typeofPerson;
  final String landmark;
  final int bankverID;
  final int InqID;

  @override
  State<BankVerificationofStatment> createState() =>
      _BankVerificationofStatmentState();
}

class _BankVerificationofStatmentState
    extends State<BankVerificationofStatment> {
  GlobalKey<FormState> _BankformKey = GlobalKey<FormState>();
  TextEditingController commentcontroller = TextEditingController();
  String selectedoption = "";
  List<File> BankImage = [];
  String VerificationType = InquiryTypes.BankStatementVerification;
  bool locationUpdated = false;
  @override
  void dispose() {
    commentcontroller;
    super.dispose();
  }

  String Bankstatus = InquiryStatus.PartialCompleted;
  saveBankdata() async {
    try {
      final DateTime now = DateTime.now();
      String dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      await DBHelper.updateBankdb(
          widget.bankverID,
          commentcontroller.text.toString(),
          selectedoption.toString(),
          [Banklongtitude, Banklatitude],
          Bankstatus,
          dateFormat);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on saveBankData method BankVerificationofStatment: ${e.toString()}");
    }
  }

  Future<void> CaptureBankImage() async {
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
              builder: (context) => PopScope(
                    canPop: false,
                    onPopInvoked: (pop) {
                      pop = false;
                    },
                    child: PreviewImage(
                      Persntype: widget.typeofPerson,
                      capimages: BankImage,
                      Vtype: VerificationType.toString(),
                      inquiryid: widget.InqID,
                      verifyID: widget.bankverID,
                    ),
                  )),
        );
        MyDialog.show(context, 'Kindly Take Photo');
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      } else {
        setState(() {
          BankImage = [File(image.path)];
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PopScope(
                    canPop: true,
                    onPopInvoked: (didpop) {
                      if (didpop) {
                        Navigator.pop(context);
                      }
                    },
                    child: PreviewImage(
                      Persntype: widget.typeofPerson,
                      capimages: BankImage,
                      Vtype: VerificationType.toString(),
                      inquiryid: widget.InqID,
                      verifyID: widget.bankverID,
                    ),
                  )),
        );
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on CaptureBankImage method BankVerificationofStatment: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AssignedInquiries(
                          InquiryID: widget.InqID,
                        )));
          },
        ),
        centerTitle: true,
        backgroundColor: Color(0xff392850),
        title: Text(
          "Bank Statement Verification (${widget.typeofPerson})",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Calibri',
              fontSize: 20.0),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
        },
        child: SingleChildScrollView(
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Bank_CustomCard(
                    NameOfBank: widget.NameOfBank,
                    NameOfPerson: widget.NameOfPerson,
                    typeofPerson: widget.typeofPerson,
                    landmark: widget.landmark),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
                  child: Form(
                    key: _BankformKey,
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
                          controller: commentcontroller,
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
                            if (val == null ||
                                val.isEmpty ||
                                val.trim().isEmpty) {
                              return "Kindly fill the Field";
                            }
                            return null;
                          },
                          maxLines: 5,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Text("Outcome of Verification:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 24.0,
                                fontFamily: 'Calibri')),
                        Column(
                          children: <Widget>[
                            RadioListTile<String>(
                              activeColor: Color(0xff392850),
                              value: "Satisfactory",
                              title: Text(
                                "Satisfactory",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Calibri',
                                    fontSize: 18.0),
                              ),
                              groupValue: selectedoption,
                              onChanged: (value) {
                                setState(() {
                                  selectedoption = value!;
                                  print(value);
                                });
                              },
                            ),
                            const SizedBox(height: 1.0),
                            RadioListTile<String>(
                              activeColor: Color(0xff392850),
                              value: "Unsatisfactory",
                              title: Text(
                                "Unsatisfactory",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Calibri',
                                    fontSize: 18.0),
                              ),
                              groupValue: selectedoption,
                              onChanged: (value) {
                                setState(() {
                                  selectedoption = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 5.0,
                        ),
                        GPSLocation(),
                        const Divider()
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          height: 40.0,
                          width: 130.0,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
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
                          height: 50.0,
                          width: 130.0,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  backgroundColor: Color(0xff392850)),
                              onPressed: () {
                                try {
                                  Banklatitude = lat;
                                  Banklongtitude = long;
                                  if (_BankformKey.currentState!.validate() &&
                                      selectedoption.isNotEmpty &&
                                      Banklatitude!.isNotEmpty &&
                                      Banklongtitude!.isNotEmpty) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return finalDialog(
                                              context,
                                              "All Fields are Completed!",
                                              "Do you want to save it?",
                                              "Take Photo", () async {
                                            saveBankdata();
                                            await DBHelper.updateBankStatus(
                                                widget.InqID);
                                            await DBHelper
                                                .updateInquiryTableStatus(
                                                    widget.InqID);

                                            CaptureBankImage();
                                          });
                                        });
                                  } else {
                                    MyDialog.show(
                                        context, 'Kindly fill all fields');
                                    Future.delayed(Duration(seconds: 1), () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    });
                                  }
                                } on Exception catch (e) {
                                  EVSLogger.appendLog(
                                      "Exception on BankVerificationofStatment: ${e.toString()}");
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
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
