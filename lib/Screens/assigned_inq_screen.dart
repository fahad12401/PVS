import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pvs/Screens/Inquires_Screen.dart';
import 'package:pvs/Screens/PreviewImage.dart';
import '../Database/Database_Helper.dart';
import '../Module for Get Data/Inquires_response.dart';
import '../Verifications/Bank_Statement_Verification/Bank_state_verify.dart';
import '../Verifications/Office_Verification/Office_main.dart';
import '../Verifications/Residence_Verification/Applicant/MainPage.dart';
import '../Verifications/SalarySlip_verification/Salaryslip_verify.dart';
import '../Verifications/Tenent_verification/Tenant_verify.dart';
import '../Widgets/InquiryTypes.dart';
import '../Widgets/Inquiry_status.dart';
import '../Widgets/Logs/Logeger.dart';

class AssignedInquiries extends StatefulWidget {
  AssignedInquiries({
    super.key,
    this.InquiryID,
  });
  final int? InquiryID;
  @override
  State<AssignedInquiries> createState() => _AssignedInquiriesState();
}

class _AssignedInquiriesState extends State<AssignedInquiries> {
  Future<List<BankStatementVerifications>> fetchBankData() async {
    bankStatementVerify = await DBHelper.AssignBankData(widget.InquiryID!);
    return bankStatementVerify;
  }

  Future<List<TenantVerifications>> fetchTenantData() async {
    tenantVerify = await DBHelper.AssignTenantData(widget.InquiryID!);
    return tenantVerify;
  }

  Future<List<SalarySlipVerifications>> fetchSalaryData() async {
    salarySlipVerify = await DBHelper.AssignSalaryData(widget.InquiryID!);
    return salarySlipVerify;
  }

  Future<List<ResidenceVerifications>> fetchResidenceData() async {
    residenceverifys = await DBHelper.AssignResidenceData(widget.InquiryID!);
    return residenceverifys;
  }

