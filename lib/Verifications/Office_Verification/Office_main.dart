import 'package:flutter/material.dart';
import 'package:pvs/Verifications/Office_Verification/Neighbor_Market_verify.dart';
import 'package:pvs/Verifications/Office_Verification/Office_HR_verify.dart';
import 'package:pvs/Verifications/Office_Verification/Office_business_verification.dart';
import 'package:pvs/Verifications/Office_Verification/officeAddress_verification.dart';
import 'package:pvs/Verifications/Office_Verification/office_general_comments.dart';
import '../../Database/Database_Helper.dart';
import '../../Module For Post Data/Post_inquires_model..dart';
import '../../Module for Get Data/Inquires_response.dart';
import '../../Screens/PreviewImage.dart';
import '../../Screens/assigned_inq_screen.dart';
import '../../Widgets/Card_Widgets/Office_CustomCard.dart';
import '../../Widgets/Dialogbox.dart';
import '../../Widgets/InquiryTypes.dart';
import '../../Widgets/Inquiry_status.dart';
import '../../Widgets/Logs/Logeger.dart';
import 'Neighbor2chk.dart';

class VerificationOfOffice extends StatefulWidget {
  VerificationOfOffice(
      {super.key,
      this.workofficeverified,
      required this.NameofOffice,
      required this.AddressofOffice,
      required this.NameofPerson,
      required this.Landmark,
      required this.typeofPerson,
      required this.OfficeVerID,
      required this.INQid});
  final List<WorkOfficeVerifications>? workofficeverified;
  final String NameofOffice;
  final String AddressofOffice;
  final String NameofPerson;
  final String Landmark;
  final String typeofPerson;
  final int OfficeVerID;
  final int INQid;

  @override
  State<VerificationOfOffice> createState() => _VerificationOfOfficeState();
}

class _VerificationOfOfficeState extends State<VerificationOfOffice> {
  String verificationType = InquiryTypes.OfficeVerification;
  MarketeCheck noApplicablen2Data = MarketeCheck();
  MarketeCheck noApplicablenData = MarketeCheck();
  NotApplicableNeighborOne() {
    MarketeCheck mchk = MarketeCheck(
      WorkOfficeVerificationId: widget.OfficeVerID,
      InquiryId: widget.INQid,
      NeighborsAddress: 'Not-Applicable',
      NeighborsName: 'Not-Applicable',
      KnowsApplicant: 'false',
      KnowsHowint: 'Not-Applicable',
      NeighborComments: 'Not-Applicable',
      BusinessEstablishedSinceMarketeCheck: 'Not-Applicable',
    );
    noApplicablenData = mchk;
  }

