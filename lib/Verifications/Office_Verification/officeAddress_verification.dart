import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pvs/Widgets/InquiryTypes.dart';
import '../../Database/Database_Helper.dart';
import '../../Module For Post Data/Post_inquires_model..dart';
import '../../Module for Get Data/Inquires_response.dart';
import '../../Screens/PreviewImage.dart';
import '../../Widgets/Card_Widgets/Office_CustomCard.dart';
import '../../Widgets/Dialogbox.dart';
import '../../Widgets/Inquiry_status.dart';
import '../../Widgets/Logs/Logeger.dart';

class OfficeAddressVerification extends StatefulWidget {
  OfficeAddressVerification(
      {super.key,
      this.workofficeverified,
      required this.NameofOffice,
      required this.AddressofOffice,
      required this.NameofPerson,
      required this.Landmark,
      required this.typeOfperson,
      required this.OfficeVerId,
      required this.Inquiryidd});
  final List<WorkOfficeVerifications>? workofficeverified;
  final String NameofOffice;
  final String AddressofOffice;
  final String NameofPerson;
  final String Landmark;
  final String typeOfperson;
  final int OfficeVerId;
  final int Inquiryidd;
  @override
  State<OfficeAddressVerification> createState() =>
      _OfficeAddressVerificationState();
}

class _OfficeAddressVerificationState extends State<OfficeAddressVerification> {
  GlobalKey<FormState> _OfficeAddressformKey = GlobalKey<FormState>();
  final correctAddressController = TextEditingController();
  final overallTimeController = TextEditingController();
  final newAddressController = TextEditingController();
  final reasonController = TextEditingController();
  final personmeetpersonCNICcontroller = TextEditingController();
  final CNICcontroller = TextEditingController();
  String actualAddressValue = "";
  String workAtgivenAddress = "";
  String meetApplicantValue = "";
  String ifcnicValue = '';
  List<File> AddressImage = [];
  String verificationType = InquiryTypes.OfficeVerification;

