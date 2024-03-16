import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pvs/CustomForms/QuestionsScreen.dart';
import 'package:pvs/Screens/Inquires_Screen.dart';
import 'package:pvs/Widgets/Dialogbox.dart';
import 'package:pvs/Widgets/Graphs/Status_count.dart';
import 'package:pvs/Widgets/Logs/Logeger.dart';
import 'package:pvs/Widgets/Logs/LoggerEmail.dart';
import 'package:pvs/Widgets/Sync_Inquiries.dart';
import 'package:sqflite/sqflite.dart';
import '../Database/Database_Helper.dart';
import '../Module For Post Data/Post_inquires_model..dart';
import '../Module for Get Data/Inquires_response.dart';
import '../Screens/Setting_Screen.dart';
import 'Animated_Widgets/Animated_Dialog.dart';
import 'package:http/http.dart' as http;

import 'Animated_Widgets/animated_popup.dart';
import 'InquiryTypes.dart';
import 'Inquiry_status.dart';

class GridDashboard extends StatefulWidget {
  GridDashboard({
    super.key,
  });

  @override
  State<GridDashboard> createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  bool isLoading = false;
  bool isUpdating = false;
  bool isSync = false;

  var color = 0xff453658;
  Future<List<Data>> fetchData() async {
    PersonData = await DBHelper.DataResponse();
    return PersonData;
  }

