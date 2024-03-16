import 'package:flutter/material.dart';
import 'package:pvs/Verifications/Residence_Verification/Applicant/Neighbor_verification.dart';
import 'package:pvs/Verifications/Residence_Verification/Applicant/Profile_verification.dart';
import 'package:pvs/Verifications/Residence_Verification/Applicant/generalcomments.dart';
import '../../../Database/Database_Helper.dart';
import '../../../Module For Post Data/Post_inquires_model..dart';
import '../../../Module for Get Data/Inquires_response.dart';
import '../../../Screens/PreviewImage.dart';
import '../../../Screens/assigned_inq_screen.dart';
import '../../../Widgets/Card_Widgets/Residence_customcard.dart';
import '../../../Widgets/Dialogbox.dart';
import '../../../Widgets/InquiryTypes.dart';
import '../../../Widgets/Inquiry_status.dart';
import '../../../Widgets/Logs/Logeger.dart';
import 'Home_verification.dart';
import 'Neighbor2.dart';

class ApplicantResidenceverifiy extends StatefulWidget {
  ApplicantResidenceverifiy(
      {super.key,
      this.residenceVerified,
      required this.PersonType,
      required this.residenceAddress,
      required this.nearestLandmark,
      required this.NameofPerson,
      required this.verifucationID,
      required this.InquiryId});
  final List<ResidenceVerifications>? residenceVerified;
  final String PersonType;
  final String NameofPerson;
  final String residenceAddress;
  final String nearestLandmark;
  final int verifucationID;
  final int InquiryId;
  @override
  State<ApplicantResidenceverifiy> createState() =>
      _ApplicantResidenceverifiyState();
}

class _ApplicantResidenceverifiyState extends State<ApplicantResidenceverifiy> {
  String verType = InquiryTypes.ResidenceVerification;
  NeighbourCheck neighbrOneData = NeighbourCheck();
  NeighbourCheck Neigbr2Data = NeighbourCheck();
  saveNeighbor1Data() {
    try {
      NeighbourCheck neighbourCheckdata = NeighbourCheck(
          InquiryId: widget.InquiryId,
          ResidenceVerificationId: widget.verifucationID,
          NeighborName: 'Not-Applicable',
          NeighborAddress: 'Not-Applicable',
          KnowsApplicant: 'false',
          KnowsHowLong: 'Not-Applicable',
          NeighborComments: 'Not-Applicable');
      neighbrOneData = neighbourCheckdata;
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on saveNeighborData ApplicantResidenceNeighbor: ${e.toString()}");
    }
  }

