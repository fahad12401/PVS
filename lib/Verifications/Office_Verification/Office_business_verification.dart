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

class Business_Office_Verification extends StatefulWidget {
  Business_Office_Verification(
      {super.key,
      this.workofficeverified,
      required this.NameofOffice,
      required this.AddressofOffice,
      required this.NameofPerson,
      required this.Landmark,
      required this.typeOfPerson,
      required this.OfficewrkID,
      required this.inquiryID});
  final List<WorkOfficeVerifications>? workofficeverified;
  final String NameofOffice;
  final String AddressofOffice;
  final String NameofPerson;
  final String Landmark;
  final String typeOfPerson;
  final int OfficewrkID;
  final int inquiryID;

  @override
  State<Business_Office_Verification> createState() =>
      _Business_Office_VerificationState();
}

class _Business_Office_VerificationState
    extends State<Business_Office_Verification> {
  GlobalKey<FormState> _OfficeverifyformKey = GlobalKey<FormState>();
  final otherBusinessController = TextEditingController();
  final BusinessNatureController = TextEditingController();
  final TenantrentController = TextEditingController();
  final specifyotherController = TextEditingController();
  final GovtbusinessController = TextEditingController();
  final approxAreaController = TextEditingController();
  final NoOfemployeeController = TextEditingController();
  final businessestablishDateCTR = TextEditingController();
  int? noOfEmployeesInt;
  String BusinesstypeValue = '';
  String BusinessNatureValue = '';
  String BusinessOwnershipValue = '';
  String BusinesLegalEntityValue = '';
  String BusinessNamePlateValue = "";
  String BusinessActivityValue = '';

  String verificationType = InquiryTypes.OfficeVerification;
  SaveBusinessData() {
    if (NoOfemployeeController.text.isNotEmpty) {
      noOfEmployeesInt = int.parse(NoOfemployeeController.text);
    }

    try {
      BusinessWorkOfficeDetail workOfficeDetail = BusinessWorkOfficeDetail(
          WorkOfficeVerificationId: widget.OfficewrkID,
          InquiryId: widget.inquiryID,
          TypeOfBusiness: BusinesstypeValue.toString(),
          OtherTypeOfBusiness: otherBusinessController.text.toString(),
          NatureOfBusiness: BusinessNatureValue.toString(),
          OtherNatureOfBusiness: BusinessNatureController.text.toString(),
          ApplicantIsA: BusinessOwnershipValue.toString(),
          MentionOther: specifyotherController.text.toString(),
          MentionRent: TenantrentController.text.toString(),
          BusinessLegalEntity: BusinesLegalEntityValue.toString(),
          GovtEmpBusinessLegalEntity: GovtbusinessController.text.toString(),
          NamePlateAffixed: BusinessNamePlateValue,
          BusinessActivity: BusinessActivityValue.toString(),
          SizeApproxArea: approxAreaController.text.toString(),
          NoOfEmployees: noOfEmployeesInt,
          BusinessEstablesSince: businessestablishDateCTR.text.toString());
      businessWorkOfficeDetail = workOfficeDetail;
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on SaveBusinessData Business_Office_Verification: ${e.toString()}");
    }
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
                "Business/Work/Office Verification ",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Calibri',
                    fontSize: 22.0),
              ),
              Text(
                "(For (SEB/SEP)) [${widget.typeOfPerson}]",
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
                key: _OfficeverifyformKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Form(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "Type of Business:",
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
                                    value: "Shop",
                                    title: const Text(
                                      "Shop",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: BusinesstypeValue,
                                    onChanged: (value) {
                                      setState(() {
                                        BusinesstypeValue = value!;
                                      });
                                    }),
                                RadioListTile<String>(
                                    activeColor: Color(0xff392850),
                                    value: "Office",
                                    title: const Text(
                                      "Office",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: BusinesstypeValue,
                                    onChanged: (value) {
                                      setState(() {
                                        BusinesstypeValue = value!;
                                      });
                                    }),
                                RadioListTile<String>(
                                    activeColor: Color(0xff392850),
                                    value: "Restaurant",
                                    title: const Text(
                                      "Restaurant",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: BusinesstypeValue,
                                    onChanged: (value) {
                                      setState(() {
                                        BusinesstypeValue = value!;
                                      });
                                    }),
                                RadioListTile<String>(
                                    activeColor: Color(0xff392850),
                                    value: "Factory",
                                    title: const Text(
                                      "Factory",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0),
                                    ),
                                    groupValue: BusinesstypeValue,
                                    onChanged: (value) {
                                      setState(() {
                                        BusinesstypeValue = value!;
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
                                    groupValue: BusinesstypeValue,
                                    onChanged: (value) {
                                      setState(() {
                                        BusinesstypeValue = value!;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          TextFormField(
                            enabled: BusinesstypeValue == 'Other',
                            controller: otherBusinessController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white54,
                                hintText: "Enter Other Business Type Here.",
                                hintStyle: TextStyle(fontFamily: 'Calibri'),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff392850), width: 2.0))),
                            validator: (val) {
                              if (BusinesstypeValue == 'Other' &&
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
                                    groupValue: BusinessNatureValue,
                                    onChanged: (value) {
                                      setState(() {
                                        BusinessNatureValue = value!;
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
                                    groupValue: BusinessNatureValue,
                                    onChanged: (value) {
                                      setState(() {
                                        BusinessNatureValue = value!;
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
                                    groupValue: BusinessNatureValue,
                                    onChanged: (value) {
                                      setState(() {
                                        BusinessNatureValue = value!;
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
                                    groupValue: BusinessNatureValue,
                                    onChanged: (value) {
                                      setState(() {
                                        BusinessNatureValue = value!;
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
                                    groupValue: BusinessNatureValue,
                                    onChanged: (value) {
                                      setState(() {
                                        BusinessNatureValue = value!;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          TextFormField(
                            enabled: BusinessNatureValue == 'Other',
                            controller: BusinessNatureController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white54,
                                hintText: "If Other Mention Here.",
                                hintStyle: TextStyle(fontFamily: 'Calibri'),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff392850), width: 2.0))),
                            validator: (val) {
                              if (BusinessNatureValue == 'Other' &&
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
                            "${widget.typeOfPerson} is a ?",
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
                                        value: "Owner",
                                        title: const Text(
                                          "Owner",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Calibri',
                                              fontSize: 18.0),
                                        ),
                                        groupValue: BusinessOwnershipValue,
                                        onChanged: (value) {
                                          setState(() {
                                            BusinessOwnershipValue = value!;
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
                                        groupValue: BusinessOwnershipValue,
                                        onChanged: (value) {
                                          setState(() {
                                            BusinessOwnershipValue = value!;
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
                                        groupValue: BusinessOwnershipValue,
                                        onChanged: (value) {
                                          setState(() {
                                            BusinessOwnershipValue = value!;
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
                          TextFormField(
                            enabled: BusinessOwnershipValue == 'Tenant',
                            controller: TenantrentController,
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
                              if (BusinessOwnershipValue == 'Tenant' &&
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
                          const Text(
                            "If Other Mention Above:",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Calibri',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          TextFormField(
                            enabled: BusinessOwnershipValue == 'Other',
                            controller: specifyotherController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white54,
                                hintText: "Specify Other Here.",
                                hintStyle: TextStyle(fontFamily: 'Calibri'),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff392850), width: 2.0))),
                            validator: (val) {
                              if (BusinessOwnershipValue == 'Other' &&
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
                            "Business Legal Entity:",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Calibri',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          ListTileTheme(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RadioListTile<String>(
                                      activeColor: Color(0xff392850),
                                      value: "Proprietor",
                                      title: const Text(
                                        "Proprietor",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Calibri',
                                            fontSize: 18.0),
                                      ),
                                      groupValue: BusinesLegalEntityValue,
                                      onChanged: (value) {
                                        setState(() {
                                          BusinesLegalEntityValue = value!;
                                        });
                                      }),
                                  RadioListTile<String>(
                                      activeColor: Color(0xff392850),
                                      value: "Partnership",
                                      title: const Text(
                                        "Partnership",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Calibri',
                                            fontSize: 18.0),
                                      ),
                                      groupValue: BusinesLegalEntityValue,
                                      onChanged: (value) {
                                        setState(() {
                                          BusinesLegalEntityValue = value!;
                                        });
                                      }),
                                  RadioListTile<String>(
                                      activeColor: Color(0xff392850),
                                      value: "Pvt. Ltd",
                                      title: const Text(
                                        "Pvt. Ltd",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Calibri',
                                            fontSize: 18.0),
                                      ),
                                      groupValue: BusinesLegalEntityValue,
                                      onChanged: (value) {
                                        setState(() {
                                          BusinesLegalEntityValue = value!;
                                        });
                                      }),
                                  RadioListTile<String>(
                                      activeColor: Color(0xff392850),
                                      value: "Public Ltd",
                                      title: const Text(
                                        "Public Ltd",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Calibri',
                                            fontSize: 18.0),
                                      ),
                                      groupValue: BusinesLegalEntityValue,
                                      onChanged: (value) {
                                        setState(() {
                                          BusinesLegalEntityValue = value!;
                                        });
                                      }),
                                  RadioListTile<String>(
                                      activeColor: Color(0xff392850),
                                      value: "Govt.",
                                      title: const Text(
                                        "Govt.",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Calibri',
                                            fontSize: 18.0),
                                      ),
                                      groupValue: BusinesLegalEntityValue,
                                      onChanged: (value) {
                                        setState(() {
                                          BusinesLegalEntityValue = value!;
                                        });
                                      }),
                                ],
                              )),
                          TextFormField(
                            enabled: BusinesLegalEntityValue == 'Govt.',
                            controller: GovtbusinessController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white54,
                                hintText: "If Govt Selected then Mention Here.",
                                hintStyle: TextStyle(fontFamily: 'Calibri'),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff392850), width: 2.0))),
                            validator: (val) {
                              if (BusinesLegalEntityValue == 'Govt.' &&
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
                            "Was Business Name Plate affixed at Business Place (Same as in application) ?",
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
                                        groupValue: BusinessNamePlateValue,
                                        onChanged: (value) {
                                          setState(() {
                                            BusinessNamePlateValue = value!;
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
                                        groupValue: BusinessNamePlateValue,
                                        onChanged: (value) {
                                          setState(() {
                                            BusinessNamePlateValue = value!;
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
                            "Business Activity",
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
                                        value: "Low",
                                        title: const Text(
                                          "Low",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Calibri',
                                              fontSize: 18.0),
                                        ),
                                        groupValue: BusinessActivityValue,
                                        onChanged: (value) {
                                          setState(() {
                                            BusinessActivityValue = value!;
                                          });
                                        }),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                        activeColor: Color(0xff392850),
                                        value: "Medium",
                                        title: const Text(
                                          "Medium",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Calibri',
                                              fontSize: 18.0),
                                        ),
                                        groupValue: BusinessActivityValue,
                                        onChanged: (value) {
                                          setState(() {
                                            BusinessActivityValue = value!;
                                          });
                                        }),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                        activeColor: Color(0xff392850),
                                        value: "High",
                                        title: const Text(
                                          "High",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Calibri',
                                              fontSize: 18.0),
                                        ),
                                        groupValue: BusinessActivityValue,
                                        onChanged: (value) {
                                          setState(() {
                                            BusinessActivityValue = value!;
                                          });
                                        }),
                                  ),
                                ],
                              )),
                          const Divider(),
                          const SizedBox(
                            height: 5.0,
                          ),
                        ],
                      )),
                      const Text(
                        "Size (Approx Area) :",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: approxAreaController,
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
                        "No. of Employees:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: NoOfemployeeController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter No. of Employees Here",
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
                        "Business Established Since (Current):",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      TextFormField(
                        controller: businessestablishDateCTR,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            hintText: "Enter Business Established Since Here",
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
                    ]),
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
                          if (_OfficeverifyformKey.currentState!.validate() &&
                              BusinesstypeValue.isNotEmpty &&
                              BusinessNatureValue.isNotEmpty &&
                              BusinessOwnershipValue.isNotEmpty &&
                              BusinesLegalEntityValue.isNotEmpty &&
                              BusinessNamePlateValue.isNotEmpty &&
                              BusinessActivityValue.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return finalDialog(
                                      context,
                                      "All Fields are Completed!",
                                      "Do you want to save it?",
                                      "Save", () async {
                                    SaveBusinessData();
                                    await DBHelper.createWorkOfficeDb(
                                        businessWorkOfficeDetail);
                                    await DBHelper.updateOfficeStatus(
                                        InquiryStatus.PartialCompleted,
                                        widget.OfficewrkID);
                                    await DBHelper.UpdateOffInquiryStatus(
                                        widget.inquiryID);
                                    await DBHelper.updateInquiryTableStatus(
                                        widget.inquiryID);
                                    await DBHelper.updateOffWRKstatus(
                                        widget.OfficewrkID,
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
                                                      widget.OfficewrkID,
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
                              "Exception on Business_Office_Verification: ${e.toString()}");
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
