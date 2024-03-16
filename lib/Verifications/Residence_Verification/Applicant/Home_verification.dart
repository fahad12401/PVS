import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Database/Database_Helper.dart';
import '../../../Module For Post Data/Post_inquires_model..dart';
import '../../../Module for Get Data/Inquires_response.dart';
import '../../../Screens/PreviewImage.dart';
import '../../../Widgets/Card_Widgets/Residence_customcard.dart';
import '../../../Widgets/Dialogbox.dart';
import '../../../Widgets/InquiryTypes.dart';
import '../../../Widgets/Inquiry_status.dart';
import '../../../Widgets/Logs/Logeger.dart';

class ApplicantHomeverification extends StatefulWidget {
  ApplicantHomeverification(
      {super.key,
      this.ApplicantHomeVerified,
      required this.PersonType,
      required this.NameofPerson,
      required this.residenceAddress,
      required this.nearestLandmark,
      required this.resVerId,
      required this.Inquiryid});
  final List<ResidenceVerifications>? ApplicantHomeVerified;
  final String PersonType;
  final String NameofPerson;
  final String residenceAddress;
  final String nearestLandmark;
  final int resVerId;
  final int Inquiryid;

  @override
  State<ApplicantHomeverification> createState() =>
      _ApplicantHomeverificationState();
}

class _ApplicantHomeverificationState extends State<ApplicantHomeverification> {
  GlobalKey<FormState> _ApplicanthomeformKey = GlobalKey<FormState>();
  final ApplicantpersonNameController = TextEditingController();
  final ApplicantpersonRelationController = TextEditingController();
  final ApplicantcorrectAddressController = TextEditingController();
  final ApplicantpermanentAddressController = TextEditingController();
  final ApplicantphonenumberController = TextEditingController();
  final ApplicantyearsController = TextEditingController();
  final ApplicantcnicController = TextEditingController();
  String ApplicantMeetvalue = "";
  String ApplicantConfirmAddressValue = "";
  String ApplicantGivenAddressValue = "";
  bool showTextfield = false;
  List<File> HomeImage = [];
  String verType = InquiryTypes.ResidenceVerification;