  NotApplicableNeighborTwo() {
    MarketeCheck marktchk = MarketeCheck(
      NeighborsTwoName: 'Not-Applicable',
      NeighborsTwoAddress: 'Not-Applicable',
      NeighborsTwoKnowsApplicant: 'false',
      NeighborsTwoKnowsHowLong: 'Not-Applicable',
      NeighborsTwoBusinessEstablishedSinceMarketeCheck: 'Not-Applicable',
      NeighborsTwoNeighborComments: 'Not-Applicable',
    );
    noApplicablen2Data = marktchk;
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
                            InquiryID: widget.INQid,
                          )));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Color(0xff392850),
        title: Text(
          "Office/Business Verification (${widget.typeofPerson})",
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
          OfficeCustomCard(
              NameofOffice: widget.NameofOffice,
              AddressofOffice: widget.AddressofOffice,
              NameofPerson: widget.NameofPerson,
              Landmark: widget.Landmark,
              typeOfPerson: widget.typeofPerson),
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    try {
                      List<OfficeAddressDetail> addres =
                          await DBHelper.GetOfficeAddress(widget.OfficeVerID);
                      bool checkStatus = addres.any((element) =>
                          element.Status == InquiryStatus.PartialCompleted);

                      if (addres.isEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OfficeAddressVerification(
                                      workofficeverified:
                                          widget.workofficeverified,
                                      AddressofOffice: widget.AddressofOffice,
                                      Landmark: widget.Landmark,
                                      NameofOffice: widget.NameofOffice,
                                      NameofPerson: widget.NameofPerson,
                                      typeOfperson: widget.typeofPerson,
                                      OfficeVerId: widget.OfficeVerID,
                                      Inquiryidd: widget.INQid,
                                    )));
                      } else if (checkStatus == true) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WillPopScope(
                                    onWillPop: () async {
                                      return false;
                                    },
                                    child: PreviewImage(
                                      Persntype: widget.typeofPerson,
                                      capimages: null,
                                      Vtype: verificationType.toString(),
                                      inquiryid: widget.INQid,
                                      verifyID: widget.OfficeVerID,
                                      subVertype: InquiryTypes.WorkOffice,
                                    ),
                                  )),
                        );
                      } else if (addres.isNotEmpty || checkStatus == true) {
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
                          "Exception in VerificationOfOffice Screen on GetOfficeAddress method: ${e.toString()} ");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80.0,
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
                                "Office Address Verification",
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
                      List<BusinessWorkOfficeDetail> work =
                          await DBHelper.GetworkOfficeDetails(
                              widget.OfficeVerID);
                      bool checkStatus = work.any((element) =>
                          element.Status == InquiryStatus.PartialCompleted);
                      if (work.isEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Business_Office_Verification(
                                      workofficeverified:
                                          widget.workofficeverified,
                                      AddressofOffice: widget.AddressofOffice,
                                      Landmark: widget.Landmark,
                                      NameofOffice: widget.NameofOffice,
                                      NameofPerson: widget.NameofPerson,
                                      typeOfPerson: widget.typeofPerson,
                                      OfficewrkID: widget.OfficeVerID,
                                      inquiryID: widget.INQid,
                                    )));
                      } else if (work.isNotEmpty || checkStatus == true) {
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
                          "Exception in VerificationOfOffice Screen on GetworkOfficeDetails method ${e.toString()} ");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff392850), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 5.0,
                      ),
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
                              SizedBox(
                                width: 5.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    "Business/Work/Office Verification",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25.0,
                                        fontFamily: 'Calibri',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
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
                      List<OfficeHRDetail> hr =
                          await DBHelper.GetOffieHRchk(widget.OfficeVerID);
                      bool checkStatus = hr.any((element) =>
                          element.Status == InquiryStatus.PartialCompleted);
                      if (hr.isEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OfficeHRVerification(
                                      workofficeverified:
                                          widget.workofficeverified,
                                      AddressofOffice: widget.AddressofOffice,
                                      Landmark: widget.Landmark,
                                      NameofOffice: widget.NameofOffice,
                                      NameofPerson: widget.NameofPerson,
                                      typeOfPerson: widget.typeofPerson,
                                      officeverID: widget.OfficeVerID,
                                      inquiryID: widget.INQid,
                                    )));
                      } else if (hr.isNotEmpty || checkStatus == true) {
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
                          "Exception in VerificationOfOffice Screen on GetOffieHRchk method: ${e.toString()} ");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80.0,
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
                                Icons.business_sharp,
                                color: Colors.black,
                                size: 25.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Office/HR Verification",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25.0,
                                        fontFamily: 'Calibri',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
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
                      List<MarketeCheck> market =
                          await DBHelper.GetofficeMarketchk(widget.OfficeVerID);
                      bool checkStatus = market.any((element) =>
                          element.Status == InquiryStatus.Completed);
                      if (market.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext contextt) {
                              return NeighbrDialog(
                                  context,
                                  'Office Neighbor One',
                                  'Select any Option',
                                  'Fill Form',
                                  'Not-Applicable', () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OfficeNeighborVerification(
                                              workofficeverified:
                                                  widget.workofficeverified,
                                              AddressofOffice:
                                                  widget.AddressofOffice,
                                              Landmark: widget.Landmark,
                                              NameofOffice: widget.NameofOffice,
                                              NameofPerson: widget.NameofPerson,
                                              typeOfPerson: widget.typeofPerson,
                                              officewrkid: widget.OfficeVerID,
                                              InqID: widget.INQid,
                                            )));
                              }, () {
                                Navigator.pop(contextt);
                                showDialog(
                                    context: contextt,
                                    builder: (BuildContext contexttt) {
                                      return NeighbrfinalyesDialog(
                                          context,
                                          'Office Neighbor One',
                                          'Are you sure?',
                                          'yes', () async {
                                        Navigator.pop(contexttt);
                                        NotApplicableNeighborOne();
                                        await DBHelper
                                            .createOfficeMarketCheckdb(
                                                noApplicablenData);
                                        await DBHelper.updateOfficeStatus(
                                            InquiryStatus.PartialCompleted,
                                            widget.OfficeVerID);
                                        await DBHelper.UpdateOffInquiryStatus(
                                            widget.INQid);
                                        await DBHelper.updateInquiryTableStatus(
                                            widget.INQid);
                                        await DBHelper.updateOffMARKstatus(
                                            widget.OfficeVerID,
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
                      } else if (market.isNotEmpty || checkStatus == true) {
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
                          "Exception in VerificationOfOffice Screen on GetofficeMarketchk method: ${e.toString()}");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80.0,
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
                              SizedBox(
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
                      List<MarketeCheck> market =
                          await DBHelper.GetofficeMarketchk(widget.OfficeVerID);

                      bool checkStatus = market.any((element) =>
                          element.Status2 == InquiryStatus.Completed);
                      if (market.isEmpty || checkStatus == false) {
                        showDialog(
                            context: context,
                            builder: (BuildContext contextt) {
                              return NeighbrDialog(
                                  context,
                                  'Office Neighbor Two',
                                  'Select any Option',
                                  'Fill Form',
                                  'Not-Applicable', () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OfficeNeighborVerification2(
                                              workofficeverified:
                                                  widget.workofficeverified,
                                              AddressofOffice:
                                                  widget.AddressofOffice,
                                              Landmark: widget.Landmark,
                                              NameofOffice: widget.NameofOffice,
                                              NameofPerson: widget.NameofPerson,
                                              typeOfPerson: widget.typeofPerson,
                                              officewrkid: widget.OfficeVerID,
                                              InqID: widget.INQid,
                                            )));
                              }, () {
                                Navigator.pop(contextt);
                                showDialog(
                                    context: contextt,
                                    builder: (BuildContext contexttt) {
                                      return NeighbrfinalyesDialog(
                                          context,
                                          'Office Neighbor Two',
                                          'Are you sure?',
                                          'yes', () async {
                                        Navigator.pop(contexttt);
                                        NotApplicableNeighborTwo();
                                        await DBHelper.updateMarketchk2data(
                                            widget.OfficeVerID,
                                            noApplicablen2Data);
                                        await DBHelper.updateOfficeStatus(
                                            InquiryStatus.PartialCompleted,
                                            widget.OfficeVerID);
                                        await DBHelper.UpdateOffInquiryStatus(
                                            widget.INQid);
                                        await DBHelper.updateInquiryTableStatus(
                                            widget.INQid);
                                        await DBHelper.updateOffMARK2status(
                                            widget.OfficeVerID,
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
                      } else if (market.isNotEmpty || checkStatus == true) {
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
                          "Exception in VerificationOfOffice Screen on GetofficeMarketchk method: ${e.toString()}");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80.0,
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
                              SizedBox(
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
                      List<OfficeAddressDetail> addres =
                          await DBHelper.GetOfficeAddress(widget.OfficeVerID);
                      List<BusinessWorkOfficeDetail> work =
                          await DBHelper.GetworkOfficeDetails(
                              widget.OfficeVerID);
                      List<OfficeHRDetail> hr =
                          await DBHelper.GetOffieHRchk(widget.OfficeVerID);
                      List<MarketeCheck> market =
                          await DBHelper.GetofficeMarketchk(widget.OfficeVerID);

                      if (addres.isEmpty ||
                          work.isEmpty ||
                          hr.isEmpty ||
                          market.isEmpty) {
                        MyDialog.show(context,
                            "Kindly complete office required verifications");
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                      } else if (addres.isNotEmpty &&
                          work.isNotEmpty &&
                          hr.isNotEmpty &&
                          market.isNotEmpty) {
                        bool allListsContainWidgetInquiryId = addres.any(
                                (element) =>
                                    element.InquiryId == widget.INQid) &&
                            work.any((element) =>
                                element.InquiryId == widget.INQid) &&
                            hr.any((element) =>
                                element.InquiryId == widget.INQid) &&
                            market.any((element) =>
                                element.InquiryId == widget.INQid &&
                                element.Status2 == InquiryStatus.Completed &&
                                element.Status == InquiryStatus.Completed);
                        if (allListsContainWidgetInquiryId) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OfficeGeneralComment(
                                        PersonType: widget.typeofPerson,
                                        NameofPerson: widget.NameofPerson,
                                        officeAddress: widget.AddressofOffice,
                                        nearestLandmark: widget.Landmark,
                                        OfficeName: widget.NameofOffice,
                                        officewrkID: widget.OfficeVerID,
                                        inquirid: widget.INQid,
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
                          "Exception on VerificationOfOffice ${e.toString()}");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80.0,
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
                              SizedBox(
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
