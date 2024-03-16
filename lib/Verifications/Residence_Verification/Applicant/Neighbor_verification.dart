import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pvs/Verifications/Residence_Verification/Applicant/MainPage.dart';
import '../../../Database/Database_Helper.dart';
import '../../../Module For Post Data/Post_inquires_model..dart';
import '../../../Module for Get Data/Inquires_response.dart';
import '../../../Widgets/Card_Widgets/Residence_customcard.dart';
import '../../../Widgets/Dialogbox.dart';
import '../../../Widgets/InquiryTypes.dart';
import '../../../Widgets/Inquiry_status.dart';
import '../../../Widgets/Logs/Logeger.dart';

class ApplicantResidenceNeighbor extends StatefulWidget {
  ApplicantResidenceNeighbor(
      {super.key,
      this.ApplicantNeighbourVerified,
      required this.PersonType,
      required this.NameofPerson,
      required this.residenceAddress,
      required this.nearestLandmark,
      required this.resVerID,
      required this.Inquiryid});
  final List<ResidenceVerifications>? ApplicantNeighbourVerified;
  final String PersonType;
  final String NameofPerson;
  final String residenceAddress;
  final String nearestLandmark;
  final int resVerID;
  final int Inquiryid;
  @override
  State<ApplicantResidenceNeighbor> createState() =>
      _ApplicantResidenceNeighborState();
}

class _ApplicantResidenceNeighborState
    extends State<ApplicantResidenceNeighbor> {
  GlobalKey<FormState> _ApplicantNeighborformKey = GlobalKey<FormState>();
  final ApplicantNeighborNameController = TextEditingController();
  final ApplicantneighborAddressController = TextEditingController();
  final ApplicantneighborTimePeriodController = TextEditingController();
  final ApplicantneighborCommentController = TextEditingController();
  String ApplicantNeighborknowsvalue = "";
  File? ResidenceNeighborImage;
  String verType = InquiryTypes.ResidenceVerification;
  NeighbourCheck neighbour1Check = new NeighbourCheck();
  saveNeighborData() {
    try {
      NeighbourCheck neighbourCheckdata = NeighbourCheck(
          InquiryId: widget.Inquiryid,
          ResidenceVerificationId: widget.resVerID,
          NeighborName: ApplicantNeighborNameController.text.toString(),
          NeighborAddress: ApplicantneighborAddressController.text.toString(),
          KnowsApplicant: ApplicantNeighborknowsvalue.toString(),
          KnowsHowLong: ApplicantneighborTimePeriodController.text.toString(),
          NeighborComments: ApplicantneighborCommentController.text.toString());
      neighbour1Check = neighbourCheckdata;
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on saveNeighborData ApplicantResidenceNeighbor: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff392850),
        title: Text(
          "Neighbor Check (${widget.PersonType})",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Calibri',
              fontSize: 22.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Residence_CustomCard(
                TypeofPerson: widget.PersonType,
                Name: widget.NameofPerson,
                Address: widget.residenceAddress,
                Landmark: widget.nearestLandmark),
            Padding(
              padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
              child: Form(
                key: _ApplicantNeighborformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Neighbor's Name:",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    TextFormField(
                      controller: ApplicantNeighborNameController,
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
                    const Divider(),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text(
                      "Neighbor's Address:",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    TextFormField(
                      maxLines: 2,
                      controller: ApplicantneighborAddressController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Address Here.",
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
                    const Divider(),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Does Neighbor know the ${widget.PersonType} ?",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    ListTileTheme(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "true",
                                  title: const Text(
                                    "Yes",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantNeighborknowsvalue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantNeighborknowsvalue = value!;
                                    });
                                  }),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "false",
                                  title: const Text(
                                    "No",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantNeighborknowsvalue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantNeighborknowsvalue = value!;
                                    });
                                  }),
                            ),
                          ],
                        )),
                    TextFormField(
                      enabled: ApplicantNeighborknowsvalue == "true",
                      controller: ApplicantneighborTimePeriodController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Since How Long Neighbor knows",
                          hintStyle: TextStyle(fontFamily: 'Calibri'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff392850), width: 2.0))),
                      validator: (val) {
                        if (ApplicantNeighborknowsvalue == "true" &&
                            (val == null ||
                                val.isEmpty ||
                                val.trim().isEmpty)) {
                          return "Kindly fill the Field";
                        }
                        return null;
                      },
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Comments Regarding the ${widget.PersonType}:",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    TextFormField(
                      maxLines: 2,
                      controller: ApplicantneighborCommentController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Comment Here.",
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
                  ],
                ),
              ),
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
                        Navigator.pop(context);
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
                          if (_ApplicantNeighborformKey.currentState!
                                  .validate() &&
                              ApplicantNeighborknowsvalue.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return finalDialog(
                                      context,
                                      "All Fields are Completed!",
                                      "Do you want to save it?",
                                      "Save", () async {
                                    saveNeighborData();
                                    await DBHelper.createResidenceNeighbor(
                                        neighbour1Check);
                                    await DBHelper.updateResidenceStatus(
                                        InquiryStatus.PartialCompleted,
                                        widget.resVerID);
                                    await DBHelper.UpdateRInquiryStatus(
                                        widget.Inquiryid);
                                    await DBHelper.updateInquiryTableStatus(
                                        widget.Inquiryid);
                                    await DBHelper.updateResNeighborstatus(
                                        widget.resVerID,
                                        InquiryStatus.Completed);
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ApplicantResidenceverifiy(
                                                    PersonType:
                                                        widget.PersonType,
                                                    residenceAddress:
                                                        widget.residenceAddress,
                                                    nearestLandmark:
                                                        widget.nearestLandmark,
                                                    NameofPerson:
                                                        widget.NameofPerson,
                                                    verifucationID:
                                                        widget.resVerID,
                                                    InquiryId:
                                                        widget.Inquiryid)));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 3),
                                            backgroundColor: Colors.green,
                                            content: Text(
                                              "Successfully Saved!",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontFamily: 'Calibri'),
                                            )));
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
                              "Exception on ApplicantNeighbor_Verification: ${e.toString()}");
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