  Future<void> CaptureHomeImage() async {
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
                      Vtype: verType,
                      inquiryid: widget.Inquiryid,
                      Persntype: widget.PersonType,
                      capimages: HomeImage,
                      verifyID: widget.resVerId,
                      subVertype: InquiryTypes.ResidenceAddress,
                    )));
        MyDialog.show(context, 'Kindly Take Photo');
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      } else {
        setState(() {
          HomeImage = [File(image.path)];
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewImage(
                      Vtype: verType,
                      inquiryid: widget.Inquiryid,
                      Persntype: widget.PersonType,
                      capimages: HomeImage,
                      verifyID: widget.resVerId,
                      subVertype: InquiryTypes.ResidenceAddress,
                    )));
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on CaptureHomeImage ApplicantHomeverification: ${e.toString()}");
    }
  }

  saveresDetails() {
    try {
      ResidenceDetail residenceD = ResidenceDetail(
          WasActualAddressSame: ApplicantConfirmAddressValue.toString(),
          ResidenceVerificationId: widget.resVerId,
          IsApplicantAvailable: ApplicantMeetvalue.toString(),
          NameOfPersonToMet: ApplicantpersonNameController.text.toString(),
          RelationWithApplicant:
              ApplicantpersonRelationController.text.toString(),
          CorrectAddress: ApplicantcorrectAddressController.text.toString(),
          PhoneNo: ApplicantphonenumberController.text.toString(),
          LivesAtGivenAddress: ApplicantGivenAddressValue,
          PermanentAddress: ApplicantpermanentAddressController.text.toString(),
          SinceHowintLiving: ApplicantyearsController.text.toString(),
          CNICNo: ApplicantcnicController.text.toString(),
          PersonType: widget.PersonType,
          InquiryId: widget.Inquiryid);
      residencedetail = residenceD;
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on saveresDetails ApplicantHomeverification:${e.toString()}");
    }
  }

  // String? _errorText;
  // void _validateInput(String value) {
  //   setState(() {
  //     _errorText = value.length != 13 ? 'Please enter complete CNIC no.' : null;
  //   });
  // }

  // String? _PhoneerrorText;
  // void _validateInputNumber(String value) {
  //   setState(() {
  //     _errorText =
  //         value.length != 11 ? 'Please enter complete Mobile no.' : null;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff392850),
        title: Text(
          "Residence Verification (${widget.PersonType})",
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
                key: _ApplicanthomeformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Did you Meet the ${widget.PersonType}?",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    ListTileTheme(
                      dense: true,
                      child: Row(
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
                                  groupValue: ApplicantMeetvalue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantMeetvalue = value!;
                                    });
                                  })),
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
                                  groupValue: ApplicantMeetvalue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantMeetvalue = value!;
                                    });
                                  })),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      enabled: ApplicantMeetvalue == "false",
                      controller: ApplicantpersonNameController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Name of Person to Met Here",
                          hintStyle: TextStyle(fontFamily: 'Calibri'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff392850), width: 2.0))),
                      validator: (val) {
                        if (ApplicantMeetvalue == "false" &&
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
                    TextFormField(
                      enabled: ApplicantMeetvalue == "false",
                      controller: ApplicantpersonRelationController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Relation of Person Here.",
                          hintStyle: TextStyle(fontFamily: 'Calibri'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff392850), width: 2.0))),
                      validator: (val) {
                        if (ApplicantMeetvalue == 'false' &&
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
                      "Was Actual Address same as Above?",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    ListTileTheme(
                      dense: true,
                      child: Row(
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
                                  groupValue: ApplicantConfirmAddressValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantConfirmAddressValue = value!;
                                    });
                                  })),
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
                                  groupValue: ApplicantConfirmAddressValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantConfirmAddressValue = value!;
                                    });
                                  })),
                        ],
                      ),
                    ),
                    TextFormField(
                      enabled: ApplicantConfirmAddressValue == "false",
                      maxLines: 4,
                      controller: ApplicantcorrectAddressController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Correct Address here.",
                          hintStyle: TextStyle(fontFamily: 'Calibri'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff392850), width: 2.0))),
                      validator: (val) {
                        if (ApplicantConfirmAddressValue == "false" &&
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
                      "Phone No.",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    TextFormField(
                      maxLength: 11,
                      keyboardType: TextInputType.number,
                      controller: ApplicantphonenumberController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Phone Number.",
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
                    const Divider(),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Does ${widget.PersonType} Lives at the given Address?",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    ListTileTheme(
                      dense: true,
                      child: Row(
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
                                  groupValue: ApplicantGivenAddressValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantGivenAddressValue = value!;
                                    });
                                  })),
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
                                  groupValue: ApplicantGivenAddressValue,
                                  onChanged: (value) {
                                    setState(() {
                                      ApplicantGivenAddressValue = value!;
                                    });
                                  })),
                        ],
                      ),
                    ),
                    TextFormField(
                      enabled: ApplicantGivenAddressValue == "false",
                      maxLines: 4,
                      controller: ApplicantpermanentAddressController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Permanent Address here.",
                          hintStyle: TextStyle(fontFamily: 'Calibri'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff392850), width: 2.0))),
                      validator: (val) {
                        if (ApplicantGivenAddressValue == "false" &&
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
                      "Since How Long ${widget.PersonType} is Living on the same Address?",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: ApplicantyearsController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter Years here.",
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
                      "CNIC #",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    TextFormField(
                      maxLength: 13,
                      keyboardType: TextInputType.number,
                      controller: ApplicantcnicController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          hintText: "Enter CNIC Number.",
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
                    const Divider()
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
                          if (_ApplicanthomeformKey.currentState!.validate() &&
                              ApplicantMeetvalue.isNotEmpty &&
                              ApplicantConfirmAddressValue.isNotEmpty &&
                              ApplicantGivenAddressValue.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return finalDialog(
                                      context,
                                      "All Fields are Completed!",
                                      "Do you want to save it?",
                                      "Take Photo", () async {
                                    saveresDetails();
                                    await DBHelper.createResidenceHomesData(
                                        residencedetail);
                                    await DBHelper.updateResidenceStatus(
                                        InquiryStatus.PartialCompleted,
                                        widget.resVerId);
                                    await DBHelper.UpdateRInquiryStatus(
                                        widget.Inquiryid);
                                    await DBHelper.updateInquiryTableStatus(
                                        widget.Inquiryid);
                                    CaptureHomeImage();
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
                              "Exception on ApplicantHomeVerification: ${e.toString()}");
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
            const Divider()
          ],
        ),
      ),
    );
  }
}