  Future<List<WorkOfficeVerifications>> fetchOfficeData() async {
    workOfficeVerify = await DBHelper.AssignOfficeData(widget.InquiryID!);
    return workOfficeVerify;
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.white60,
        appBar: AppBar(
          backgroundColor: Color(0xff392850),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => InquiresScreen()));
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          title: const Text(
            "Verification Types",
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
              FutureBuilder(
                  future: fetchBankData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<BankStatementVerifications>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: bankStatementVerify.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (bankStatementVerify[index].Status ==
                                      InquiryStatus.InProgress) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BankVerificationofStatment(
                                                  bankofficeverified:
                                                      bankStatementVerify,
                                                  NameOfBank:
                                                      bankStatementVerify[index]
                                                          .BankName
                                                          .toString(),
                                                  NameOfPerson:
                                                      bankStatementVerify[index]
                                                          .PersonName
                                                          .toString(),
                                                  landmark:
                                                      bankStatementVerify[index]
                                                          .NearestLandMark
                                                          .toString(),
                                                  typeofPerson:
                                                      bankStatementVerify[index]
                                                          .PersonType
                                                          .toString(),
                                                  bankverID: bankStatementVerify[
                                                          index]
                                                      .BankStatementVerificationId!
                                                      .toInt(),
                                                  InqID:
                                                      bankStatementVerify[index]
                                                          .InquiryId!
                                                          .toInt(),
                                                )));
                                  } else if (bankStatementVerify[index]
                                          .Status ==
                                      InquiryStatus.PartialCompleted) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PreviewImage(
                                                  verifyID: bankStatementVerify[
                                                          index]
                                                      .BankStatementVerificationId,
                                                  Persntype:
                                                      bankStatementVerify[index]
                                                          .PersonType,
                                                  inquiryid:
                                                      bankStatementVerify[index]
                                                          .InquiryId,
                                                  Vtype: InquiryTypes
                                                      .BankStatementVerification,
                                                  capimages: null,
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 5),
                                            content: Text(
                                              "The Inquiry is Completed",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Calibri'),
                                            )));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0, top: 2.0),
                                  child: LayoutBuilder(
                                      builder: (context, constraints) {
                                    return Card(
                                      elevation: 3.0,
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxHeight: constraints.maxHeight),
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 11.0,
                                              right: 5.0,
                                              top: 10.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  "${bankStatementVerify[index].PersonType}'s Bank Statement Verification",
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                    fontFamily: 'Calibri',
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff392850),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 7.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                        "${bankStatementVerify[index].PersonType}'s Name: ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri')),
                                                    Expanded(
                                                      child: Text(
                                                        "${bankStatementVerify[index].PersonName}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri'),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 2.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                        "${bankStatementVerify[index].PersonType}'s Contact No: ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri')),
                                                    Text(
                                                      "${bankStatementVerify[index].PersonContactNo}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20.0,
                                                          fontFamily:
                                                              'Calibri'),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 2.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    const Text("Bank Name: ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri')),
                                                    Expanded(
                                                      child: Text(
                                                        "${bankStatementVerify[index].BankName}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri'),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 2.0,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    const Text("Bank Address: ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri')),
                                                    Expanded(
                                                      child: Text(
                                                        "${bankStatementVerify[index].BankAddress}",
                                                        overflow:
                                                            TextOverflow.clip,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri'),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 2.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    const Text(
                                                        "Nearest Landmark: ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri')),
                                                    Expanded(
                                                      child: Text(
                                                        "${bankStatementVerify[index].NearestLandMark}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri'),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 2.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    const Text("Status:  ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri')),
                                                    Text(
                                                      "${bankStatementVerify[index].Status}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.orange,
                                                          fontSize: 21.0,
                                                          fontFamily:
                                                              'Calibri'),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            });
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SpinKitThreeBounce(
                        size: 12.0,
                        color: Colors.white38,
                      );
                    } else {
                      return Text(
                        "Error While Loading Data",
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          fontSize: 20,
                        ),
                      );
                    }
                  }),
              FutureBuilder(
                  future: fetchResidenceData(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: residenceverifys.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (residenceverifys[index].Status ==
                                          InquiryStatus.InProgress ||
                                      residenceverifys[index].Status ==
                                          InquiryStatus.PartialCompleted) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ApplicantResidenceverifiy(
                                                  verifucationID:
                                                      residenceverifys[index]
                                                          .ResidenceVerificationId!
                                                          .toInt(),
                                                  residenceVerified:
                                                      residenceverifys,
                                                  PersonType:
                                                      residenceverifys[index]
                                                          .PersonType
                                                          .toString(),
                                                  residenceAddress:
                                                      residenceverifys[index]
                                                          .ResidenceAddress
                                                          .toString(),
                                                  nearestLandmark:
                                                      residenceverifys[index]
                                                          .NearestLandMark
                                                          .toString(),
                                                  NameofPerson:
                                                      residenceverifys[index]
                                                          .PersonName
                                                          .toString(),
                                                  InquiryId:
                                                      residenceverifys[index]
                                                          .InquiryId!
                                                          .toInt(),
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 5),
                                            content: Text(
                                              "The Inquiry is Completed",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Calibri'),
                                            )));
                                  }
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0, top: 2.0),
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      return Card(
                                        elevation: 3.0,
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxHeight: constraints.maxHeight),
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 11.0,
                                                right: 5.0,
                                                top: 10.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    "${residenceverifys[index].PersonType} Residence Verification",
                                                    style: TextStyle(
                                                      fontSize: 25.0,
                                                      fontFamily: 'Calibri',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff392850),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 7.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          "${residenceverifys[index].PersonType}'s Name: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${residenceverifys[index].PersonName}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          "${residenceverifys[index].PersonType}'s Contact No: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Text(
                                                        "${residenceverifys[index].PersonContactNo}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri'),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      const Text(
                                                          "Residence Address: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${residenceverifys[index].ResidenceAddress}",
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      const Text(
                                                          "Nearest Landmark: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${residenceverifys[index].NearestLandMark}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      const Text("Status:  ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Text(
                                                        "${residenceverifys[index].Status}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.orange,
                                                            fontSize: 21.0,
                                                            fontFamily:
                                                                'Calibri'),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                              );
                            });
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SpinKitThreeBounce(
                        size: 12.0,
                        color: Colors.white38,
                      );
                    } else {
                      return Text(
                        "Error While Loading Data",
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          fontSize: 20,
                        ),
                      );
                    }
                  }),
              FutureBuilder(
                  future: fetchTenantData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TenantVerifications>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: tenantVerify.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (tenantVerify[index].Status ==
                                      InquiryStatus.InProgress) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VerificationofTenant(
                                                  tenentverify: tenantVerify,
                                                  AddressofTenant:
                                                      tenantVerify[index]
                                                          .TenantAddress
                                                          .toString(),
                                                  Landmark: tenantVerify[index]
                                                      .NearestLandMark
                                                      .toString(),
                                                  NameofPerson:
                                                      tenantVerify[index]
                                                          .PersonName
                                                          .toString(),
                                                  typeofPerson:
                                                      tenantVerify[index]
                                                          .PersonType
                                                          .toString(),
                                                  tenantverID:
                                                      tenantVerify[index]
                                                          .TenantVerificationId!
                                                          .toInt(),
                                                  InqID: tenantVerify[index]
                                                      .InquiryId!
                                                      .toInt(),
                                                )));
                                  } else if (tenantVerify[index].Status ==
                                      InquiryStatus.PartialCompleted) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PreviewImage(
                                                  verifyID: tenantVerify[index]
                                                      .TenantVerificationId,
                                                  Persntype: tenantVerify[index]
                                                      .PersonType,
                                                  inquiryid: tenantVerify[index]
                                                      .InquiryId,
                                                  Vtype: InquiryTypes
                                                      .TenantVerification,
                                                  capimages: null,
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 5),
                                            content: Text(
                                              "The Inquiry is Completed",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Calibri'),
                                            )));
                                  }
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0, top: 2.0),
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      return Card(
                                        elevation: 3.0,
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxHeight: constraints.maxHeight),
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 11.0,
                                                right: 5.0,
                                                top: 10.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    "${tenantVerify[index].PersonType}'s Tenant Verification",
                                                    style: TextStyle(
                                                      fontSize: 25.0,
                                                      fontFamily: 'Calibri',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff392850),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 7.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          "${tenantVerify[index].PersonType}'s Name: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${tenantVerify[index].PersonName}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          "${tenantVerify[index].PersonType}'s Contact No: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Text(
                                                        "${tenantVerify[index].PersonContactNo}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri'),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      const Text(
                                                          "Tenant Address: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${tenantVerify[index].TenantAddress}",
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      const Text(
                                                          "Nearest Landmark: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${tenantVerify[index].NearestLandMark}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      const Text("Status:  ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Text(
                                                        "${tenantVerify[index].Status}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.orange,
                                                            fontSize: 21.0,
                                                            fontFamily:
                                                                'Calibri'),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                              );
                            });
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SpinKitThreeBounce(
                        size: 12.0,
                        color: Colors.white38,
                      );
                    } else {
                      return Text(
                        "Error While Loading Data",
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          fontSize: 20,
                        ),
                      );
                    }
                  }),
              FutureBuilder(
                  future: fetchSalaryData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SalarySlipVerifications>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: salarySlipVerify.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (salarySlipVerify[index].Status ==
                                      InquiryStatus.InProgress) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SalaryVerification(
                                                  salaryslipverify:
                                                      salarySlipVerify,
                                                  AddressofOffice:
                                                      salarySlipVerify[index]
                                                          .OfficeAddress
                                                          .toString(),
                                                  NameofOffice:
                                                      salarySlipVerify[index]
                                                          .OfficeName
                                                          .toString(),
                                                  NameofPerson:
                                                      salarySlipVerify[index]
                                                          .PersonName
                                                          .toString(),
                                                  typeofPerson:
                                                      salarySlipVerify[index]
                                                          .PersonType
                                                          .toString(),
                                                  landmark:
                                                      salarySlipVerify[index]
                                                          .NearestLandMark
                                                          .toString(),
                                                  salaryverID: salarySlipVerify[
                                                          index]
                                                      .SalarySlipVerificationId!
                                                      .toInt(),
                                                  inQID: salarySlipVerify[index]
                                                      .InquiryId!
                                                      .toInt(),
                                                )));
                                  } else if (salarySlipVerify[index].Status ==
                                      InquiryStatus.PartialCompleted) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PreviewImage(
                                                  verifyID: salarySlipVerify[
                                                          index]
                                                      .SalarySlipVerificationId,
                                                  Persntype:
                                                      salarySlipVerify[index]
                                                          .PersonType,
                                                  inquiryid:
                                                      salarySlipVerify[index]
                                                          .InquiryId,
                                                  Vtype: InquiryTypes
                                                      .SalarySlipSlipVerification,
                                                  capimages: null,
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 5),
                                            content: Text(
                                              "The Inquiry is Completed",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Calibri'),
                                            )));
                                  }
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0, top: 2.0),
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      return Card(
                                        elevation: 3.0,
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxHeight: constraints.maxHeight),
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 11.0,
                                                right: 5.0,
                                                top: 10.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    "${salarySlipVerify[index].PersonType} Salary Slip Verification",
                                                    style: TextStyle(
                                                      fontSize: 25.0,
                                                      fontFamily: 'Calibri',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff392850),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 7.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          "${salarySlipVerify[index].PersonType}'s Name: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${salarySlipVerify[index].PersonName}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          "${salarySlipVerify[index].PersonType}'s Contact No: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Text(
                                                        "${salarySlipVerify[index].PersonContactNo}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri'),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      const Text(
                                                          "Office Name: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${salarySlipVerify[index].OfficeName}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      const Text(
                                                          "Office Address: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${salarySlipVerify[index].OfficeAddress}",
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      const Text(
                                                          "Nearest Landmark: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${salarySlipVerify[index].NearestLandMark}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      const Text("Status:  ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Text(
                                                        "${salarySlipVerify[index].Status}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.orange,
                                                            fontSize: 21.0,
                                                            fontFamily:
                                                                'Calibri'),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                              );
                            });
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SpinKitThreeBounce(
                        size: 12.0,
                        color: Colors.white38,
                      );
                    } else {
                      return Text(
                        "Error While Loading Data",
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          fontSize: 20,
                        ),
                      );
                    }
                  }),
              FutureBuilder(
                  future: fetchOfficeData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<WorkOfficeVerifications>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: workOfficeVerify.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (workOfficeVerify[index].Status ==
                                          InquiryStatus.InProgress ||
                                      workOfficeVerify[index].Status ==
                                          InquiryStatus.PartialCompleted) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VerificationOfOffice(
                                                  workofficeverified:
                                                      workOfficeVerify,
                                                  AddressofOffice:
                                                      workOfficeVerify[index]
                                                          .OfficeAddress
                                                          .toString(),
                                                  Landmark:
                                                      workOfficeVerify[index]
                                                          .NearestLandMark
                                                          .toString(),
                                                  NameofOffice:
                                                      workOfficeVerify[index]
                                                          .OfficeName
                                                          .toString(),
                                                  NameofPerson:
                                                      workOfficeVerify[index]
                                                          .PersonName
                                                          .toString(),
                                                  typeofPerson:
                                                      workOfficeVerify[index]
                                                          .PersonType
                                                          .toString(),
                                                  OfficeVerID: workOfficeVerify[
                                                          index]
                                                      .WorkOfficeVerificationId!
                                                      .toInt(),
                                                  INQid: workOfficeVerify[index]
                                                      .InquiryId!
                                                      .toInt(),
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 5),
                                            content: Text(
                                              "The Inquiry is Completed",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Calibri'),
                                            )));
                                  }
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0, top: 2.0),
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      return Card(
                                        elevation: 3.0,
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxHeight: constraints.maxHeight),
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 11.0,
                                                right: 5.0,
                                                top: 10.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    "${workOfficeVerify[index].PersonType} Office/Business Verification",
                                                    style: TextStyle(
                                                      fontSize: 25.0,
                                                      fontFamily: 'Calibri',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff392850),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 7.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          "${workOfficeVerify[index].PersonType}'s Name: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${workOfficeVerify[index].PersonName}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                          "${workOfficeVerify[index].PersonType}'s Contact No: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Text(
                                                        "${workOfficeVerify[index].PersonContactNo}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'Calibri'),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      const Text(
                                                          "Company/Office Name: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${workOfficeVerify[index].OfficeName}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      const Text(
                                                          "Company/Office Address: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${workOfficeVerify[index].OfficeAddress}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      const Text(
                                                          "Nearest Landmark: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Expanded(
                                                        child: Text(
                                                          "${workOfficeVerify[index].NearestLandMark}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      const Text("Status:  ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  'Calibri')),
                                                      Text(
                                                        "${workOfficeVerify[index].Status}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.orange,
                                                            fontSize: 21.0,
                                                            fontFamily:
                                                                'Calibri'),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                              );
                            });
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SpinKitThreeBounce(
                        size: 12.0,
                        color: Colors.white38,
                      );
                    } else {
                      return Text(
                        "Error While Loading Data",
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          fontSize: 20,
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      );
    } on Exception catch (e) {
      EVSLogger.appendLog(e.toString());
      throw e;
    }
  }
}