  // Method for getting inquiries Data
  Future getinquires() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
        "${predefurl}Inquiry/GetInquiry?userId=${id}&residenceIds&workOfficeIds&bankStatementIds&salarySlipIds&tenantIds");
    var connectivityResult = await Connectivity().checkConnectivity();
    try {
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red,
            content: Text(
              "There is no internet connection",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Calibri',
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            )));
        EVSLogger.appendLog("${connectivityResult.toString()}");
      } else {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          verificationobj = Verification.fromJson(jsonDecode(response.body));
          EVSLogger.appendLog(
              "Response of Status code ${response.statusCode.toString()}");

          if (verificationobj.Status == 0) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 5),
                content: Text(
                  "${verificationobj.message.toString()}",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Calibri',
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0),
                )));
            EVSLogger.appendLog("${verificationobj.message.toString()}");
          } else {
            dataa = verificationobj.data;

            for (int i = 0; i < dataa!.length; i++) {
              bool AvailableData =
                  await DBHelper.getInquirybyID(dataa![i].InquiryId!);
              if (AvailableData == true) {
                includeData.add(dataa![i]);
              }
            }
            if (includeData.isNotEmpty) {
              await DBHelper.CreateInquiriesResponseDB(includeData);
              finalchk = includeData.length;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AnimatedDialog()));
              includeData.clear();
            } else {
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Animatedcheck(
                          Dialogname: "No Inquiries Found",
                          color: Colors.red,
                          icon: Icons.cancel)));
            }
            EVSLogger.appendLog("There are ${finalchk}Inquiries Downloaded");
          }
        }
      }
    } on PlatformException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
          content: Text(
            "${e.toString()}",
            style: TextStyle(color: Colors.white, fontFamily: 'Calibri'),
          )));
      EVSLogger.appendLog(
          "PlatformException on Download Inquiries: ${e.toString()}");
    } on SocketException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
          content: Text(
            "${e.toString()}",
            style: TextStyle(
                color: Colors.white, fontFamily: 'Calibri', fontSize: 15.0),
          )));
      EVSLogger.appendLog(
          "PlatformException on Download Inquiries: ${e.toString()}");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
          content: Text(
            "${e.toString()}",
            style: TextStyle(
                color: Colors.white, fontFamily: 'Calibri', fontSize: 15.0),
          )));
      EVSLogger.appendLog(
          "PlatformException on Download Inquiries: ${e.toString()}");
    }
    setState(() {
      isLoading = false;
    });

    return verificationobj;
  }

  // Method for Update Application

  // Method For Syncing Data
  Future PostData() async {
    setState(() {
      isSync = true;
    });

    List<Data> finalData = await DBHelper.DataResponse();
    Map<String, dynamic> Inquiry = {};
    List<dynamic> ArrResidence = [];
    List<dynamic> ArrOffice = [];
    List<dynamic> ArrPhotoes = [];
    List<dynamic> ArrBank = [];
    List<dynamic> ArrSalarySlip = [];
    List<dynamic> ArrTenant = [];
    try {
      if (finalData.isNotEmpty) {
        Data data = finalData.firstWhere(
          (element) => element.Status == InquiryStatus.Completed,
        );
        if (data != null) {
          inquiryID = data.InquiryId!;
          Inquiry['InquiryId'] = data.InquiryId;
          Inquiry['ProductName'] = data.ProductName;
          Inquiry['AppNo'] = data.AppNo;
          Inquiry['AppName'] = data.AppName;
          Inquiry['AppContact'] = data.AppContact;
          Inquiry['AppCNIC'] = data.AppCNIC;
          Inquiry['Status'] = data.Status;
          Inquiry['userId'] = id;

          if (data.residenceVerifications!.isNotEmpty) {
            List<ResidenceDetail> resDetail =
                await DBHelper.ResponseResidenceDetail(data.InquiryId!);
            List<ResidenceProfile> resProf =
                await DBHelper.responseResidenceProfile(data.InquiryId!);
            List<NeighbourCheck> resNeighbor =
                await DBHelper.responseResidenceNeighbor(data.InquiryId!);
            for (int i = 0; i < data.residenceVerifications!.length; i++) {
              Map<String, dynamic> Residence = {};
              Map<String, dynamic> resdet = {};
              Map<String, dynamic> resProfile = {};
              Map<String, dynamic> resNeighbr = {};
              if (resDetail != null) {
                resdet['ResidenceDetailId'] =
                    resDetail[i].ResidenceVerificationId;
                resdet['IsApplicantAvailable'] =
                    resDetail[i].IsApplicantAvailable;
                resdet['NameOfPersonToMet'] = resDetail[i].NameOfPersonToMet;
                resdet['RelationWithApplicant'] =
                    resDetail[i].RelationWithApplicant;
                resdet['WasActualAddressSame'] =
                    resDetail[i].WasActualAddressSame;
                resdet['CorrectAddress'] = resDetail[i].CorrectAddress;
                resdet['PhoneNo'] = resDetail[i].PhoneNo;
                resdet['LivesAtGivenAddress'] =
                    resDetail[i].LivesAtGivenAddress;
                resdet['PermanentAddress'] = resDetail[i].PermanentAddress;
                resdet['SinceHowLongLiving'] = resDetail[i].SinceHowintLiving;
                resdet['CNICNo'] = resDetail[i].CNICNo;
              }
              if (resProf != null) {
                resProfile['ResidenceVerificationId'] =
                    resProf[i].ResidenceVerificationId;
                resProfile['TypeOfResidence'] = resProf[i].TypeOfResidence;
                resProfile['ApplicantIsA'] = resProf[i].ApplicantIsA;
                resProfile['MentionOther'] = resProf[i].MentionOther;
                resProfile['MentionRent'] = resProf[i].MentionRent;
                resProfile['SizeApproxArea'] = resProf[i].SizeApproxArea;
                resProfile['UtilizationOfResidence'] =
                    resProf[i].UtilizationOfResidence;
                resProfile['RentDeedVerified'] = resProf[i].RentDeedVerified;
                resProfile['AreaAccessibility'] = resProf[i].AreaAccessibility;
                resProfile['ResidentsBelongsTo'] =
                    resProf[i].ResidentsBelongsTo;
                resProfile['RepossessionInTheArea'] =
                    resProf[i].RepossessionInTheArea;
              }
              if (resNeighbor != null) {
                resNeighbr['NeighbourCheckId'] =
                    resNeighbor[i].ResidenceVerificationId;
                resNeighbr['NeighborsName'] = resNeighbor[i].NeighborName;
                resNeighbr['NeighborsAddress'] = resNeighbor[i].NeighborAddress;
                resNeighbr['KnowsApplicant'] = resNeighbor[i].KnowsApplicant;
                resNeighbr['KnowsHowLong'] = resNeighbor[i].KnowsHowLong;
                resNeighbr['NeighborComments'] =
                    resNeighbor[i].NeighborComments;
                resNeighbr['NeighborsName2'] = resNeighbor[i].NeighborsName2;
                resNeighbr['NeighborsAddress2'] =
                    resNeighbor[i].NeighborsAddress2;
                resNeighbr['KnowsApplicant2'] = resNeighbor[i].KnowsApplicant2;
                resNeighbr['KnowsHowLong2'] = resNeighbor[i].KnowsHowLong2;
                resNeighbr['NeighborComments2'] =
                    resNeighbor[i].NeighborComments2;
              }
              Residence['ResidenceVerificationId'] =
                  data.residenceVerifications![i].ResidenceVerificationId;
              Residence['InquiryId'] =
                  data.residenceVerifications![i].InquiryId;
              Residence['PersonType'] =
                  data.residenceVerifications![i].PersonType;
              Residence['PersonCNIC'] =
                  data.residenceVerifications![i].PersonCNIC;
              Residence['PersonContactNo'] =
                  data.residenceVerifications![i].PersonContactNo;
              Residence['ResidenceAddress'] =
                  data.residenceVerifications![i].ResidenceAddress;
              Residence['NearestLandMark'] =
                  data.residenceVerifications![i].NearestLandMark;
              Residence['GeneralComments'] =
                  data.residenceVerifications![i].GeneralComments;
              Residence['OutComeVerification'] =
                  data.residenceVerifications![i].OutComeVerification;
              Residence['GpsLocation'] =
                  data.residenceVerifications![i].GpsLocation;
              Residence['GpsURL'] = data.residenceVerifications![i].GpsURL;
              Residence['Status'] = data.residenceVerifications![i].Status;
              Residence['StatusDate'] =
                  data.residenceVerifications![i].StatusDate;
              // Residence['StatusDate'] = data.residenceVerifications![i].StatusDate;
              Residence['ResidenceDetail'] = resdet;
              Residence['ResidenceProfile'] = resProfile;
              Residence['NeighbourCheck'] = resNeighbr;
              ArrResidence.add(Residence);
            }
            Inquiry['ResidenceVerifications'] = ArrResidence;
          }
          if (data.workOfficeVerifications!.isNotEmpty) {
            List<OfficeAddressDetail> offAddress =
                await DBHelper.responseOfficeAddress(data.InquiryId!);
            List<BusinessWorkOfficeDetail> offDetails =
                await DBHelper.responseworkOfficeDetails(data.InquiryId!);
            List<MarketeCheck> offMarket =
                await DBHelper.responseOfficeMarketchk(data.InquiryId!);
            List<OfficeHRDetail> offHR =
                await DBHelper.responseOffieHRchk(data.InquiryId!);
            for (int j = 0; j < data.workOfficeVerifications!.length; j++) {
              Map<String, dynamic> Office = {};
              Map<String, dynamic> OfficeAddress = {};
              Map<String, dynamic> OfficeDetails = {};
              Map<String, dynamic> OfficeNeighbor = {};
              Map<String, dynamic> OfficeHR = {};
              if (offAddress != null) {
                OfficeAddress['OfficeAddressDetailId'] =
                    offAddress[j].WorkOfficeVerificationId;
                OfficeAddress['WasActualAddressSame'] =
                    offAddress[j].WasActualAddressSame;
                OfficeAddress['CorrectAddress'] = offAddress[j].CorrectAddress;
                OfficeAddress['EstablishedTime'] =
                    offAddress[j].EstablishedTime;
                OfficeAddress['WorkAtGivenAddress'] =
                    offAddress[j].WorkAtGivenAddress;
                OfficeAddress['IsApplicantAvailable'] =
                    offAddress[j].IsApplicantAvailable;
                OfficeAddress['GiveReason'] = offAddress[j].GiveReason;
                OfficeAddress['CNICOS'] = offAddress[j].CNICOS;
                OfficeAddress['CNICNo'] = offAddress[j].CNICNo;
              }
              if (offDetails != null) {
                OfficeDetails['BusinessWorkOfficeDetailId'] =
                    offDetails[j].WorkOfficeVerificationId;
                OfficeDetails['TypeOfBusiness'] = offDetails[j].TypeOfBusiness;
                OfficeDetails['OtherTypeOfBusiness'] =
                    offDetails[j].OtherTypeOfBusiness;
                OfficeDetails['ApplicantIsA'] = offDetails[j].ApplicantIsA;
                OfficeDetails['MentionOther'] = offDetails[j].MentionOther;
                OfficeDetails['MentionRent'] = offDetails[j].MentionRent;
                OfficeDetails['NatureOfBusiness'] =
                    offDetails[j].NatureOfBusiness;
                OfficeDetails['OtherNatureOfBusiness'] =
                    offDetails[j].OtherNatureOfBusiness;
                OfficeDetails['BusinessLegalEntity'] =
                    offDetails[j].BusinessLegalEntity;
                OfficeDetails['GovtEmpBusinessLegalEntity'] =
                    offDetails[j].GovtEmpBusinessLegalEntity;
                OfficeDetails['NamePlateAffixed'] =
                    offDetails[j].NamePlateAffixed;
                OfficeDetails['SizeApproxArea'] = offDetails[j].SizeApproxArea;
                OfficeDetails['BusinessActivity'] =
                    offDetails[j].BusinessActivity;
                OfficeDetails['NoOfEmployees'] = offDetails[j].NoOfEmployees;
                OfficeDetails['BusinessEstablesSince'] =
                    offDetails[j].BusinessEstablesSince;
              }
              if (offMarket != null) {
                OfficeNeighbor['MarketeCheckId'] =
                    offMarket[j].WorkOfficeVerificationId;
                OfficeNeighbor['NeighborsName'] = offMarket[j].NeighborsName;
                OfficeNeighbor['NeighborsAddress'] =
                    offMarket[j].NeighborsAddress;
                OfficeNeighbor['KnowsApplicant'] = offMarket[j].KnowsApplicant;
                OfficeNeighbor['KnowsHowLong'] = offMarket[j].KnowsHowint;
                OfficeNeighbor['NeighborComments'] =
                    offMarket[j].NeighborComments;
                OfficeNeighbor['BusinessEstablishedSinceMarketeCheck'] =
                    offMarket[j].BusinessEstablishedSinceMarketeCheck;
                OfficeNeighbor['NeighborsTwoName'] =
                    offMarket[j].NeighborsTwoName;
                OfficeNeighbor['NeighborsTwoAddress'] =
                    offMarket[j].NeighborsTwoAddress;
                OfficeNeighbor['NeighborsTwoKnowsApplicant'] =
                    offMarket[j].NeighborsTwoKnowsApplicant;
                OfficeNeighbor['NeighborsTwoKnowsHowLong'] =
                    offMarket[j].NeighborsTwoKnowsHowLong;
                OfficeNeighbor['NeighborsTwoNeighborComments'] =
                    offMarket[j].NeighborsTwoNeighborComments;
                OfficeNeighbor[
                        'NeighborsTwoBusinessEstablishedSinceMarketeCheck'] =
                    offMarket[j]
                        .NeighborsTwoBusinessEstablishedSinceMarketeCheck;
              }
              if (offHR != null) {
                OfficeHR['OfficeHRDetailId'] =
                    offHR[j].WorkOfficeVerificationId;
                OfficeHR['NameOfPersonToMeet'] = offHR[j].NameOfPersonToMeet;
                OfficeHR['OHrKnowsApplicant'] = offHR[j].OHrKnowsApplicant;
                OfficeHR['ApplicantEmployementStatus'] =
                    offHR[j].ApplicantEmployementStatus;
                OfficeHR['ApplicantEmployementPeriod'] =
                    offHR[j].ApplicantEmployementPeriod;
                OfficeHR['ApplicantDesignation'] =
                    offHR[j].ApplicantDesignation;
                OfficeHR['OHrNatureOfBusiness'] = offHR[j].OHrNatureOfBusiness;
                OfficeHR['OHrOtherNatureOfBusiness'] =
                    offHR[j].OHrOtherNatureOfBusiness;
                OfficeHR['GrossSalary'] = offHR[j].GrossSalary;
                OfficeHR['NetTakeHomeSalary'] = offHR[j].NetTakeHomeSalary;
                OfficeHR['SalarySlipVerified'] = offHR[j].SalarySlipVerified;
              }
              Office['WorkOfficeVerificationId'] =
                  data.workOfficeVerifications![j].WorkOfficeVerificationId;
              Office['InquiryId'] = data.workOfficeVerifications![j].InquiryId;
              Office['PersonType'] =
                  data.workOfficeVerifications![j].PersonType;
              Office['PersonName'] =
                  data.workOfficeVerifications![j].PersonName;
              Office['PersonContactNo'] =
                  data.workOfficeVerifications![j].PersonContactNo;
              Office['PersonDesignation'] =
                  data.workOfficeVerifications![j].PersonDesignation;
              Office['OfficeName'] =
                  data.workOfficeVerifications![j].OfficeName;
              Office['OfficeAddress'] =
                  data.workOfficeVerifications![j].OfficeAddress;
              Office['NearestLandMark'] =
                  data.workOfficeVerifications![j].NearestLandMark;
              Office['GeneralComments'] =
                  data.workOfficeVerifications![j].GeneralComments;
              Office['OutComeVerification'] =
                  data.workOfficeVerifications![j].OutComeVerification;
              Office['GpsLocation'] =
                  data.workOfficeVerifications![j].GpsLocation;
              Office['GpsURL'] = data.workOfficeVerifications![j].GpsURL;
              Office['Status'] = data.workOfficeVerifications![j].Status;
              Office['StatusDate'] =
                  data.workOfficeVerifications![j].StatusDate;
              // Office['StatusDate'] = data.workOfficeVerifications![j].StatusDate;
              Office['OfficeAddressDetail'] = OfficeAddress;
              Office['BusinessWorkOfficeDetail'] = OfficeDetails;
              Office['MarketeCheck'] = OfficeNeighbor;
              Office['OfficeHRDetail'] = OfficeHR;
              ArrOffice.add(Office);
            }
            Inquiry['WorkOfficeVerifications'] = ArrOffice;
          }
          if (data.bankStatementVerifications!.isNotEmpty) {
            List<BankStatementVerifications> Banks =
                await DBHelper.responseBank(data.InquiryId!);
            for (int k = 0; k < data.bankStatementVerifications!.length; k++) {
              Map<String, dynamic> Bank = {};
              if (Banks != null) {
                Bank['BankStatementVerificationId'] =
                    Banks[k].BankStatementVerificationId;
                Bank['InquiryId'] = Banks[k].InquiryId;
                Bank['PersonType'] = Banks[k].PersonType;
                Bank['PersonName'] = Banks[k].PersonName;
                Bank['PersonContactNo'] = Banks[k].PersonContactNo;
                Bank['BankName'] = Banks[k].BankName;
                Bank['BankAddress'] = Banks[k].BankAddress;
                Bank['NearestLandMark'] = Banks[k].NearestLandMark;
                Bank['GeneralComments'] = Banks[k].GeneralComments;
                Bank['OutComeVerification'] = Banks[k].OutComeVerification;
                Bank['GpsLocation'] = Banks[k].GpsLocation;
                Bank['Status'] = Banks[k].Status;

                Bank['StatusDate'] = Banks[k].StatusDate;
                ArrBank.add(Bank);
              }
            }
            Inquiry['BankStatementVerifications'] = ArrBank;
          }
          if (data.salarySlipVerifications!.isNotEmpty) {
            List<SalarySlipVerifications> Salaries =
                await DBHelper.responseSalary(data.InquiryId!);
            for (int s = 0; s < data.salarySlipVerifications!.length; s++) {
              Map<String, dynamic> mapSalary = {};
              if (Salaries != null) {
                mapSalary['SalarySlipVerificationId'] =
                    Salaries[s].SalarySlipVerificationId;
                mapSalary['InquiryId'] = Salaries[s].InquiryId;
                mapSalary['PersonType'] = Salaries[s].PersonType;
                mapSalary['PersonName'] = Salaries[s].PersonName;
                mapSalary['PersonContactNo'] = Salaries[s].PersonContactNo;
                mapSalary['OfficeName'] = Salaries[s].OfficeName;
                mapSalary['OfficeAddress'] = Salaries[s].OfficeAddress;
                mapSalary['NearestLandMark'] = Salaries[s].NearestLandMark;
                mapSalary['GeneralComments'] = Salaries[s].GeneralComments;
                mapSalary['OutComeVerification'] =
                    Salaries[s].OutComeVerification;
                mapSalary['GpsLocation'] = Salaries[s].GpsLocation;
                mapSalary['GpsURL'] = Salaries[s].GpsURL;
                mapSalary['Status'] = Salaries[s].Status;
                mapSalary['StatusDate'] = Salaries[s].StatusDate;
                ArrSalarySlip.add(mapSalary);
              }
            }
            Inquiry['SalarySlipVerifications'] = ArrSalarySlip;
          }
          if (data.tenantVerifications!.isNotEmpty) {
            List<TenantVerifications> tenants =
                await DBHelper.responseTenant(data.InquiryId!);
            for (int t = 0; t < data.tenantVerifications!.length; t++) {
              Map<String, dynamic> maptenant = {};
              if (tenants != null) {
                maptenant['TenantVerificationId'] =
                    tenants[t].TenantVerificationId;
                maptenant['InquiryId'] = tenants[t].InquiryId;
                maptenant['PersonType'] = tenants[t].PersonType;
                maptenant['PersonName'] = tenants[t].PersonName;
                maptenant['PersonContactNo'] = tenants[t].PersonContactNo;
                maptenant['TenantAddress'] = tenants[t].TenantAddress;
                maptenant['NearestLandMark'] = tenants[t].NearestLandMark;
                maptenant['TenantName'] = tenants[t].TenantName;
                maptenant['TenantContactNo'] = tenants[t].TenantContactNo;
                maptenant['TenantCNIC'] = tenants[t].TenantCNIC;
                maptenant['TenancyPeriod'] = tenants[t].TenancyPeriod;
                maptenant['TenantRent'] = tenants[t].TenantRent;
                maptenant['GeneralComments'] = tenants[t].GeneralComments;
                maptenant['OutComeVerification'] =
                    tenants[t].OutComeVerification;
                maptenant['GpsLocation'] = tenants[t].GpsLocation;
                maptenant['GpsURL'] = tenants[t].GpsURL;
                maptenant['Status'] = tenants[t].Status;

                // maptenant['StatusDate'] = tenants[t].StatusDate;
                maptenant['StatusDate'] = tenants[t].StatusDate;
                ArrTenant.add(maptenant);
              }
            }
            Inquiry['TenantVerifications'] = ArrTenant;
          }
          String query =
              "SELECT InquiryId, VerificationType, PersonType, appPhoto, VerificationId FROM InquiryPhotos WHERE InquiryId = ${data.InquiryId}";
          Database db = await DBHelper.initDB();
          List<Map<String, dynamic>> cur = await db.rawQuery(query);
          for (int i = 0; i < cur.length; i++) {
            if (data.residenceVerifications!.isNotEmpty) {
              for (int i = 0; i < data.residenceVerifications!.length; i++) {
                if (cur[i]['VerificationType'] ==
                        InquiryTypes.ResidenceVerification &&
                    data.residenceVerifications![i].PersonType ==
                        cur[i]['PersonType']) {
                  Map<String, dynamic> Photos = {};

                  Photos['InquiryId'] = cur[i]['InquiryId'];
                  Photos['VerificationType'] = cur[i]['VerificationType'];
                  Photos['PersonType'] = cur[i]['PersonType'];
                  Photos['Image'] = cur[i]['appPhoto'];
                  Photos['VerificationId'] = cur[i]['VerificationId'];
                  ArrPhotoes.add(Photos);
                }
              }
            }
            if (data.workOfficeVerifications!.isNotEmpty) {
              for (int wrk = 0;
                  wrk < data.workOfficeVerifications!.length;
                  wrk++) {
                if (cur[i]['VerificationType'] ==
                        InquiryTypes.OfficeVerification &&
                    data.workOfficeVerifications![wrk].PersonType ==
                        cur[i]['PersonType']) {
                  Map<String, dynamic> Photos = {};
                  Photos['InquiryId'] = cur[i]['InquiryId'];
                  Photos['VerificationType'] = cur[i]['VerificationType'];
                  Photos['PersonType'] = cur[i]['PersonType'];
                  Photos['Image'] = cur[i]['appPhoto'];
                  Photos['VerificationId'] = cur[i]['VerificationId'];
                  ArrPhotoes.add(Photos);
                }
              }
            }
            if (data.bankStatementVerifications!.isNotEmpty) {
              for (int b = 0;
                  b < data.bankStatementVerifications!.length;
                  b++) {
                if (cur[i]['VerificationType'] ==
                        InquiryTypes.BankStatementVerification &&
                    data.bankStatementVerifications![b].PersonType ==
                        cur[i]['PersonType']) {
                  Map<String, dynamic> Photos = {};
                  Photos['InquiryId'] = cur[i]['InquiryId'];
                  Photos['VerificationType'] = cur[i]['VerificationType'];
                  Photos['PersonType'] = cur[i]['PersonType'];
                  Photos['Image'] = cur[i]['appPhoto'];
                  Photos['VerificationId'] = cur[i]['VerificationId'];
                  ArrPhotoes.add(Photos);
                }
              }
            }
            if (data.salarySlipVerifications!.isNotEmpty) {
              for (int S = 0; S < data.salarySlipVerifications!.length; S++) {
                if (cur[i]['VerificationType'] ==
                        InquiryTypes.SalarySlipSlipVerification &&
                    data.salarySlipVerifications![S].PersonType ==
                        cur[i]['PersonType']) {
                  Map<String, dynamic> Photos = {};
                  Photos['InquiryId'] = cur[i]['InquiryId'];
                  Photos['VerificationType'] = cur[i]['VerificationType'];
                  Photos['PersonType'] = cur[i]['PersonType'];
                  Photos['Image'] = cur[i]['appPhoto'];
                  Photos['VerificationId'] = cur[i]['VerificationId'];
                  ArrPhotoes.add(Photos);
                }
              }
            }
            if (data.tenantVerifications!.isNotEmpty) {
              for (int t = 0; t < data.tenantVerifications!.length; t++) {
                if (cur[i]['VerificationType'] ==
                        InquiryTypes.TenantVerification &&
                    data.tenantVerifications![t].PersonType ==
                        cur[i]['PersonType']) {
                  Map<String, dynamic> Photos = {};
                  Photos['InquiryId'] = cur[i]['InquiryId'];
                  Photos['VerificationType'] = cur[i]['VerificationType'];
                  Photos['PersonType'] = cur[i]['PersonType'];
                  Photos['Image'] = cur[i]['appPhoto'];
                  Photos['VerificationId'] = cur[i]['VerificationId'];
                  ArrPhotoes.add(Photos);
                }
              }
            }
          }
          Inquiry['Images'] = ArrPhotoes;

          SendApi(Inquiry);
        } else {
          setState(() {
            isSync = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Sync Failed'),
                content: Text(
                  'No Inquiry found to sync,\nKindly Complete the inquiry! ',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Calibri',
                      fontSize: 22.0),
                ),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else if (finalData.isEmpty) {
        setState(() {
          isSync = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sync Failed'),
              content: Text('Kindly complete the inquiry!'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      setState(() {
        isSync = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sync Failed'),
            content: Text('There is an Error while Syncing!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      EVSLogger.appendLog("${e.toString()}");
      throw e;
    }
  }

  Future SendApi(Map<String, dynamic> newData) async {
    try {
      setState(() {
        isSync = true;
      });
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          isSync = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red,
            content: Text(
              "There is no internet connection",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Calibri',
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            )));
        EVSLogger.appendLog("${connectivityResult.toString()}");
      } else {
        // var request = http.MultipartRequest(
        //     'POST', Uri.parse("${predefurl}Inquiry/PostInquiry"));
        var request = http.MultipartRequest(
            'POST', Uri.parse("${predefurl}evs/Inquiry/PostInquiry"));
        // "http://202.141.245.6:93/evs/Inquiry/PostInquiry"
        // "http://icilpkfcr.ddns.net:85/evs/Inquiry/PostInquiry"
        var news = jsonEncode(newData);
        request.fields['json'] = jsonEncode(newData);
        request.fields['userid'] = id;
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(responseString);
          newSync = SyncInquiryModel.fromJson(jsonResponse);
          if (newSync.status == 1) {
            if (newSync.residenceIds != null) {
              try {
                for (int i = 0; i < newSync.residenceIds!.length; i++) {
                  var residenceList = newSync.residenceIds![i];
                  await DBHelper.DeleteStatusTable(residenceList);
                  await DBHelper.DeleteInquiryPhotosTable(residenceList);
                  await DBHelper.DeleteResidenceDetailsTable(residenceList);
                  await DBHelper.DeleteResidenceProfileTable(residenceList);
                  await DBHelper.DeleteResidenceNeighborTable(residenceList);
                  await DBHelper.DeletemainResidenceTable(residenceList);
                  await DBHelper.DeleteInquiryTable(inquiryID);
                  EVSLogger.appendLog(
                      "Successfully Sync & delete Residence Verification, ResidenceId is ${residenceList}");
                }
              } on PlatformException catch (e) {
                isSync = false;
                EVSLogger.appendLog(
                    "During Sync ResidenceInquiry got PlatformException: ${e.toString()}");
              } on Exception catch (e) {
                isSync = false;
                EVSLogger.appendLog(
                    "During Sync ResidenceInquiry got Exception: ${e.toString()}");
              }
            }
            if (newSync.workOfficeIds != null) {
              try {
                for (int o = 0; o < newSync.workOfficeIds!.length; o++) {
                  var officeList = newSync.workOfficeIds![o];
                  await DBHelper.DeleteStatusTable(officeList);
                  await DBHelper.DeleteInquiryPhotosTable(officeList);
                  await DBHelper.DeleteOfficeAddressTable(officeList);
                  await DBHelper.DeleteOfficewrkBussinessTable(officeList);
                  await DBHelper.DeleteOfficeNeighborTable(officeList);
                  await DBHelper.DeleteOfficeHRTable(officeList);
                  await DBHelper.DeletemainOfficeTable(officeList);
                  await DBHelper.DeleteInquiryTable(inquiryID);
                  EVSLogger.appendLog(
                      "Successfully Sync & delete Office Verification, ResidenceId is ${officeList}");
                }
              } on PlatformException catch (e) {
                isSync = false;
                EVSLogger.appendLog(
                    "During Sync OfficeInquiry got PlatformException: ${e.toString()}");
              } on Exception catch (e) {
                isSync = false;
                EVSLogger.appendLog(
                    "During Sync OfficeInquiry got Exception: ${e.toString()}");
              }
            }
            if (newSync.tenantIds != null) {
              try {
                for (int t = 0; t < newSync.tenantIds!.length; t++) {
                  var tenantList = newSync.tenantIds![t];
                  await DBHelper.DeleteStatusTable(tenantList);
                  await DBHelper.DeleteInquiryPhotosTable(tenantList);
                  await DBHelper.DeleteTenantTable(tenantList);
                  await DBHelper.DeleteInquiryTable(inquiryID);
                  EVSLogger.appendLog(
                      "Successfully Sync & delete Tenant Verification, ResidenceId is ${tenantList}");
                }
              } on PlatformException catch (e) {
                isSync = false;
                EVSLogger.appendLog(
                    "During Sync TenantInquiry got PlatformException: ${e.toString()}");
              } on Exception catch (e) {
                isSync = false;
                EVSLogger.appendLog(
                    "During Sync TenantInquiry got Exception: ${e.toString()}");
              }
            }
            if (newSync.bankStatementIds != null) {
              try {
                for (int b = 0; b < newSync.bankStatementIds!.length; b++) {
                  var bankList = newSync.bankStatementIds![b];
                  await DBHelper.DeleteStatusTable(bankList);
                  await DBHelper.DeleteInquiryPhotosTable(bankList);
                  await DBHelper.DeleteBankTable(bankList);
                  await DBHelper.DeleteInquiryTable(inquiryID);
                  EVSLogger.appendLog(
                      "Successfully Sync & delete Bank Verification, ResidenceId is ${bankList}");
                }
              } on PlatformException catch (e) {
                isSync = false;
                EVSLogger.appendLog(
                    "During Sync BankInquiry got PlatformException: ${e.toString()}");
              } on Exception catch (e) {
                isSync = false;
                EVSLogger.appendLog(
                    "During Sync BankInquiry got Exception: ${e.toString()}");
              }
            }
            if (newSync.salarySlipIds != null) {
              try {
                for (int s = 0; s < newSync.salarySlipIds!.length; s++) {
                  var salaryList = newSync.salarySlipIds![s];
                  await DBHelper.DeleteStatusTable(salaryList);
                  await DBHelper.DeleteInquiryPhotosTable(salaryList);
                  await DBHelper.DeleteSalaryTable(salaryList);
                  await DBHelper.DeleteInquiryTable(inquiryID);
                  EVSLogger.appendLog(
                      "Successfully Sync & delete Salary Verification, ResidenceId is ${salaryList}");
                }
              } on PlatformException catch (e) {
                isSync = false;
                EVSLogger.appendLog(
                    "During Sync SalaryInquiry got PlatformException: ${e.toString()}");
              } on Exception catch (e) {
                isSync = false;
                EVSLogger.appendLog(
                    "During Sync SalaryInquiry got Exception: ${e.toString()}");
              }
            }
            setState(() {});
            setState(() {
              isSync = false;
            });
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Animatedcheck(
                          Dialogname: 'Successfully Sync Inquiry',
                          color: Colors.green,
                          icon: Icons.check,
                        )));
          } else if (newSync.status == 2) {
            setState(() {
              isSync = false;
            });
            EVSLogger.appendLog(newSync.message!);
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[300],
                    title: Text("Sync Inquiry failed!"),
                    content: Text(newSync.message!),
                    contentTextStyle: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 19,
                        fontFamily: 'Calibri',
                        color: Colors.black),
                    titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: 'Calibri',
                        color: Colors.black),
                    actions: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Divider(
                            color: Colors.black,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                  fontFamily: 'Calibri'),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                });
          } else {
            setState(() {
              isSync = false;
            });
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[300],
                    title: Text("Sync Inquiry failed!"),
                    content: Text(newSync.message!),
                    contentTextStyle: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 19,
                        fontFamily: 'Calibri',
                        color: Colors.black),
                    titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: 'Calibri',
                        color: Colors.black),
                    actions: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Divider(
                            color: Colors.black,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                  fontFamily: 'Calibri'),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                });
          }
        }
      }
    } on Exception catch (e) {
      setState(() {
        isSync = false;
      });
      EVSLogger.appendLog(e.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[300],
              title: Text("Sync Inquiry failed!"),
              content: Text(
                  "Exception occured while sync inquiry\n ${e.toString()}"),
              contentTextStyle: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 19,
                  fontFamily: 'Calibri',
                  color: Colors.black),
              titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: 'Calibri',
                  color: Colors.black),
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Divider(
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            fontFamily: 'Calibri'),
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    )
                  ],
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var shapee =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0));
    return Stack(children: [
      Column(
        children: [
          Flexible(
              child: GridView.count(
                  shrinkWrap: true,
                  childAspectRatio: (0.6 / .6),
                  padding: const EdgeInsets.only(
                      left: 13.0, right: 13.0, top: 0.0, bottom: 15.0),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  children: [
                Material(
                  shape: shapee,
                  color: Color(color),
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: Image.asset(
                            "assets/inquiry.png",
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Download Inquires",
                            style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      isLoading ? null : getinquires();

                      // getinquires().then((result) {
                      //     if (result == null) {
                      //       getinquires().then((value) {
                      //         if (value == null) {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => Animatedcheck(
                      //                       Dialogname:
                      //                           "No Inquiries Found",
                      //                       color: Colors.red,
                      //                       icon: Icons.cancel)));
                      //         }
                      //       });
                      //     } else {
                      //       if (result != null && dataa!.length != null) {
                      //         Navigator.pushReplacement(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     AnimatedDialog()));
                      //       }
                      //     }
                      //   });
                    },
                  ),
                ),
                Material(
                  shape: shapee,
                  color: Color(color),
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: Image.asset(
                            "assets/syncnew.png",
                            // color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Sync Inquires",
                            style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return finalDialog(
                                context,
                                "Sync Inquiry!",
                                "Do you really want to sync inquiry?",
                                "Yes", () {
                              Navigator.of(context).pop();
                              PostData();
                            });
                          });
                    },
                  ),
                ),
                Material(
                  shape: shapee,
                  color: Color(color),
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: Image.asset(
                            "assets/listinq.png",
                            // color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Inquiry List",
                            style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InquiresScreen()));
                    },
                  ),
                ),
                Material(
                  shape: shapee,
                  color: Color(color),
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: Image.asset(
                            "assets/viewlog.png",
                            color: Colors.orangeAccent,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Logs",
                            style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      EVSLoggerEmail email = EVSLoggerEmail(context);
                      email.showEmailDialog();
                    },
                  ),
                ),
                Material(
                  shape: shapee,
                  color: Color(color),
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: Image.asset(
                            "assets/otherform.png",
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Other Forms",
                            style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      fetchData();
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => QuestionScreen()));
                      // await getServerUrl(context);
                    },
                  ),
                ),
                Material(
                  shape: shapee,
                  color: Color(color),
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: Image.asset(
                            "assets/chart.png",
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Status",
                            style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      // await DBHelper.printTable();
                      getStatusCount();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Graph()));
                    },
                  ),
                )
              ])),
        ],
      ),
      if (isLoading)
        Center(
          child: Container(
            height: 110.0,
            width: 220.0,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitFadingCircle(
                  color: Colors.black,
                  size: 25.0,
                ),
                Text(
                  "Downloading in progress..",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Calibri',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                )
              ],
            ),
          ),
        ),
      if (isUpdating)
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Center(
              child: Container(
                height: 105.0,
                width: 200.0,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SpinKitThreeBounce(
                      color: Colors.black,
                      size: 25.0,
                    ),
                    Text(
                      "Updating in progress!",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),

      if (isSync)
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Center(
              child: Container(
                height: 105.0,
                width: 200.0,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SpinKitDualRing(
                      color: Colors.black,
                      size: 25.0,
                    ),
                    Text(
                      "syncing in progress!",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      // AlertDialog(
      //     backgroundColor: Colors.white,
      //     shadowColor: Colors.black38,
      //     contentPadding: EdgeInsets.all(8.0),
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(2.0)),
      //     content: Container(
      //       height: 100,
      //       width: 100,
      //       child: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: <Widget>[
      //           SpinKitDualRing(
      //             color: Colors.black,
      //             size: 40.0,
      //           ),
      //           SizedBox(
      //             height: 10.0,
      //           ),
      //           Text(
      //             "\t\t\t\t\t\t\tplease wait\nsyncing in progress!",
      //             style: TextStyle(
      //                 color: Colors.black,
      //                 fontFamily: 'Calibri',
      //                 fontSize: 22.0,
      //                 fontWeight: FontWeight.bold),
      //           )
      //         ],
      //       ),
      //     ))
    ]);
  }
}

String id = '';
String UserName = '';
int? chk;
var finalchk;
int Application = 1;
int newApplication = 0;
int? DatabaseVR;