  saveNeighbor2Data() {
    try {
      NeighbourCheck neighbourCheckdata = NeighbourCheck(
          NeighborsName2: 'Not-Applicable',
          NeighborsAddress2: 'Not-Applicable',
          KnowsApplicant2: 'false',
          KnowsHowLong2: 'Not-Applicable',
          NeighborComments2: 'Not-Applicable');
      Neigbr2Data = neighbourCheckdata;
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on saveNeighborData ApplicantResidenceNeighbor: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AssignedInquiries(
                            InquiryID: widget.InquiryId,
                          )));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
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
        children: [
          Residence_CustomCard(
              TypeofPerson: widget.PersonType,
              Name: widget.NameofPerson,
              Address: widget.residenceAddress,
              Landmark: widget.nearestLandmark),
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    try {
                      List<ResidenceDetail> detail =
                          await DBHelper.GetResidenceDetails(
                              widget.verifucationID);
                      bool checkStatus = detail.any((element) =>
                          element.Status == InquiryStatus.PartialCompleted);
                      if (detail.isEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ApplicantHomeverification(
                                      ApplicantHomeVerified:
                                          widget.residenceVerified,
                                      NameofPerson: widget.NameofPerson,
                                      PersonType: widget.PersonType,
                                      nearestLandmark: widget.nearestLandmark,
                                      residenceAddress: widget.residenceAddress,
                                      resVerId: widget.verifucationID,
                                      Inquiryid: widget.InquiryId,
                                    )));
                      } else if (checkStatus == true) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreviewImage(
                                      Vtype: verType,
                                      inquiryid: widget.InquiryId,
                                      Persntype: widget.PersonType,
                                      capimages: null,
                                      verifyID: widget.verifucationID,
                                      subVertype:
                                          InquiryTypes.ResidenceNeighbor,
                                    )));
                      } else if (detail.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              "This inquiry is Completed!",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Calibri'),
                            )));
                      }
                    } on Exception catch (e) {
                      EVSLogger.appendLog(
                          "Exception in ApplicantResidenceverifiy on GetResidenceDetails method: ${e.toString()}");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff392850), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.home_sharp,
                                color: Colors.black,
                                size: 25.0,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              const Text(
                                "Residence Verification",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.0,
                                    fontFamily: 'Calibri',
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.black,
                            size: 25.0,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    try {
                      List<ResidenceProfile> prof =
                          await DBHelper.GetResidenceProfile(
                              widget.verifucationID);
                      bool checkStatus = prof.any((element) =>
                          element.Status == InquiryStatus.PartialCompleted);
                      if (prof.isEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ApplicantResidenceProfile(
                                      ApplicantProfileVerified:
                                          widget.residenceVerified,
                                      NameofPerson: widget.NameofPerson,
                                      nearestLandmark: widget.nearestLandmark,
                                      PersonType: widget.PersonType,
                                      residenceAddress: widget.residenceAddress,
                                      resVerID: widget.verifucationID,
                                      InQuiryID: widget.InquiryId,
                                    )));
                      } else if (prof.isNotEmpty || checkStatus == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              "This inquiry is Completed!",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Calibri'),
                            )));
                      }
                    } on Exception catch (e) {
                      EVSLogger.appendLog(
                          "Exception in ApplicantResidenceverifiy on GetResidenceProfile method: ${e.toString()}");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff392850), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.person_sharp,
                                color: Colors.black,
                                size: 25.0,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              const Text(
                                "Residence Profile",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.0,
                                    fontFamily: 'Calibri',
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.black,
                            size: 25.0,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    try {
                      List<NeighbourCheck> nghbr =
                          await DBHelper.GetResidenceNeighbor(
                              widget.verifucationID);
                      bool checkStatus = nghbr.any((element) =>
                          element.Status == InquiryStatus.PartialCompleted);
                      if (nghbr.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext contextt) {
                              return NeighbrDialog(
                                  contextt,
                                  'Residence Neighbor One',
                                  'Select any Option',
                                  'Fill Form',
                                  'Not-Applicable', () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ApplicantResidenceNeighbor(
                                              ApplicantNeighbourVerified:
                                                  widget.residenceVerified,
                                              NameofPerson: widget.NameofPerson,
                                              PersonType: widget.PersonType,
                                              nearestLandmark:
                                                  widget.nearestLandmark,
                                              residenceAddress:
                                                  widget.residenceAddress,
                                              resVerID: widget.verifucationID,
                                              Inquiryid: widget.InquiryId,
                                            )));
                              }, () {
                                Navigator.pop(contextt);
                                showDialog(
                                    context: contextt,
                                    builder: (BuildContext contexttt) {
                                      return NeighbrfinalyesDialog(
                                          contexttt,
                                          'Residence Neighbor One',
                                          'Are you sure?',
                                          'yes', () async {
                                        Navigator.pop(contexttt);
                                        saveNeighbor1Data();
                                        await DBHelper.createResidenceNeighbor(
                                            neighbrOneData);
                                        await DBHelper.updateResidenceStatus(
                                            InquiryStatus.PartialCompleted,
                                            widget.verifucationID);
                                        await DBHelper.UpdateRInquiryStatus(
                                            widget.InquiryId);
                                        await DBHelper.updateInquiryTableStatus(
                                            widget.InquiryId);
                                        await DBHelper.updateResNeighborstatus(
                                            widget.verifucationID,
                                            InquiryStatus.Completed);

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
                              });
                            });
                      } else if (nghbr.isNotEmpty || checkStatus == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              "This inquiry is Completed!",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Calibri'),
                            )));
                      }
                    } on Exception catch (e) {
                      EVSLogger.appendLog(
                          "Exception in ApplicantResidenceverifiy on GetResidenceNeighbor method: ${e.toString()}");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff392850), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.people_alt_sharp,
                                color: Colors.black,
                                size: 25.0,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              const Text(
                                "Neighbor Check",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.0,
                                    fontFamily: 'Calibri',
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.black,
                            size: 25.0,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    try {
                      List<NeighbourCheck> nghbr =
                          await DBHelper.GetResidenceNeighbor(
                              widget.verifucationID);
                      bool checkStatus = nghbr.any((element) =>
                          element.Status2 == InquiryStatus.Completed);
                      if (nghbr.isEmpty || checkStatus == false) {
                        showDialog(
                            context: context,
                            builder: (BuildContext contextt) {
                              return NeighbrDialog(
                                  contextt,
                                  'Residence Neighbor Two',
                                  'Select any Option',
                                  'Fill Form',
                                  'Not-Applicable', () {
                                Navigator.of(contextt).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ApplicantResidenceNeighbor2(
                                              ApplicantNeighbourVerified:
                                                  widget.residenceVerified,
                                              NameofPerson: widget.NameofPerson,
                                              PersonType: widget.PersonType,
                                              nearestLandmark:
                                                  widget.nearestLandmark,
                                              residenceAddress:
                                                  widget.residenceAddress,
                                              resVerID: widget.verifucationID,
                                              Inquiryid: widget.InquiryId,
                                            )));
                              }, () {
                                Navigator.pop(contextt);
                                showDialog(
                                    context: contextt,
                                    builder: (BuildContext contexttt) {
                                      return NeighbrfinalyesDialog(
                                          context,
                                          'Residence Neighbor Two',
                                          'Are you sure?',
                                          'yes', () async {
                                        Navigator.pop(contexttt);
                                        saveNeighbor2Data();
                                        await DBHelper
                                            .updateResidenceNeighborchk2data(
                                                widget.verifucationID,
                                                Neigbr2Data);
                                        await DBHelper.updateResidenceStatus(
                                            InquiryStatus.PartialCompleted,
                                            widget.verifucationID);
                                        await DBHelper.UpdateRInquiryStatus(
                                            widget.InquiryId);
                                        await DBHelper.updateInquiryTableStatus(
                                            widget.InquiryId);
                                        await DBHelper.updateResNeighbor2status(
                                            widget.verifucationID,
                                            InquiryStatus.Completed);

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
                              });
                            });
                      } else if (nghbr.isNotEmpty || checkStatus == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              "This inquiry is Completed!",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Calibri'),
                            )));
                      }
                    } on Exception catch (e) {
                      EVSLogger.appendLog(
                          "Exception in ApplicantResidenceverifiy on GetResidenceNeighbor method: ${e.toString()}");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff392850), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.people_alt_sharp,
                                color: Colors.black,
                                size: 25.0,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              const Text(
                                "Neighbor Check 2",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.0,
                                    fontFamily: 'Calibri',
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.black,
                            size: 25.0,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    try {
                      List<ResidenceDetail> detail =
                          await DBHelper.GetResidenceDetails(
                              widget.verifucationID);
                      List<ResidenceProfile> prof =
                          await DBHelper.GetResidenceProfile(
                              widget.verifucationID);
                      List<NeighbourCheck> nghbr =
                          await DBHelper.GetResidenceNeighbor(
                              widget.verifucationID);
                      if (detail.isEmpty || prof.isEmpty || nghbr.isEmpty) {
                        MyDialog.show(context,
                            "Kindly complete office required verifications");
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                      } else if (detail.isNotEmpty &&
                          prof.isNotEmpty &&
                          nghbr.isNotEmpty) {
                        bool allListsContainWidgetInquiryId = detail.any(
                                (element) =>
                                    element.ResidenceVerificationId ==
                                    widget.verifucationID) &&
                            prof.any((element) =>
                                element.ResidenceVerificationId ==
                                widget.verifucationID) &&
                            nghbr.any((element) =>
                                element.ResidenceVerificationId ==
                                widget.verifucationID);
                        if (allListsContainWidgetInquiryId) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResidenceGeneralComment(
                                        Persontype: widget.PersonType,
                                        PersonName: widget.NameofPerson,
                                        Landmark: widget.nearestLandmark,
                                        PersonAddress: widget.residenceAddress,
                                        resVerid: widget.verifucationID,
                                        inqid: widget.InquiryId,
                                      )));
                        } else {
                          MyDialog.show(context,
                              "Kindly complete office required verifications");
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.of(context, rootNavigator: true).pop();
                          });
                        }
                      }
                    } on Exception catch (e) {
                      EVSLogger.appendLog(
                          "Exception on ApplicantResidenceverifiy: ${e.toString()}");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff392850), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.comment_sharp,
                                color: Colors.black,
                                size: 25.0,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              const Text(
                                "General Comments & Outcome",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.0,
                                    fontFamily: 'Calibri',
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.black,
                            size: 25.0,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