  Future<void> CaptureAddressImage() async {
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
                    child: PreviewImage(
                      Persntype: widget.typeOfperson,
                      capimages: AddressImage,
                      Vtype: verificationType.toString(),
                      inquiryid: widget.Inquiryidd,
                      verifyID: widget.OfficeVerId,
                      subVertype: InquiryTypes.OfficeAddress,
                    ),
                  )),
        );
        MyDialog.show(context, 'Kindly Take Photo');
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      } else {
        setState(() {
          AddressImage = [File(image.path)];
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewImage(
                      Vtype: verificationType,
                      Persntype: widget.typeOfperson,
                      inquiryid: widget.Inquiryidd,
                      capimages: AddressImage,
                      verifyID: widget.OfficeVerId,
                      subVertype: InquiryTypes.OfficeAddress,
                    )));
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on CaptureAddressImage method OfficeAddressVerification: ${e.toString()}");
    }
  }

  saveOfficeAddressData() {
    try {
      OfficeAddressDetail officeAddressData = OfficeAddressDetail(
        InquiryId: widget.Inquiryidd,
        WorkOfficeVerificationId: widget.OfficeVerId,
        WasActualAddressSame: actualAddressValue,
        CorrectAddress: correctAddressController.text.toString(),
        EstablishedTime: overallTimeController.text.toString(),
        WorkAtGivenAddress: workAtgivenAddress.toString(),
        GiveNewAddress: newAddressController.text.toString(),
        IsApplicantAvailable: meetApplicantValue,
        GiveReason: reasonController.text.toString(),
        MetPersonCNIC: personmeetpersonCNICcontroller.text.toString(),
        CNICNo: CNICcontroller.text.toString(),
        CNICOS: ifcnicValue.toString(),
      );
      officeAddressDetail = officeAddressData;
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on saveOfficeAddressData OfficeAddressVerification: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xff392850),
        title: Text(
          "Office Address Verification (${widget.typeOfperson})",
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
            OfficeCustomCard(
                NameofOffice: widget.NameofOffice,
                AddressofOffice: widget.AddressofOffice,
                NameofPerson: widget.NameofPerson,
                Landmark: widget.Landmark,
                typeOfPerson: widget.typeOfperson),
            Padding(
              padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
              child: Form(
                  key: _OfficeAddressformKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Was Actual Address same as Above:",
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
                                    groupValue: actualAddressValue,
                                    onChanged: (value) {
                                      setState(() {
                                        actualAddressValue = value!;
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
                                    groupValue: actualAddressValue,
                                    onChanged: (value) {
                                      setState(() {
                                        actualAddressValue = value!;
                                      });
                                    }),
                              ),
                            ],
                          )),
                      TextFormField(
                        enabled: actualAddressValue == "false",
                        controller: correctAddressController,
                        maxLines: 2,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter Correct Address Here.",
                            hintStyle: TextStyle(fontFamily: 'Calibri'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff392850), width: 2.0))),
                        validator: (val) {
                          if (actualAddressValue == "false" &&
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
                        "Length of Time the Business/Office has been Established (Overall):",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: overallTimeController,
                        maxLines: 2,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter Overall Time Here.",
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
                        "Does the  Works at the given Address:",
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
                                    groupValue: workAtgivenAddress,
                                    onChanged: (value) {
                                      setState(() {
                                        workAtgivenAddress = value!;
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
                                    groupValue: workAtgivenAddress,
                                    onChanged: (value) {
                                      setState(() {
                                        workAtgivenAddress = value!;
                                      });
                                    }),
                              ),
                            ],
                          )),
                      TextFormField(
                        enabled: workAtgivenAddress == 'false',
                        controller: newAddressController,
                        maxLines: 2,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter New Address.",
                            hintStyle: TextStyle(fontFamily: 'Calibri'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff392850), width: 2.0))),
                        validator: (val) {
                          if ((val == null ||
                                  val.isEmpty ||
                                  val.trim().isEmpty) &&
                              workAtgivenAddress == 'false') {
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
                        "Did you Meet the ${widget.typeOfperson} ?",
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
                                    groupValue: meetApplicantValue,
                                    onChanged: (value) {
                                      setState(() {
                                        meetApplicantValue = value!;
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
                                    groupValue: meetApplicantValue,
                                    onChanged: (value) {
                                      setState(() {
                                        meetApplicantValue = value!;
                                      });
                                    }),
                              ),
                            ],
                          )),
                      TextFormField(
                        enabled: meetApplicantValue == "false",
                        controller: reasonController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter Reason For Not Available Here.",
                            hintStyle: TextStyle(fontFamily: 'Calibri'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff392850), width: 2.0))),
                        validator: (val) {
                          if (meetApplicantValue == "false" &&
                              (val == null ||
                                  val.isEmpty ||
                                  val.trim().isEmpty)) {
                            return "Kindly fill the Field";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 3.0,
                      ),
                      TextFormField(
                        enabled: meetApplicantValue == "false",
                        controller: personmeetpersonCNICcontroller,
                        keyboardType: TextInputType.number,
                        maxLength: 13,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter Met Person CNIC here.",
                            hintStyle: TextStyle(fontFamily: 'Calibri'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff392850), width: 2.0))),
                        validator: (val) {
                          if (meetApplicantValue == "false" &&
                              (val == null ||
                                  val.isEmpty ||
                                  val.length != 13 ||
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
                        "${widget.typeOfperson} CNIC # (0/s Physically if Possible)",
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
                                    groupValue: ifcnicValue,
                                    onChanged: (value) {
                                      setState(() {
                                        ifcnicValue = value!;
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
                                    groupValue: ifcnicValue,
                                    onChanged: (value) {
                                      setState(() {
                                        ifcnicValue = value!;
                                      });
                                    }),
                              ),
                            ],
                          )),
                      const Divider(),
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Text(
                        "CNIC# :",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: CNICcontroller,
                        maxLength: 13,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter CNIC here.",
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
                      const Divider(),
                      const SizedBox(
                        height: 3.0,
                      )
                    ],
                  )),
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
                          if (_OfficeAddressformKey.currentState!.validate() &&
                              actualAddressValue.isNotEmpty &&
                              workAtgivenAddress.isNotEmpty &&
                              meetApplicantValue.isNotEmpty &&
                              ifcnicValue.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return finalDialog(
                                      context,
                                      "All Fields are Completed!",
                                      "Do you want to save it?",
                                      "Take Photo", () async {
                                    saveOfficeAddressData();
                                    await DBHelper.createOfficeAddressdb(
                                        officeAddressDetail);
                                    await DBHelper.updateOfficeStatus(
                                        InquiryStatus.PartialCompleted,
                                        widget.OfficeVerId);
                                    await DBHelper.UpdateOffInquiryStatus(
                                        widget.Inquiryidd);
                                    await DBHelper.updateInquiryTableStatus(
                                        widget.Inquiryidd);
                                    await DBHelper.updateOffAddressstatus(
                                        widget.OfficeVerId,
                                        InquiryStatus.PartialCompleted);
                                    await DBHelper.printTable();
                                    Navigator.of(context).pop();

                                    CaptureAddressImage();
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
                              "Exception on OfficeAddressVerification: ${e.toString()}");
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
            SizedBox(
              height: 3.0,
            )
          ],
        ),
      ),
    );
  }
}
