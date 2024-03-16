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

class OfficeHRVerification extends StatefulWidget {
  OfficeHRVerification(
      {super.key,
      this.workofficeverified,
      required this.NameofOffice,
      required this.AddressofOffice,
      required this.NameofPerson,
      required this.Landmark,
      required this.typeOfPerson,
      required this.officeverID,
      required this.inquiryID});
  final List<WorkOfficeVerifications>? workofficeverified;
  final String NameofOffice;
  final String AddressofOffice;
  final String NameofPerson;
  final String Landmark;
  final String typeOfPerson;
  final int officeverID;
  final int inquiryID;

  @override
  State<OfficeHRVerification> createState() => _OfficeHRVerificationState();
}

class _OfficeHRVerificationState extends State<OfficeHRVerification> {
  GlobalKey<FormState> _OfficeHRKey = GlobalKey<FormState>();
  final personameController = TextEditingController();
  final empPeriodController = TextEditingController();
  final designationController = TextEditingController();
  final grosSalaryController = TextEditingController();
  final HomeSalaryController = TextEditingController();
  final BusinessnatureController = TextEditingController();
  String personKnowlegdeValue = "";
  String EmpStatusValue = '';
  String businessNatureValue = '';
  String salarySlipValue = '';
  File? HRImage;
  String verificationType = InquiryTypes.OfficeVerification;

