import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pvs/Verifications/Office_Verification/Office_main.dart';

import '../../Database/Database_Helper.dart';
import '../../Module For Post Data/Post_inquires_model..dart';
import '../../Module for Get Data/Inquires_response.dart';
import '../../Widgets/Card_Widgets/Office_CustomCard.dart';
import '../../Widgets/Dialogbox.dart';
import '../../Widgets/InquiryTypes.dart';
import '../../Widgets/Inquiry_status.dart';
import '../../Widgets/Logs/Logeger.dart';

class OfficeNeighborVerification extends StatefulWidget {
  OfficeNeighborVerification(
      {super.key,
      this.workofficeverified,
      required this.NameofOffice,
      required this.AddressofOffice,
      required this.NameofPerson,
      required this.Landmark,
      required this.typeOfPerson,
      required this.officewrkid,
      required this.InqID});
  final List<WorkOfficeVerifications>? workofficeverified;
  final String NameofOffice;
  final String AddressofOffice;
  final String NameofPerson;
  final String Landmark;
  final String typeOfPerson;
  final int officewrkid;
  final int InqID;

  @override
  State<OfficeNeighborVerification> createState() =>
      _OfficeNeighborVerificationState();
}

class _OfficeNeighborVerificationState
    extends State<OfficeNeighborVerification> {
  GlobalKey<FormState> _OfficeNeighborformKey = GlobalKey<FormState>();
  final neighborNameController = TextEditingController();
  final neighborAddressController = TextEditingController();
  final knowledgeofNeighborController = TextEditingController();
  final commentController = TextEditingController();
  final establishedController = TextEditingController();
  String neighborKnowledgeValue = "";
  File? NeighborImage;
  String VerificationType = InquiryTypes.OfficeVerification;

  saveMarketCheckData() {
    try {
      MarketeCheck check = MarketeCheck(
          WorkOfficeVerificationId: widget.officewrkid,
          InquiryId: widget.InqID,
          NeighborsName: neighborNameController.text.toString(),
          NeighborsAddress: neighborAddressController.text.toString(),
          KnowsApplicant: neighborKnowledgeValue,
          KnowsHowint: knowledgeofNeighborController.text.toString(),
          BusinessEstablishedSinceMarketeCheck:
              establishedController.text.toString(),
          NeighborComments: commentController.text.toString());
      marketeCheck = check;
    } on Exception catch (e) {
      EVSLogger.appendLog(
          'Exception on saveMarketCheckData OfficeNeighborVerification : ${e.toString()}');
    }
  }

  saveSALARIEDdata() {
    MarketeCheck salariedMarket = MarketeCheck(
      WorkOfficeVerificationId: widget.officewrkid,
      InquiryId: widget.InqID,
      NeighborsName: "",
      NeighborsAddress: "",
      KnowsApplicant: "false",
      KnowsHowint: "",
      BusinessEstablishedSinceMarketeCheck: "",
      NeighborComments: "",
    );
    marketeCheck = salariedMarket;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Color(0xff392850),
            title: Text(
              "Neighbor/Market Check (${widget.typeOfPerson})",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Calibri',
                  fontSize: 22.0),
            )),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              OfficeCustomCard(
                  NameofOffice: widget.NameofOffice,
                  AddressofOffice: widget.AddressofOffice,
                  NameofPerson: widget.NameofPerson,
                  Landmark: widget.Landmark,
                  typeOfPerson: widget.typeOfPerson),
              Padding(
                padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
                child: Form(
                  key: _OfficeNeighborformKey,
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
                        controller: neighborNameController,
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
                          if (val == null ||
                              val.isEmpty ||
                              val.trim().isEmpty) {
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
                        controller: neighborAddressController,
                        maxLines: 3,
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
                          if (val == null ||
                              val.isEmpty ||
                              val.trim().isEmpty) {
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
                        "Does Neighbor know the ${widget.typeOfPerson} ?",
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
                                    title: Text(
                                      "Yes",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: neighborKnowledgeValue,
                                    onChanged: (value) {
                                      setState(() {
                                        neighborKnowledgeValue = value!;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                    activeColor: Color(0xff392850),
                                    value: "false",
                                    title: Text(
                                      "No",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: neighborKnowledgeValue,
                                    onChanged: (value) {
                                      setState(() {
                                        neighborKnowledgeValue = value!;
                                      });
                                    }),
                              ),
                            ],
                          )),
                      TextFormField(
                        enabled: neighborKnowledgeValue == "true",
                        controller: knowledgeofNeighborController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Since How Long Neighbor Knows",
                            hintStyle: TextStyle(fontFamily: 'Calibri'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff392850), width: 2.0))),
                        validator: (val) {
                          if (neighborKnowledgeValue == "true" &&
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
                      const Text(
                        "Business Established Since -Current (Market Check):",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: establishedController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter Business Established Here.",
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
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Comments Regarding the ${widget.typeOfPerson}:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: commentController,
                        maxLines: 3,
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
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 40.0,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                backgroundColor: Color(0xff392850)),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SalariedDialog(
                                        context,
                                        "Are you sure?",
                                        "Do you confirm this Person is 'SALARIED PERSON'",
                                        "Yes", () async {
                                      saveSALARIEDdata();
                                      await DBHelper.createOfficeMarketCheckdb(
                                          marketeCheck);
                                      await DBHelper.updateOfficeStatus(
                                          InquiryStatus.PartialCompleted,
                                          widget.officewrkid);
                                      await DBHelper.UpdateOffInquiryStatus(
                                          widget.InqID);
                                      await DBHelper.updateInquiryTableStatus(
                                          widget.InqID);
                                      await DBHelper.updateOffMARKstatus(
                                          widget.officewrkid,
                                          InquiryStatus.Completed);
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VerificationOfOffice(
                                                    NameofOffice:
                                                        widget.NameofOffice,
                                                    AddressofOffice:
                                                        widget.AddressofOffice,
                                                    Landmark: widget.Landmark,
                                                    typeofPerson:
                                                        widget.typeOfPerson,
                                                    NameofPerson:
                                                        widget.NameofPerson,
                                                    OfficeVerID:
                                                        widget.officewrkid,
                                                    INQid: widget.InqID,
                                                  )));
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
                            },
                            child: Text(
                              "Click here. If Person is 'SALARIED PERSON'",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Calibri',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 3.0,
                      )
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
                            if (_OfficeNeighborformKey.currentState!
                                    .validate() &&
                                neighborKnowledgeValue.isEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return finalDialog(
                                        context,
                                        "All Fields are Completed!",
                                        "Do you want to save it?",
                                        "Save", () async {
                                      saveMarketCheckData();
                                      await DBHelper.createOfficeMarketCheckdb(
                                          marketeCheck);
                                      await DBHelper.updateOfficeStatus(
                                          InquiryStatus.PartialCompleted,
                                          widget.officewrkid);
                                      await DBHelper.UpdateOffInquiryStatus(
                                          widget.InqID);
                                      await DBHelper.updateInquiryTableStatus(
                                          widget.InqID);
                                      await DBHelper.updateOffMARKstatus(
                                          widget.officewrkid,
                                          InquiryStatus.Completed);
                                      Navigator.of(context).pop();
                                      Navigator.pop(context);
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
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              });
                            }
                          } on Exception catch (e) {
                            EVSLogger.appendLog(
                                "Exception on OfficeNeighborVerification ${e.toString()}");
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
      ),
    );
  }
}
