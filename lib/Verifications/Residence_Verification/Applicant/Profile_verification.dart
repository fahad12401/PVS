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

class ApplicantResidenceProfile extends StatefulWidget {
  ApplicantResidenceProfile(
      {super.key,
      this.ApplicantProfileVerified,
      required this.PersonType,
      required this.NameofPerson,
      required this.residenceAddress,
      required this.nearestLandmark,
      required this.resVerID,
      required this.InQuiryID});
  final List<ResidenceVerifications>? ApplicantProfileVerified;
  final String PersonType;
  final String NameofPerson;
  final String residenceAddress;
  final String nearestLandmark;
  final int resVerID;
  final int InQuiryID;

  @override
  State<ApplicantResidenceProfile> createState() =>
      _ApplicantResidenceProfileState();
}

class _ApplicantResidenceProfileState extends State<ApplicantResidenceProfile> {
  GlobalKey<FormState> _ApplicantProfileformKey = GlobalKey<FormState>();
  final Applicantrentcontroller = TextEditingController();
  final Applicantspecifycontroller = TextEditingController();
  final ApplicantApproxSizeController = TextEditingController();
  String ApplicantresidencetypeValue = '';
  String ApplicantownershipValue = '';
  String ApplicantresidenceUtilizeValue = '';
  String ApplicantneighborValue = '';
  String ApplicantareaAccessValue = '';
  String ApplicantresidentbelongtoValue = '';
  String ApplicantrepossessionValue = '';
  int? ApplicantspecifyINT;
  bool enablefield = false;
  File? ResidenceProfileImage;
  String verType = InquiryTypes.ResidenceVerification;
  saveProfileData() {
    double? RentValue = double.parse(Applicantspecifycontroller.text + '.0');
    try {
      ResidenceProfile saveProf = ResidenceProfile(
        ResidenceVerificationId: widget.resVerID,
        InquiryId: widget.InQuiryID,
        TypeOfResidence: ApplicantresidencetypeValue.toString(),
        ApplicantIsA: ApplicantownershipValue.toString(),
        AreaAccessibility: ApplicantareaAccessValue.toString(),
        MentionOther: RentValue,
        MentionRent: Applicantrentcontroller.text.toString(),
        SizeApproxArea: ApplicantApproxSizeController.text.toString(),
        UtilizationOfResidence: ApplicantresidenceUtilizeValue.toString(),
        Neighborhood: ApplicantneighborValue.toString(),
        RepossessionInTheArea: ApplicantrepossessionValue.toString(),
        ResidentsBelongsTo: ApplicantresidentbelongtoValue.toString(),
      );
      residenceProfile = saveProf;
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on saveProfileData ApplicantResidenceProfile:${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff392850),
        title: Text(
          "Residence Profile (${widget.PersonType})",
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
                  key: _ApplicantProfileformKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Type of Residence:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      ListTileTheme(
                          minVerticalPadding: 1,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "House",
                                  title: const Text(
                                    "House",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantresidencetypeValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantresidencetypeValue = value!;
                                    });
                                  }),
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Portion",
                                  title: const Text(
                                    "Portion",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantresidencetypeValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantresidencetypeValue = value!;
                                    });
                                  }),
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Apartment",
                                  title: const Text(
                                    "Apartment",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantresidencetypeValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantresidencetypeValue = value!;
                                    });
                                  }),
                            ],
                          )),
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Divider(),
                      Text(
                        "${widget.PersonType} is a ?",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      ListTileTheme(
                          minLeadingWidth: 0,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: RadioListTile<String>(
                                    activeColor: Color(0xff392850),
                                    value: "Owner",
                                    title: const Text(
                                      "Owner",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: ApplicantownershipValue,
                                    onChanged: (value) {
                                      setState(() {
                                        ApplicantownershipValue = value!;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                    activeColor: Color(0xff392850),
                                    value: "Tenant",
                                    title: const Text(
                                      "Tenant",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: ApplicantownershipValue,
                                    onChanged: (value) {
                                      setState(() {
                                        ApplicantownershipValue = value!;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                    activeColor: Color(0xff392850),
                                    value: "Other",
                                    title: const Text(
                                      "Other",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: ApplicantownershipValue,
                                    onChanged: (value) {
                                      setState(() {
                                        ApplicantownershipValue = value!;
                                      });
                                    }),
                              ),
                            ],
                          )),
                      const Text(
                        "If Tenant Mention Rent:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      const SizedBox(
                        width: 9.0,
                      ),
                      TextFormField(
                        enabled: ApplicantownershipValue == 'Tenant',
                        controller: Applicantrentcontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter Rent Here",
                            hintStyle: TextStyle(fontFamily: 'Calibri'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff392850), width: 2.0))),
                        validator: (val) {
                          if (ApplicantownershipValue == 'Tenant' &&
                              (val == null ||
                                  val.isEmpty ||
                                  val.trim().isEmpty)) {
                            return "Kindly fill the Field";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Text(
                        "If Other Mention Above:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      TextFormField(
                        enabled: ApplicantownershipValue == 'Other',
                        controller: Applicantspecifycontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Specify Other Here",
                            hintStyle: TextStyle(fontFamily: 'Calibri'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff392850), width: 2.0))),
                        validator: (val) {
                          if (ApplicantownershipValue == 'Other' &&
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
                        "Size (Approx Area):",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: ApplicantApproxSizeController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter Approx Area Here",
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
                        "What is the Utilization of Residence ?",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      ListTileTheme(
                          minLeadingWidth: 0,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: RadioListTile<String>(
                                    activeColor: Color(0xff392850),
                                    value: "Residential",
                                    title: const Text(
                                      "Residential",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: ApplicantresidenceUtilizeValue,
                                    onChanged: (value) {
                                      setState(() {
                                        ApplicantresidenceUtilizeValue = value!;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                    activeColor: Color(0xff392850),
                                    value: "Commercial",
                                    title: Text(
                                      "Commercial",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: ApplicantresidenceUtilizeValue,
                                    onChanged: (value) {
                                      setState(() {
                                        ApplicantresidenceUtilizeValue = value!;
                                      });
                                    }),
                              ),
                            ],
                          )),
                      const Divider(),
                      Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xff392850)),
                        child: Center(
                            child: const Text(
                          "Neighborhood Check:",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Calibri',
                              fontWeight: FontWeight.bold,
                              fontSize: 23.0),
                        )),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      const Text(
                        "Neighborhood:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      ListTileTheme(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 2.0, vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Planned",
                                  title: const Text(
                                    "Planned",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantneighborValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantneighborValue = value!;
                                    });
                                  }),
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Unplanned",
                                  title: const Text(
                                    "Unplanned",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantneighborValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantneighborValue = value!;
                                    });
                                  }),
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Gated",
                                  title: const Text(
                                    "Gated",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantneighborValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantneighborValue = value!;
                                    });
                                  }),
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Katchi Abadi",
                                  title: const Text(
                                    "Katchi Abadi",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantneighborValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantneighborValue = value!;
                                    });
                                  }),
                            ],
                          )),
                      const Divider(),
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Text(
                        "Area Accessibility:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      ListTileTheme(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 2.0, vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Easy",
                                  title: const Text(
                                    "Easy",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantareaAccessValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantareaAccessValue = value!;
                                    });
                                  }),
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Difficult",
                                  title: const Text(
                                    "Difficult",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantareaAccessValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantareaAccessValue = value!;
                                    });
                                  }),
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Very Difficult",
                                  title: const Text(
                                    "Very Difficult",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantareaAccessValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantareaAccessValue = value!;
                                    });
                                  }),
                            ],
                          )),
                      const Divider(),
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Text(
                        "Residents predominantly belong's to ?:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      ListTileTheme(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 2.0, vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Lower Middle",
                                  title: const Text(
                                    "Lower Middle",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantresidentbelongtoValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantresidentbelongtoValue = value!;
                                    });
                                  }),
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Middle",
                                  title: const Text(
                                    "Middle",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantresidentbelongtoValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantresidentbelongtoValue = value!;
                                    });
                                  }),
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Upper Middle",
                                  title: const Text(
                                    "Upper Middle",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantresidentbelongtoValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantresidentbelongtoValue = value!;
                                    });
                                  }),
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Upper Class",
                                  title: const Text(
                                    "Upper Class",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantresidentbelongtoValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantresidentbelongtoValue = value!;
                                    });
                                  }),
                            ],
                          )),
                      const Divider(),
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Text(
                        "Is Repossession in the area ?",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      ListTileTheme(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 2.0, vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Easy",
                                  title: const Text(
                                    "Easy",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantrepossessionValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantrepossessionValue = value!;
                                    });
                                  }),
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Difficult",
                                  title: const Text(
                                    "Difficult",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantrepossessionValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantrepossessionValue = value!;
                                    });
                                  }),
                              RadioListTile<String>(
                                  activeColor: Color(0xff392850),
                                  value: "Very Difficult",
                                  title: const Text(
                                    "Very Difficult",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Calibri',
                                        fontSize: 18.0),
                                  ),
                                  groupValue: ApplicantrepossessionValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantrepossessionValue = value!;
                                    });
                                  }),
                            ],
                          )),
                    ],
                  )),
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
                          if (_ApplicantProfileformKey.currentState!
                                  .validate() &&
                              ApplicantresidencetypeValue.isNotEmpty &&
                              ApplicantownershipValue.isNotEmpty &&
                              ApplicantresidenceUtilizeValue.isNotEmpty &&
                              ApplicantneighborValue.isNotEmpty &&
                              ApplicantareaAccessValue.isNotEmpty &&
                              ApplicantresidentbelongtoValue.isNotEmpty &&
                              ApplicantrepossessionValue.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return finalDialog(
                                      context,
                                      "All Fields are Completed!",
                                      "Do you want to save it?",
                                      "Save", () async {
                                    saveProfileData();
                                    await DBHelper.CreateResidenceProfiledB(
                                        residenceProfile);
                                    await DBHelper.updateResidenceStatus(
                                        InquiryStatus.PartialCompleted,
                                        widget.resVerID);
                                    await DBHelper.UpdateRInquiryStatus(
                                        widget.InQuiryID);
                                    await DBHelper.updateInquiryTableStatus(
                                        widget.InQuiryID);
                                    await DBHelper.updateResProfilestatus(
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
                                                        widget.InQuiryID)));
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
                              "Exception on ApplicantResidenceProfile: ${e.toString()}");
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
          ],
        ),
      ),
    );
  }
}