  saveHRData() {
    double? grossValue = double.tryParse(grosSalaryController.text + '.0');
    double? NetHomeValue = double.tryParse(HomeSalaryController.text + '.0');
    try {
      OfficeHRDetail hrData = OfficeHRDetail(
        WorkOfficeVerificationId: widget.officeverID,
        InquiryId: widget.inquiryID,
        NameOfPersonToMeet: personameController.text.toString(),
        OHrKnowsApplicant: personKnowlegdeValue.toString(),
        ApplicantEmployementStatus: EmpStatusValue.toString(),
        ApplicantEmployementPeriod: empPeriodController.text.toString(),
        ApplicantDesignation: designationController.text.toString(),
        OHrNatureOfBusiness: businessNatureValue.toString(),
        OHrOtherNatureOfBusiness: BusinessnatureController.text.toString(),
        GrossSalary: grossValue,
        NetTakeHomeSalary: NetHomeValue,
        SalarySlipVerified: salarySlipValue.toString(),
      );
      officeHRDetail = hrData;
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "exception on saveHRData method OfficeHRVerification: ${e.toString()}");
    }
  }

  saveHRNONsalaried() {
    OfficeHRDetail hrSalaried = OfficeHRDetail(
      WorkOfficeVerificationId: widget.officeverID,
      InquiryId: widget.inquiryID,
      NameOfPersonToMeet: "",
      OHrKnowsApplicant: "false",
      ApplicantEmployementStatus: "",
      ApplicantEmployementPeriod: "",
      ApplicantDesignation: "",
      OHrNatureOfBusiness: "",
      OHrOtherNatureOfBusiness: "",
      GrossSalary: 0,
      NetTakeHomeSalary: 0,
      SalarySlipVerified: "false",
    );
    officeHRDetail = hrSalaried;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Color(0xff392850),
          title: Column(
            children: <Widget>[
              const Text(
                "Office / Hr Verification",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Calibri',
                    fontSize: 22.0),
              ),
              Text(
                "(For Salaried Individual) [${widget.typeOfPerson}]",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Calibri',
                    fontSize: 22.0),
              )
            ],
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
                  key: _OfficeHRKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Name of Person Met:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: personameController,
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
                      Text(
                        "Does the Person knows the ${widget.typeOfPerson} ?",
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
                                    groupValue: personKnowlegdeValue,
                                    onChanged: (value) {
                                      setState(() {
                                        personKnowlegdeValue = value!;
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
                                    groupValue: personKnowlegdeValue,
                                    onChanged: (value) {
                                      setState(() {
                                        personKnowlegdeValue = value!;
                                      });
                                    }),
                              ),
                            ],
                          )),
                      const Divider(),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "${widget.typeOfPerson}'s Employment Status ?",
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
                            children: <Widget>[
                              Expanded(
                                child: RadioListTile<String>(
                                    activeColor: Color(0xff392850),
                                    value: "Permanent",
                                    title: const Text(
                                      "Permanent",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: EmpStatusValue,
                                    onChanged: (value) {
                                      setState(() {
                                        EmpStatusValue = value!;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                    activeColor: Color(0xff392850),
                                    value: "Contract",
                                    title: const Text(
                                      "Contract",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: EmpStatusValue,
                                    onChanged: (value) {
                                      setState(() {
                                        EmpStatusValue = value!;
                                      });
                                    }),
                              ),
                            ],
                          )),
                      const Divider(),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "${widget.typeOfPerson}'s Emloyment Period: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: empPeriodController,
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
                        "${widget.typeOfPerson}'s Designation: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: designationController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter Designation Here.",
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
                        "Nature of Business:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      ListTileTheme(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        child: Column(
                          children: <Widget>[
                            RadioListTile<String>(
                                activeColor: Color(0xff392850),
                                value: "Manufacturing",
                                title: const Text(
                                  "Manufacturing",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Calibri',
                                      fontSize: 18.0),
                                ),
                                groupValue: businessNatureValue,
                                onChanged: (value) {
                                  setState(() {
                                    businessNatureValue = value!;
                                  });
                                }),
                            RadioListTile<String>(
                                activeColor: Color(0xff392850),
                                value: "Services",
                                title: const Text(
                                  "Services",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Calibri',
                                      fontSize: 18.0),
                                ),
                                groupValue: businessNatureValue,
                                onChanged: (value) {
                                  setState(() {
                                    businessNatureValue = value!;
                                  });
                                }),
                            RadioListTile<String>(
                                activeColor: Color(0xff392850),
                                value: "Trading",
                                title: const Text(
                                  "Trading",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Calibri',
                                      fontSize: 18.0),
                                ),
                                groupValue: businessNatureValue,
                                onChanged: (value) {
                                  setState(() {
                                    businessNatureValue = value!;
                                  });
                                }),
                            RadioListTile<String>(
                                activeColor: Color(0xff392850),
                                value: "Govt. Emp",
                                title: const Text(
                                  "Govt. Emp",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Calibri',
                                      fontSize: 18.0),
                                ),
                                groupValue: businessNatureValue,
                                onChanged: (value) {
                                  setState(() {
                                    businessNatureValue = value!;
                                  });
                                }),
                            RadioListTile<String>(
                                activeColor: Color(0xff392850),
                                value: "Other",
                                title: const Text(
                                  "Other",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Calibri',
                                      fontSize: 18.0),
                                ),
                                groupValue: businessNatureValue,
                                onChanged: (value) {
                                  setState(() {
                                    businessNatureValue = value!;
                                  });
                                }),
                          ],
                        ),
                      ),
                      TextFormField(
                        enabled: businessNatureValue == 'Other',
                        controller: BusinessnatureController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "If Other Selected Mention Name Here.",
                            hintStyle: TextStyle(fontFamily: 'Calibri'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff392850), width: 2.0))),
                        validator: (val) {
                          if (businessNatureValue == 'Other' &&
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
                        "Gross Salary:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: grosSalaryController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter Gross Salary Here.",
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
                        "Net/Take Home Salary:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: HomeSalaryController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter Net/Take Salary Here.",
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
                        "Salary Slip (Verified):",
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
                                    groupValue: salarySlipValue,
                                    onChanged: (value) {
                                      setState(() {
                                        salarySlipValue = value!;
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
                                    groupValue: salarySlipValue,
                                    onChanged: (value) {
                                      setState(() {
                                        salarySlipValue = value!;
                                      });
                                    }),
                              ),
                            ],
                          )),
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
                                        "Do you confirm this Person is 'NOT SALARIED PERSON'",
                                        "Yes", () async {
                                      saveHRNONsalaried();
                                      await DBHelper.CreateHRDbForNonSalaried(
                                          officeHRDetail);
                                      await DBHelper.updateOfficeStatus(
                                          InquiryStatus.PartialCompleted,
                                          widget.officeverID);
                                      await DBHelper.UpdateOffInquiryStatus(
                                          widget.inquiryID);
                                      await DBHelper.updateInquiryTableStatus(
                                          widget.inquiryID);
                                      await DBHelper.updateOffHRstatus(
                                          widget.officeverID,
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
                                                        widget.officeverID,
                                                    INQid: widget.inquiryID,
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
                              "Click here. If Person is 'NOT SALARIED PERSON'",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Calibri',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5.0,
                      ),
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
                          if (_OfficeHRKey.currentState!.validate() &&
                              personKnowlegdeValue.isNotEmpty &&
                              EmpStatusValue.isNotEmpty &&
                              businessNatureValue.isNotEmpty &&
                              salarySlipValue.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return finalDialog(
                                      context,
                                      "All Fields are Completed!",
                                      "Do you want to save it?",
                                      "Save", () async {
                                    saveHRData();
                                    await DBHelper.CreateHRDb(officeHRDetail);
                                    await DBHelper.updateOfficeStatus(
                                        InquiryStatus.PartialCompleted,
                                        widget.officeverID);
                                    await DBHelper.UpdateOffInquiryStatus(
                                        widget.inquiryID);
                                    await DBHelper.updateInquiryTableStatus(
                                        widget.inquiryID);
                                    await DBHelper.updateOffHRstatus(
                                        widget.officeverID,
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
                                                      widget.officeverID,
                                                  INQid: widget.inquiryID,
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
                          } else {
                            MyDialog.show(context, 'Kindly fill all fields');
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.of(context, rootNavigator: true).pop();
                            });
                          }
                        } on Exception catch (e) {
                          EVSLogger.appendLog(
                              "Exception on OfficeHRVerification ${e.toString()} ");
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
