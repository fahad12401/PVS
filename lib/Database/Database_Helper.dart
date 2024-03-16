import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Module For Post Data/Post_inquires_model..dart';
import '../Module for Get Data/Inquires_response.dart';
import '../Module for Get Data/Login_response.dart';
import '../Widgets/Gridview.dart';
import '../Widgets/InquiryTypes.dart';
import '../Widgets/Inquiry_status.dart';
import '../Widgets/Logs/Logeger.dart';

class DBHelper {
  static const String TABLE_LOGINRESPONSE = 'LoginResponse';
  static const String TABLE_USER = 'UserInfo';
  static const String DBname = 'EVS.db';
  static const String TABLE_INQUIRY = 'Inquiry';
  static const String TABLE_INQUIRYPHOTOS = 'InquiryPhotos';
  static const String TABLE_RESIDENCEVERIFICATION = 'ResidenceVerifications';
  static const String TABLE_RESIDENCE_PROFILE = 'ResidenceProfile';
  static const String TABLE_RESIDENCE_DETAILS = 'ResidenceDetails';
  static const String TABLE_RESIDENCE_NEIGHBOUR = 'ResidenceNeighborCheck';
  static const String TABLE_OFFICEVERIFICATION = 'OfficeVerifications';
  static const String TABLE_OFFICE_ADDRESSDETAILS = 'OfficeAddressDetails';
  static const String TABLE_OFFICE_BussWrkDETAILS = 'OfficeBusinessWorkDetails';
  static const String TABLE_OFFICE_NghbrCHECK = 'OfficeNeighborMarketCheck';
  static const String TABLE_OFFICE_HR_DETAILS = 'OfficeHRDetails';
  static const String TABLE_BANKSTATEMENT_VERIFICATION =
      'BankStatementVerifications';
  static const String TABLE_SALARYSLIP_VERIFICATION = 'SalarySlipVerifications';
  static const String TABLE_TENANT_VERIFICATION = 'TenantVerifications';
  static const String TABLE_STATUS = 'InquiryVerificationStatus';
  static const String TABLE_APPVER = 'AppVersion';
  static Future<Database> initDB() async {
    var dbpath = await getDatabasesPath();
    String path = join(dbpath + DBname);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

// *************************************************************
//                    CREATION OF TABLE
// *************************************************************
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $TABLE_LOGINRESPONSE(
      message TEXT
    )
  ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_USER(
      Id TEXT,
      UserName TEXT,
      PasswordHash TEXT,
      BranchId INTEGER,
      FirstName TEXT,
      LastName TEXT,
      code TEXT   
      )''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $TABLE_APPVER(
      appversion INTEGER
    )
''');
    // InQuiry Table
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $TABLE_INQUIRY(
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
            InquiryId INTEGER,
            CompanyId INTEGER,
            BranchId INTEGER,
            CustomerBranchId INTEGER,
            ProductId INTEGER,
        		CompanyName TEXT,
            BranchName TEXT,
            CustomerBranchName TEXT,
        		ProductName TEXT,
            AppNo TEXT,
            AppName TEXT,
        		AppContact TEXT,
            AppCNIC TEXT,
        		UserID TEXT,
            Status TEXT,           
            orignalIndex INTEGER NOT NULL,
            islongPressed INTEGER,
            addedtotop TEXT
            )
            ''');
    // Inquiry Photos Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_INQUIRYPHOTOS(
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            VerificationId INTEGER,
        		InquiryId INTEGER,
            UserID TEXT,
            VerificationType TEXT,
        		PersonType TEXT,
            appPhoto TEXT,
        		FOREIGN KEY(InquiryId) REFERENCES $TABLE_INQUIRY(ID)
            )
          ''');
    // Status Update Table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $TABLE_STATUS(
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          VerificationId INTEGER,
          InquiryId INTEGER,
          VerificationType TEXT,
          Status TEXT,
          FOREIGN KEY(InquiryId) REFERENCES $TABLE_INQUIRY(ID)
          )
''');
    //RESIDENCE VERIFICATION table
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $TABLE_RESIDENCEVERIFICATION(
            ResidenceVerificationId INTEGER PRIMARY KEY,
        		InquiryId INTEGER,
            UserID TEXT,
            PersonType TEXT,
        		PersonName TEXT,
            PersonContactNo TEXT,
        		PersonCNIC TEXT,
            ResidenceAddress TEXT,
        		NearestLandMark TEXT,
            GeneralComments TEXT,
        		OutComeVerification TEXT,
            GpsLocation TEXT,
            GpsURL TEXT,
        		Status TEXT,
            StatusDate TEXT,
            isSync TEXT,
            OrderTop TEXT,
        		FOREIGN KEY(InquiryId) REFERENCES $TABLE_INQUIRY(ID)
            )
            ''');
    //TABLE_RESIDENCE_PROFILE
    await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_RESIDENCE_PROFILE(
            ResidenceVerificationId INTEGER PRIMARY KEY,
        		InquiryId INTEGER,
            PersonType TEXT,
        		TypeOfResidence TEXT,
            ApplicantIsA TEXT,
        		MentionOther REAL,
            MentionRent TEXT, 
        		SizeApproxArea TEXT,
            UtilizationOfResidence TEXT,
        		RentDeedVerified TEXT,
            Neighborhood TEXT,
            AreaAccessibility TEXT,
        		ResidentsBelongsTo TEXT,
            RepossessionInTheArea TEXT,
        		Status TEXT,
        		FOREIGN KEY(InquiryId) REFERENCES $TABLE_RESIDENCEVERIFICATION(ResidenceVerificationId)
            )
            ''');
    // TABLE_RESIDENCE_DETAILS
    await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_RESIDENCE_DETAILS(
            ResidenceVerificationId INTEGER PRIMARY KEY,
        		InquiryId INTEGER,
            PersonType TEXT,
            IsApplicantAvailable TEXT,
        		NameOfPersonToMet TEXT,
            RelationWithApplicant TEXT,
        		WasActualAddressSame TEXT,
            CorrectAddress TEXT,
            PhoneNo TEXT,
        		LivesAtGivenAddress TEXT,
            PermanentAddress TEXT,
        		SinceHowLongLiving TEXT,
            SinceHowintLiving TEXT,
            CNICNo TEXT,
        		Status TEXT,
        		FOREIGN KEY(InquiryId) REFERENCES $TABLE_RESIDENCEVERIFICATION(ResidenceVerificationId)
            )
            ''');
    await db.execute('''
           CREATE TABLE IF NOT EXISTS $TABLE_RESIDENCE_NEIGHBOUR(
            ResidenceVerificationId INTEGER PRIMARY KEY,
        		InquiryId INTEGER,
            PersonType TEXT,
            NeighborName TEXT,
        		NeighborAddress TEXT,
            KnowsApplicant TEXT,
        		KnowsHowLong TEXT,
            NeighborComments TEXT,
            NeighborsName2 TEXT,
            NeighborsAddress2 TEXT,
            KnowsApplicant2 TEXT,
            KnowsHowLong2 TEXT,
            NeighborComments2 TEXT,
        		Status TEXT,
            Status2 TEXT,
        		FOREIGN KEY(InquiryId) REFERENCES $TABLE_RESIDENCEVERIFICATION(ResidenceVerificationId))
            ''');
    //TABLE_OFFICEVERIFICATION
    await db.execute('''
             CREATE TABLE IF NOT EXISTS $TABLE_OFFICEVERIFICATION(
            WorkOfficeVerificationId INTEGER PRIMARY KEY,
        		InquiryId INTEGER,
            UserID TEXT,
            PersonType TEXT,
        		PersonName TEXT,
            PersonContactNo TEXT,
        		PersonDesignation TEXT,
            OfficeName TEXT,
            OfficeAddress TEXT,
        		NearestLandMark TEXT,
            GeneralComments TEXT,
        		OutComeVerification TEXT,
            GpsLocation TEXT,
            GpsURL TEXT,
        		Status TEXT,
            StatusDate TEXT,
            isSync TEXT,
            OrderTop INTEGER,
        		FOREIGN KEY(InquiryId) REFERENCES $TABLE_INQUIRY(ID))
            ''');
    // TABLE_OFFICE_ADDRESSDETAILS
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $TABLE_OFFICE_ADDRESSDETAILS(
            WorkOfficeVerificationId INTEGER PRIMARY KEY,
        		InquiryId INTEGER,
            PersonType TEXT,
        		WasActualAddressSame TEXT,
            CorrectAddress TEXT,
        		EstablishedTime TEXT,
            WorkAtGivenAddress TEXT,
        		GiveNewAddress TEXT,
            IsApplicantAvailable TEXT,
        		GiveReason TEXT,
            MetPersonCNIC TEXT,
            MetPersonName TEXT,
            CNICOS TEXT,
        		CNICNo TEXT,
            Status TEXT,
        		FOREIGN KEY(InquiryId) REFERENCES $TABLE_OFFICEVERIFICATION(WorkOfficeVerificationId))
            ''');
    //TABLE_OFFICE_BussWrkDETAILS
    await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_OFFICE_BussWrkDETAILS(
            WorkOfficeVerificationId INTEGER PRIMARY KEY,
        		InquiryId INTEGER,
            PersonType TEXT,
        		TypeOfBusiness TEXT,
            OtherTypeOfBusiness TEXT,
        		NatureOfBusiness TEXT,
            OtherNatureOfBusiness TEXT,
        		ApplicantIsA TEXT,
            MentionOther TEXT,
            MentionRent TEXT,
        		BusinessLegalEntity TEXT,
            GovtEmpBusinessLegalEntity TEXT,
        		NamePlateAffixed INTEGER,
            SizeApproxArea TEXT,
            BusinessActivity TEXT,
        		NoOfEmployees INTEGER,
            BusinessEstablesSince TEXT,
        		LineOfBusiness TEXT,
            Status TEXT,
        		FOREIGN KEY(InquiryId) REFERENCES $TABLE_OFFICEVERIFICATION(WorkOfficeVerificationId))
            ''');
    // TABLE_OFFICE_NghbrCHECK
    await db.execute('''
           CREATE TABLE IF NOT EXISTS $TABLE_OFFICE_NghbrCHECK(
            WorkOfficeVerificationId INTEGER PRIMARY KEY,
        		InquiryId INTEGER,
            PersonType TEXT,
            NeighborsName TEXT,
        		NeighborsAddress TEXT,
            KnowsApplicant TEXT, 
        		KnowsHowint TEXT,
            NeighborComments TEXT,
        		BusinessEstablishedSinceMarketeCheck TEXT,
            NeighborsTwoName TEXT,
            NeighborsTwoAddress TEXT,
            NeighborsTwoKnowsApplicant TEXT,
            NeighborsTwoKnowsHowLong TEXT,
            NeighborsTwoNeighborComments TEXT,
            NeighborsTwoBusinessEstablishedSinceMarketeCheck TEXT,
            Status TEXT,
            Status2 TEXT,
        		FOREIGN KEY(InquiryId) REFERENCES $TABLE_OFFICEVERIFICATION(WorkOfficeVerificationId))
            ''');
    // TABLE_OFFICE_HR_DETAILS
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $TABLE_OFFICE_HR_DETAILS(
          WorkOfficeVerificationId INTEGER PRIMARY KEY,
					InquiryId INTEGER,
          PersonType TEXT,
          NameOfPersonToMeet TEXT,
					OHrKnowsApplicant INTEGER,
          ApplicantEmployementStatus TEXT,
					ApplicantEmployementPeriod TEXT, 
          ApplicantDesignation TEXT,
					OHrNatureOfBusiness TEXT,
          OHrOtherNatureOfBusiness TEXT,
					GrossSalary REAL,
          NetTakeHomeSalary REAL,
          SalarySlipVerified TEXT,
          Status TEXT,
					FOREIGN KEY(InquiryId) REFERENCES $TABLE_OFFICEVERIFICATION(WorkOfficeVerificationId))
          ''');
    // BANKSTATEMENT VERIFICATION
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $TABLE_BANKSTATEMENT_VERIFICATION(
            NearestLandMark TEXT,
            BankStatementVerificationId INTEGER PRIMARY KEY,
        		InquiryId INTEGER,
            UserID TEXT,
            PersonType TEXT,
        		PersonName TEXT,
            PersonContactNo TEXT,
            BankName TEXT,
        		BankAddress TEXT,
        		GeneralComments TEXT,
            OutComeVerification TEXT,
        		GpsLocation TEXT,
            GpsURL TEXT,
        		Status TEXT,
            Inquiry TEXT,
            StatusDate TEXT,
            isSync TEXT,
            OrderTop INTEGER,
        		FOREIGN KEY(InquiryId) REFERENCES $TABLE_INQUIRY(ID))
            ''');
    // SALARYSLIP VERIFICATION
    await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_SALARYSLIP_VERIFICATION(
            SalarySlipVerificationId INTEGER PRIMARY KEY,
        		InquiryId INTEGER,
            UserID TEXT,
            PersonType TEXT,
        		PersonName TEXT,
            PersonContactNo TEXT,
        		OfficeName TEXT,
            OfficeAddress TEXT,
            NearestLandMark TEXT,
        		GeneralComments TEXT,
            OutComeVerification TEXT,
        		GpsLocation TEXT,
            GpsURL TEXT,
        		Status TEXT,
            StatusDate TEXT,
            Inquiry TEXT,
            isSync TEXT,
            OrderTop INTEGER,
        		FOREIGN KEY(InquiryId) REFERENCES $TABLE_INQUIRY(ID))
            ''');
    // TENANT VERIFICATION
    await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_TENANT_VERIFICATION(
            TenantVerificationId INTEGER PRIMARY KEY,
        		InquiryId INTEGER,
            UserID TEXT,
            PersonType TEXT,
        		PersonName TEXT,
            PersonContactNo TEXT,
        		TenantAddress TEXT,
            NearestLandMark TEXT,
        		TenantName TEXT,
            TenantContactNo TEXT,
        		TenantCNIC TEXT,
            TenancyPeriod TEXT,
        		TenantRent INTEGER,
        		GeneralComments TEXT,
            OutComeVerification TEXT,
        		GpsLocation TEXT,
            GpsURL TEXT,
        		Status TEXT,
            Inquiry TEXT,
            StatusDate TEXT,
            isSync TEXT,
            OrderTop INTEGER,
        		FOREIGN KEY(InquiryId) REFERENCES $TABLE_INQUIRY(ID))
            ''');
  }

// *************************************************************
//              PUT DATA IN TABLES
// *************************************************************
  static Future createUserinfoDB(LoginResponse res) async {
    try {
      Database db = await DBHelper.initDB();

      Map<String, dynamic> loginResponseData = {
        'message': loginresponse.message,
      };
      if (loginresponse.user != null) {
        Map<String, dynamic> userResponse = {
          'UserName': loginresponse.user!.userName,
          'FirstName': loginresponse.user!.firstName,
          'LastName': loginresponse.user!.lastName,
          'PasswordHash': loginresponse.user!.passwordHash,
          'code': loginresponse.user!.code,
          'BranchId': loginresponse.user!.branchId,
          'Id': loginresponse.user!.id,
        };
        var newData, userNewData;
        newData = await db.insert(TABLE_LOGINRESPONSE, loginResponseData);
        userNewData = await db.insert(TABLE_USER, userResponse);
        return userNewData;
      } else {
        EVSLogger.appendLog("LoginResponse in db is Empty line 365 DbHelper");
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on createUserinfoDB method line#365-dbhelper : ${e.toString()}");
    }
  }

  static Future CreateAppversion() async {
    Database db = await DBHelper.initDB();
    int vr = 0;
    try {
      await db.insert(TABLE_APPVER, {'appversion': vr});
    } catch (e) {}
  }

  static Future<int> ReadAppversion() async {
    Database db = await DBHelper.initDB();
    int version = 1;

    try {
      await DBHelper.CreateAppversion();
      var ver = await db.query(TABLE_APPVER);
      if (ver.isNotEmpty) {
        version = ver.first['appversion'] as int;
      }
    } catch (e) {}

    return version;
  }

  static Future UpdateVersion(int newVersion) async {
    Database db = await DBHelper.initDB();
    try {
      await db.update(TABLE_APPVER, {'appversion': newVersion});
    } catch (e) {}
  }

  //Method for Reading the response of Database which comes from User class
  static Future<List<User>> Readresponse() async {
    List<User> userList = [];
    try {
      Database db = await DBHelper.initDB();
      var userresponse = await db.query(TABLE_USER, orderBy: 'userName');

      userList = userresponse.map((details) => User.fromJson(details)).toList();
      for (int i = 0; i < userList.length;) {
        id = userList[0].id.toString();
        UserName = userList[0].userName.toString();
        break;
      }
      print(userList);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on ReadResponse method line#396-dbhelper: ${e.toString()}");
    }
    return Future.value(userList);
  }

// Method of creating Database of Data lists
  static Future CreateInquiriesResponseDB(List<Data> dataa) async {
    try {
      Database db = await DBHelper.initDB();
      int count = -1;
      for (int i = 0; i < dataa.length; i++) {
        Data newdata = dataa[i];

        count++;
        Map<String, dynamic> DataEntry = {
          'InquiryId': newdata.InquiryId,
          'UserID': id,
          'CompanyId': newdata.CompanyId,
          'CompanyName': newdata.CompanyName,
          'BranchId': newdata.BranchId,
          'BranchName': newdata.BranchName,
          'CustomerBranchId': newdata.CustomerBranchId,
          'CustomerBranchName': newdata.CustomerBranchName,
          'ProductId': newdata.ProductId,
          'ProductName': newdata.ProductName,
          'AppNo': newdata.AppNo,
          'AppName': newdata.AppName,
          'AppContact': newdata.AppContact,
          'AppCNIC': newdata.AppCNIC,
          'orignalIndex': count,
          'Status': '${InquiryStatus.InProgress}',
          'islongPressed': 0,
          'addedtotop': ""
        };

        var newpin = await db.insert(TABLE_INQUIRY, DataEntry);

        print(newpin);
      }
      for (int i = 0; i < dataa.length; i++) {
        for (final tenant in dataa[i].tenantVerifications!) {
          await db.insert(TABLE_TENANT_VERIFICATION, {
            'TenantVerificationId': tenant.TenantVerificationId,
            'InquiryId': tenant.InquiryId,
            'NearestLandMark': tenant.NearestLandMark,
            'UserID': id,
            'PersonType': tenant.PersonType,
            'PersonName': tenant.PersonName,
            'PersonContactNo': tenant.PersonContactNo,
            'TenantAddress': tenant.TenantAddress,
            'TenantName': tenant.TenantName,
            'TenantContactNo': tenant.TenantContactNo,
            'TenantCNIC': tenant.TenantCNIC,
            'TenancyPeriod': tenant.TenancyPeriod,
            'TenantRent': tenant.TenantRent,
            'GeneralComments': tenant.GeneralComments,
            'OutComeVerification': tenant.OutComeVerification,
            'GpsLocation': tenant.GpsLocation,
            'GpsURL': tenant.GpsURL,
            'Status': '${InquiryStatus.InProgress}',
            'StatusDate': tenant.StatusDate,
            'Inquiry': '${InquiryTypes.TenantVerification}',
            'isSync': "None",
            'OrderTop': 0,
          });
          await db.insert(TABLE_STATUS, {
            'InquiryId': tenant.InquiryId,
            'VerificationId': tenant.TenantVerificationId,
            'VerificationType': '${InquiryTypes.Tenant}',
            'Status': '${InquiryStatus.InProgress}'
          });
        }

        for (final work in dataa[i].workOfficeVerifications!) {
          await db.insert(TABLE_OFFICEVERIFICATION, {
            'WorkOfficeVerificationId': work.WorkOfficeVerificationId,
            'NearestLandMark': work.NearestLandMark,
            'InquiryId': work.InquiryId,
            'UserID': id,
            'PersonType': work.PersonType,
            'PersonName': work.PersonName,
            'PersonContactNo': work.PersonContactNo,
            'PersonDesignation': work.PersonDesignation,
            'OfficeName': work.OfficeName,
            'OfficeAddress': work.OfficeAddress,
            'GeneralComments': work.GeneralComments,
            'OutComeVerification': work.OutComeVerification,
            'GpsLocation': work.GpsLocation,
            'GpsURL': work.GpsURL,
            'Status': '${InquiryStatus.InProgress}',
            'StatusDate': work.StatusDate,
            'isSync': "None",
            'OrderTop': 0
          });
          await db.insert(TABLE_STATUS, {
            'InquiryId': work.InquiryId,
            'VerificationId': work.WorkOfficeVerificationId,
            'VerificationType': '${InquiryTypes.OfficeVerification}',
            'Status': '${InquiryStatus.InProgress}'
          });
        }

        for (final residence in dataa[i].residenceVerifications!) {
          await db.insert(TABLE_RESIDENCEVERIFICATION, {
            'ResidenceVerificationId': residence.ResidenceVerificationId,
            'InquiryId': residence.InquiryId,
            'NearestLandMark': residence.NearestLandMark,
            'UserID': id,
            'PersonType': residence.PersonType,
            'PersonName': residence.PersonName,
            'PersonContactNo': residence.PersonContactNo,
            'PersonCNIC': residence.PersonCNIC,
            'ResidenceAddress': residence.ResidenceAddress,
            'GeneralComments': residence.GeneralComments,
            'OutComeVerification': residence.OutComeVerification,
            'GpsLocation': residence.GpsLocation,
            'GpsURL': residence.GpsURL,
            'Status': '${InquiryStatus.InProgress}',
            'StatusDate': residence.StatusDate,
            'isSync': "none",
            'OrderTop': 0,
          });
          await db.insert(TABLE_STATUS, {
            'InquiryId': residence.InquiryId,
            'VerificationId': residence.ResidenceVerificationId,
            'VerificationType': '${InquiryTypes.ResidenceVerification}',
            'Status': '${InquiryStatus.InProgress}'
          });
        }

        for (final salary in dataa[i].salarySlipVerifications!) {
          await db.insert(TABLE_SALARYSLIP_VERIFICATION, {
            'SalarySlipVerificationId': salary.SalarySlipVerificationId,
            'InquiryId': salary.InquiryId,
            'UserID': id,
            'NearestLandMark': salary.NearestLandMark,
            'PersonType': salary.PersonType,
            'PersonName': salary.PersonName,
            'PersonContactNo': salary.PersonContactNo,
            'OfficeName': salary.OfficeName,
            'OfficeAddress': salary.OfficeAddress,
            'GeneralComments': salary.GeneralComments,
            'OutComeVerification': salary.OutComeVerification,
            'GpsLocation': salary.GpsLocation,
            'GpsURL': salary.GpsURL,
            'Status': '${InquiryStatus.InProgress}',
            'StatusDate': salary.StatusDate,
            'isSync': "None",
            'Inquiry': '${InquiryTypes.SalarySlipSlipVerification}',
            'OrderTop': 0,
          });
          await db.insert(TABLE_STATUS, {
            'InquiryId': salary.InquiryId,
            'VerificationId': salary.SalarySlipVerificationId,
            'VerificationType': '${InquiryTypes.SalarySlipSlipVerification}',
            'Status': '${InquiryStatus.InProgress}'
          });
        }

        for (final bank in dataa[i].bankStatementVerifications!) {
          await db.insert(TABLE_BANKSTATEMENT_VERIFICATION, {
            'BankStatementVerificationId': bank.BankStatementVerificationId,
            'InquiryId': bank.InquiryId,
            'UserID': id,
            'NearestLandMark': bank.NearestLandMark,
            'PersonType': bank.PersonType,
            'PersonName': bank.PersonName,
            'PersonContactNo': bank.PersonContactNo,
            'BankName': bank.BankName,
            'BankAddress': bank.BankAddress,
            'GeneralComments': bank.GeneralComments,
            'OutComeVerification': bank.OutComeVerification,
            'GpsLocation': bank.GpsLocation,
            'GpsURL': bank.GpsURL,
            'Status': '${InquiryStatus.InProgress}',
            'StatusDate': bank.StatusDate,
            'isSync': "None",
            'OrderTop': 0,
            'Inquiry': '${InquiryTypes.BankStatementVerification}'
          });
          await db.insert(TABLE_STATUS, {
            'InquiryId': bank.InquiryId,
            'VerificationId': bank.BankStatementVerificationId,
            'VerificationType': '${InquiryTypes.BankStatementVerification}',
            'Status': '${InquiryStatus.InProgress}'
          });
        }
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          'Exception on CreateInquiriesResponseDB method line#417-dbhelper: ${e.toString()}');
      throw e;
    }
  }

  // Entering Values into Residence Verification Table
  static Future<void> createResidenceHomesData(
      ResidenceDetail resDetail) async {
    try {
      Database db = await DBHelper.initDB();
      if (resDetail != null) {
        db.insert(TABLE_RESIDENCE_DETAILS, {
          'ResidenceVerificationId': resDetail.ResidenceVerificationId,
          'IsApplicantAvailable': resDetail.IsApplicantAvailable,
          'NameOfPersonToMet': resDetail.NameOfPersonToMet,
          'RelationWithApplicant': resDetail.RelationWithApplicant,
          'WasActualAddressSame': resDetail.WasActualAddressSame,
          'CorrectAddress': resDetail.CorrectAddress,
          'PhoneNo': resDetail.PhoneNo,
          'LivesAtGivenAddress': resDetail.LivesAtGivenAddress,
          'PermanentAddress': resDetail.PermanentAddress,
          'SinceHowintLiving': resDetail.SinceHowintLiving,
          'CNICNo': resDetail.CNICNo,
          'InquiryId': resDetail.InquiryId,
          'PersonType': resDetail.PersonType,
          'Status': '${InquiryStatus.InProgress}',
        });
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on createResidenceHomesData method line#601-Dbhelper: ${e.toString()}");
    }
  }

  static Future<void> CreateResidenceProfiledB(ResidenceProfile resProf) async {
    try {
      Database db = await DBHelper.initDB();
      if (resProf != null) {
        db.insert(TABLE_RESIDENCE_PROFILE, {
          'ResidenceVerificationId': resProf.ResidenceVerificationId,
          'InquiryId': resProf.InquiryId,
          'ApplicantIsA': resProf.ApplicantIsA,
          'AreaAccessibility': resProf.AreaAccessibility,
          'MentionOther': resProf.MentionOther,
          'MentionRent': resProf.MentionRent,
          'Neighborhood': resProf.Neighborhood,
          'RentDeedVerified': resProf.RentDeedVerified,
          'RepossessionInTheArea': resProf.RepossessionInTheArea,
          'ResidentsBelongsTo': resProf.ResidentsBelongsTo,
          'SizeApproxArea': resProf.SizeApproxArea,
          'TypeOfResidence': resProf.TypeOfResidence,
          'UtilizationOfResidence': resProf.UtilizationOfResidence,
          'Status': '${InquiryStatus.InProgress}',
        });
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on CreateResidenceProfiledB method line#629-dbhelper: ${e.toString()}");
    }
  }

  static Future<void> createResidenceNeighbor(NeighbourCheck nCheck) async {
    try {
      Database db = await DBHelper.initDB();
      if (nCheck != null) {
        db.insert(TABLE_RESIDENCE_NEIGHBOUR, {
          'InquiryId': nCheck.InquiryId,
          'ResidenceVerificationId': nCheck.ResidenceVerificationId,
          'KnowsApplicant': nCheck.KnowsApplicant,
          'KnowsHowLong': nCheck.KnowsHowLong,
          'NeighborAddress': nCheck.NeighborAddress,
          'NeighborComments': nCheck.NeighborComments,
          'NeighborName': nCheck.NeighborName,
          'NeighborsName2': nCheck.NeighborsName2,
          'NeighborsAddress2': nCheck.NeighborsAddress2,
          'KnowsApplicant2': nCheck.KnowsApplicant2,
          'KnowsHowLong2': nCheck.KnowsHowLong2,
          'NeighborComments2': nCheck.NeighborComments2,
          'Status': '${InquiryStatus.InProgress}',
          'Status2': '${InquiryStatus.InProgress}'
        });
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on createResidenceNeighbor method line#656-dbhelper: ${e.toString()} ");
    }
  }

// Entering Values into OFFICE Verification Table
  static Future<void> createOfficeAddressdb(
      OfficeAddressDetail addressDetails) async {
    try {
      Database db = await DBHelper.initDB();

      if (addressDetails != null) {
        int existingCount = await db.query(TABLE_OFFICE_ADDRESSDETAILS,
            where: 'InquiryId = ?',
            whereArgs: [
              addressDetails.InquiryId
            ]).then((value) => value.length);
        if (existingCount == 0) {
          db.insert(TABLE_OFFICE_ADDRESSDETAILS, {
            'InquiryId': addressDetails.InquiryId,
            'WorkOfficeVerificationId': addressDetails.WorkOfficeVerificationId,
            'WorkAtGivenAddress': addressDetails.WorkAtGivenAddress,
            'WasActualAddressSame': addressDetails.WasActualAddressSame,
            'MetPersonName': addressDetails.MetPersonName,
            'MetPersonCNIC': addressDetails.MetPersonCNIC,
            'IsApplicantAvailable': addressDetails.IsApplicantAvailable,
            'GiveReason': addressDetails.GiveReason,
            'GiveNewAddress': addressDetails.GiveNewAddress,
            'EstablishedTime': addressDetails.EstablishedTime,
            'CorrectAddress': addressDetails.CorrectAddress,
            'CNICOS': addressDetails.CNICOS,
            'CNICNo': addressDetails.CNICNo,
            'Status': '${InquiryStatus.InProgress}',
          });
        }
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on createOfficeAddressdb method line#678-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> createWorkOfficeDb(
      BusinessWorkOfficeDetail wrkofficedetail) async {
    try {
      Database db = await DBHelper.initDB();
      if (wrkofficedetail != null) {
        db.insert(TABLE_OFFICE_BussWrkDETAILS, {
          'WorkOfficeVerificationId': wrkofficedetail.WorkOfficeVerificationId,
          'InquiryId': wrkofficedetail.InquiryId,
          'TypeOfBusiness': wrkofficedetail.TypeOfBusiness,
          'OtherTypeOfBusiness': wrkofficedetail.OtherTypeOfBusiness,
          'ApplicantIsA': wrkofficedetail.ApplicantIsA,
          'MentionOther': wrkofficedetail.MentionOther,
          'MentionRent': wrkofficedetail.MentionRent,
          'NatureOfBusiness': wrkofficedetail.NatureOfBusiness,
          'OtherNatureOfBusiness': wrkofficedetail.OtherNatureOfBusiness,
          'BusinessLegalEntity': wrkofficedetail.BusinessLegalEntity,
          'NamePlateAffixed': wrkofficedetail.NamePlateAffixed,
          'SizeApproxArea': wrkofficedetail.SizeApproxArea,
          'BusinessActivity': wrkofficedetail.BusinessActivity,
          'NoOfEmployees': wrkofficedetail.NoOfEmployees,
          'BusinessEstablesSince': wrkofficedetail.BusinessEstablesSince,
          'LineOfBusiness': wrkofficedetail.LineOfBusiness,
          'GovtEmpBusinessLegalEntity':
              wrkofficedetail.GovtEmpBusinessLegalEntity,
          'Status': '${InquiryStatus.InProgress}',
        });
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on createWorkOfficeDb method line#714-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> CreateHRDb(OfficeHRDetail hrDetail) async {
    try {
      Database db = await DBHelper.initDB();
      if (hrDetail != null) {
        db.insert(TABLE_OFFICE_HR_DETAILS, {
          'WorkOfficeVerificationId': hrDetail.WorkOfficeVerificationId,
          'InquiryId': hrDetail.InquiryId,
          'ApplicantDesignation': hrDetail.ApplicantDesignation,
          'ApplicantEmployementPeriod': hrDetail.ApplicantEmployementPeriod,
          'ApplicantEmployementStatus': hrDetail.ApplicantEmployementStatus,
          'GrossSalary': hrDetail.GrossSalary,
          'NameOfPersonToMeet': hrDetail.NameOfPersonToMeet,
          'NetTakeHomeSalary': hrDetail.NetTakeHomeSalary,
          'OHrKnowsApplicant': hrDetail.OHrKnowsApplicant,
          'OHrNatureOfBusiness': hrDetail.OHrNatureOfBusiness,
          'SalarySlipVerified': hrDetail.SalarySlipVerified,
          'OHrOtherNatureOfBusiness': hrDetail.OHrOtherNatureOfBusiness,
          'Status': '${InquiryStatus.InProgress}',
        });
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on CreateHRDb method line#747-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> CreateHRDbForNonSalaried(OfficeHRDetail hrDetail) async {
    try {
      Database db = await DBHelper.initDB();
      if (hrDetail != null) {
        db.insert(TABLE_OFFICE_HR_DETAILS, {
          'WorkOfficeVerificationId': hrDetail.WorkOfficeVerificationId,
          'InquiryId': hrDetail.InquiryId,
          'ApplicantDesignation': hrDetail.ApplicantDesignation,
          'ApplicantEmployementPeriod': hrDetail.ApplicantEmployementPeriod,
          'ApplicantEmployementStatus': hrDetail.ApplicantEmployementStatus,
          'GrossSalary': hrDetail.GrossSalary,
          'NameOfPersonToMeet': hrDetail.NameOfPersonToMeet,
          'NetTakeHomeSalary': hrDetail.NetTakeHomeSalary,
          'OHrKnowsApplicant': hrDetail.OHrKnowsApplicant,
          'OHrNatureOfBusiness': hrDetail.OHrNatureOfBusiness,
          'SalarySlipVerified': hrDetail.SalarySlipVerified,
          'OHrOtherNatureOfBusiness': hrDetail.OHrOtherNatureOfBusiness,
          'Status': '${InquiryStatus.InProgress}',
        });
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on CreateHRDb method line#747-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> createOfficeMarketCheckdb(
      MarketeCheck officeMArket) async {
    try {
      Database db = await DBHelper.initDB();
      if (officeMArket != null) {
        db.insert(TABLE_OFFICE_NghbrCHECK, {
          'BusinessEstablishedSinceMarketeCheck':
              officeMArket.BusinessEstablishedSinceMarketeCheck,
          'InquiryId': officeMArket.InquiryId,
          'KnowsApplicant': officeMArket.KnowsApplicant,
          'KnowsHowint': officeMArket.KnowsHowint,
          'WorkOfficeVerificationId': officeMArket.WorkOfficeVerificationId,
          'NeighborComments': officeMArket.NeighborComments,
          'NeighborsAddress': officeMArket.NeighborsAddress,
          'NeighborsName': officeMArket.NeighborsName,
          'NeighborsTwoBusinessEstablishedSinceMarketeCheck':
              officeMArket.NeighborsTwoBusinessEstablishedSinceMarketeCheck,
          'NeighborsTwoKnowsApplicant': officeMArket.NeighborsTwoKnowsApplicant,
          'NeighborsTwoKnowsHowLong': officeMArket.NeighborsTwoKnowsHowLong,
          'NeighborsTwoName': officeMArket.NeighborsTwoName,
          'NeighborsTwoNeighborComments':
              officeMArket.NeighborsTwoNeighborComments,
          'Status': '${InquiryStatus.InProgress}',
          'Status2': '${InquiryStatus.InProgress}',
        });
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on createOfficeMarketCheckdb method line#773-dbhelper: ${e.toString()} ");
    }
  }

  // Creating Image Database
  static Future<void> createImageDB(List<PostImages> post) async {
    try {
      Database db = await DBHelper.initDB();
      if (post != null) {
        for (int i = 0; i < post.length; i++) {
          var pic = post[i];
          await db.insert(TABLE_INQUIRYPHOTOS, {
            'VerificationId': pic.VerificationId,
            'PersonType': pic.PersonType,
            'VerificationType': pic.VerificationType,
            'InquiryId': pic.InquiryId,
            'appPhoto': pic.appPhoto
          });
        }
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on createImageDB method line#798-dbhelper: ${e.toString()} ");
    }
  }
// *************************************************************
//              RETRIEVE DATA FROM TABLE
// *************************************************************

  static Future<List<Data>> DataResponse() async {
    List<Data> DataList = [];
    try {
      Database db = await DBHelper.initDB();
      List<Map<String, dynamic>> dataRows = await db.query(TABLE_INQUIRY,
          orderBy: 'orignalIndex', where: 'UserID = ?', whereArgs: [id]);
      for (var datarow in dataRows) {
        final dataID = datarow['InquiryId'];
        List<Map<String, dynamic>> tenantRows = await db.query(
            TABLE_TENANT_VERIFICATION,
            orderBy: 'PersonName',
            where: 'InquiryId=?',
            whereArgs: [dataID]);
        List<Map<String, dynamic>> officeRows = await db.query(
            TABLE_OFFICEVERIFICATION,
            orderBy: 'PersonName',
            where: 'InquiryId=?',
            whereArgs: [dataID]);
        List<Map<String, dynamic>> ResidenceRows = await db.query(
            TABLE_RESIDENCEVERIFICATION,
            orderBy: 'PersonName',
            where: 'InquiryId=?',
            whereArgs: [dataID]);
        List<Map<String, dynamic>> BankRows = await db.query(
            TABLE_BANKSTATEMENT_VERIFICATION,
            orderBy: 'PersonName',
            where: 'InquiryId=?',
            whereArgs: [dataID]);
        List<Map<String, dynamic>> Sliprows = await db.query(
            TABLE_SALARYSLIP_VERIFICATION,
            orderBy: 'PersonName',
            where: 'InquiryId=?',
            whereArgs: [dataID]);
        List<TenantVerifications> tenants = tenantRows
            .map((tenent) => TenantVerifications.fromJson(tenent))
            .toList();
        List<WorkOfficeVerifications> office = officeRows
            .map((officedata) => WorkOfficeVerifications.fromJson(officedata))
            .toList();
        List<ResidenceVerifications> Residence = ResidenceRows.map(
            (residenceData) =>
                ResidenceVerifications.fromJson(residenceData)).toList();
        List<BankStatementVerifications> Bank = BankRows.map(
                (bankData) => BankStatementVerifications.fromJson(bankData))
            .toList();
        List<SalarySlipVerifications> Slip = Sliprows.map(
            (SlipData) => SalarySlipVerifications.fromJson(SlipData)).toList();

        DataList.add(Data(
            CompanyName: datarow['CompanyName'],
            ProductName: datarow['ProductName'],
            AppContact: datarow['AppContact'],
            InquiryId: datarow['InquiryId'],
            CompanyId: datarow['CompanyId'],
            BranchId: datarow['BranchId'],
            CustomerBranchId: datarow['CustomerBranchId'],
            ProductId: datarow['ProductId'],
            BranchName: datarow['BranchName'],
            CustomerBranchName: datarow['CustomerBranchName'],
            AppNo: datarow['AppNo'],
            AppName: datarow['AppName'],
            AppCNIC: datarow['AppCNIC'],
            Status: datarow['Status'],
            orignalIndex: datarow['orignalIndex'],
            addedtotop: datarow['addedtotop'],
            tenantVerifications: tenants,
            salarySlipVerifications: Slip,
            workOfficeVerifications: office,
            bankStatementVerifications: Bank,
            residenceVerifications: Residence));
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on DataResponse line#818-Dbhelper: ${e.toString()}");
      throw e;
    }

    return Future.value(DataList);
  }

  static Future<List<ResidenceDetail>> ResponseResidenceDetail(
      int resID) async {
    List<ResidenceDetail> residenceDetailList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_RESIDENCE_DETAILS != null) {
        List<Map<String, dynamic>> resDetailRows =
            await db.query(TABLE_RESIDENCE_DETAILS);
        List<Map<String, dynamic>> resDetail = await db.query(
            TABLE_RESIDENCE_DETAILS,
            where: 'InquiryId = ?',
            whereArgs: [resID]);
        List<ResidenceDetail> details = resDetail
            .map((residentDetails) => ResidenceDetail.fromJson(residentDetails))
            .toList();
        residenceDetailList.addAll(details);
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on ResidenceDetails Response line#898-Dbhelper: ${e.toString()}");
      throw e;
    }
    return residenceDetailList;
  }

  static Future<List<NeighbourCheck>> responseResidenceNeighbor(
      int resNID) async {
    List<NeighbourCheck> residenceNeighborList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_RESIDENCE_NEIGHBOUR != null) {
        List<Map<String, dynamic>> resRows =
            await db.query(TABLE_RESIDENCE_NEIGHBOUR);

        List<Map<String, dynamic>> resNeighbor = await db.query(
            TABLE_RESIDENCE_NEIGHBOUR,
            where: 'InquiryId = ?',
            whereArgs: [resNID]);
        List<NeighbourCheck> Neighbor = resNeighbor
            .map(
                (residentNeighbor) => NeighbourCheck.fromJson(residentNeighbor))
            .toList();
        residenceNeighborList.addAll(Neighbor);
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on ResidenceNeighbor Response line#926-Dbhelper: ${e.toString()}");
      throw e;
    }
    return residenceNeighborList;
  }

  static Future<List<ResidenceProfile>> responseResidenceProfile(
      int resID) async {
    List<ResidenceProfile> residenceProfileList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_RESIDENCE_PROFILE != null) {
        List<Map<String, dynamic>> resRows =
            await db.query(TABLE_RESIDENCE_PROFILE);

        List<Map<String, dynamic>> resProfile = await db.query(
            TABLE_RESIDENCE_PROFILE,
            where: 'InquiryId = ?',
            whereArgs: [resID]);
        List<ResidenceProfile> Profile = resProfile
            .map(
                (residentProfile) => ResidenceProfile.fromJson(residentProfile))
            .toList();
        residenceProfileList.addAll(Profile);
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on ResidenceProfile Response line#955-Dbhelper: ${e.toString()}");
      throw e;
    }
    return residenceProfileList;
  }

  static Future<List<OfficeAddressDetail>> responseOfficeAddress(
      int offID) async {
    List<OfficeAddressDetail> OfficeAddressList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_OFFICE_ADDRESSDETAILS != null) {
        List<Map<String, dynamic>> OfficeRows =
            await db.query(TABLE_OFFICE_ADDRESSDETAILS);

        List<Map<String, dynamic>> offAddress = await db.query(
            TABLE_OFFICE_ADDRESSDETAILS,
            where: 'InquiryId = ?',
            whereArgs: [offID]);
        List<OfficeAddressDetail> Address = offAddress
            .map((OfficeAddress) => OfficeAddressDetail.fromJson(OfficeAddress))
            .toList();
        OfficeAddressList.addAll(Address);
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on OfficeAddress Response line#984-Dbhelper: ${e.toString()}");
      throw e;
    }
    return OfficeAddressList;
  }

  static Future<List<BusinessWorkOfficeDetail>> responseworkOfficeDetails(
      int offID) async {
    List<BusinessWorkOfficeDetail> OfficeDetailList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_OFFICE_BussWrkDETAILS != null) {
        List<Map<String, dynamic>> OfficeRows =
            await db.query(TABLE_OFFICE_BussWrkDETAILS);

        List<Map<String, dynamic>> offDetail = await db.query(
            TABLE_OFFICE_BussWrkDETAILS,
            where: 'InquiryId = ?',
            whereArgs: [offID]);
        List<BusinessWorkOfficeDetail> Details = offDetail
            .map((OfficeDetails) =>
                BusinessWorkOfficeDetail.fromJson(OfficeDetails))
            .toList();
        OfficeDetailList.addAll(Details);
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on WorkOfficeDetails Response line#1013-Dbhelper: ${e.toString()}");
      throw e;
    }
    return OfficeDetailList;
  }

  static Future<List<MarketeCheck>> responseOfficeMarketchk(int offID) async {
    List<MarketeCheck> OfficeMarketList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_OFFICE_NghbrCHECK != null) {
        if (TABLE_OFFICE_NghbrCHECK != null) {
          List<Map<String, dynamic>> OfficeRows =
              await db.query(TABLE_OFFICE_NghbrCHECK);

          List<Map<String, dynamic>> offMarket = await db.query(
              TABLE_OFFICE_NghbrCHECK,
              where: 'InquiryId = ?',
              whereArgs: [offID]);
          List<MarketeCheck> Market = offMarket
              .map((OfficeNeighbor) => MarketeCheck.fromJson(OfficeNeighbor))
              .toList();
          OfficeMarketList.addAll(Market);
        }
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on OfficeMarketCheck Response line#1043-Dbhelper: ${e.toString()}");
      throw e;
    }
    return OfficeMarketList;
  }

  static Future<List<OfficeHRDetail>> responseOffieHRchk(int offID) async {
    List<OfficeHRDetail> OfficeHRList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_OFFICE_HR_DETAILS != null) {
        List<Map<String, dynamic>> OfficeRows =
            await db.query(TABLE_OFFICE_HR_DETAILS);

        List<Map<String, dynamic>> offHR = await db.query(
            TABLE_OFFICE_HR_DETAILS,
            where: 'InquiryId = ?',
            whereArgs: [offID]);
        List<OfficeHRDetail> HR =
            offHR.map((OfficeHR) => OfficeHRDetail.fromJson(OfficeHR)).toList();
        OfficeHRList.addAll(HR);
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on OfficeHRCheck Response line#1073-Dbhelper: ${e.toString()}");
      throw e;
    }
    return OfficeHRList;
  }

  static Future<List<TenantVerifications>> responseTenant(int tenantID) async {
    List<TenantVerifications> tenantList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_TENANT_VERIFICATION != null) {
        List<Map<String, dynamic>> tenantRow =
            await db.query(TABLE_TENANT_VERIFICATION);

        List<Map<String, dynamic>> tenantdb = await db.query(
            TABLE_TENANT_VERIFICATION,
            where: 'InquiryId = ?',
            whereArgs: [tenantID]);
        List<TenantVerifications> tenants = tenantdb
            .map((tenantdata) => TenantVerifications.fromJson(tenantdata))
            .toList();
        tenantList.addAll(tenants);
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on Tenant Response line#1001-Dbhelper: ${e.toString()}");
      throw e;
    }
    return tenantList;
  }

  static Future<List<BankStatementVerifications>> responseBank(
      int bankID) async {
    List<BankStatementVerifications> bankList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_BANKSTATEMENT_VERIFICATION != null) {
        List<Map<String, dynamic>> bankRow =
            await db.query(TABLE_BANKSTATEMENT_VERIFICATION);

        List<Map<String, dynamic>> bankdb = await db.query(
            TABLE_BANKSTATEMENT_VERIFICATION,
            where: 'InquiryId = ?',
            whereArgs: [bankID]);
        List<BankStatementVerifications> bank = bankdb
            .map((bankdata) => BankStatementVerifications.fromJson(bankdata))
            .toList();
        bankList.addAll(bank);
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on Bank Response line#1129-Dbhelper: ${e.toString()}");
      throw e;
    }
    return bankList;
  }

  static Future<List<SalarySlipVerifications>> responseSalary(
      int SalaryID) async {
    List<SalarySlipVerifications> SalaryList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_SALARYSLIP_VERIFICATION != null) {
        List<Map<String, dynamic>> salaryRow =
            await db.query(TABLE_SALARYSLIP_VERIFICATION);

        List<Map<String, dynamic>> salaryDB = await db.query(
            TABLE_SALARYSLIP_VERIFICATION,
            where: 'InquiryId = ?',
            whereArgs: [SalaryID]);
        List<SalarySlipVerifications> salaries = salaryDB
            .map((Salarydata) => SalarySlipVerifications.fromJson(Salarydata))
            .toList();
        SalaryList.addAll(salaries);
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on Salary Response line#1157-Dbhelper ${e.toString()}");
      throw e;
    }
    return SalaryList;
  }

// *************************************************************
//              UPDATES IN  TABLE
// *************************************************************

  static Future<void> updateResidenceComments(
      int id,
      String generalComments,
      String outcomeVerification,
      List gpsLocation,
      String Status,
      String time) async {
    try {
      Database db = await DBHelper.initDB();

      final table = TABLE_RESIDENCEVERIFICATION;
      final values = {
        'GeneralComments': generalComments,
        'OutComeVerification': outcomeVerification,
        'GpsLocation': gpsLocation.join(', '),
        'Status': Status,
        'StatusDate': time
      };
      await db.update(
        table,
        values,
        where: 'ResidenceVerificationId = ?',
        whereArgs: [id],
      );
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateResidenceComments method line#1189-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateResidenceCommentStatus(int inqID) async {
    try {
      Database db = await DBHelper.initDB();
      final values = {'Status': '${InquiryStatus.Completed}'};
      await db.update(TABLE_STATUS, values,
          where: 'InquiryId = ? AND VerificationType = ?',
          whereArgs: [inqID, InquiryTypes.ResidenceVerification]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateResidenceCommentStatus method line#1213-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateOfficeComments(
      int id,
      String generalComments,
      String outcomeVerification,
      List gpsLocation,
      String status,
      String time) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_OFFICEVERIFICATION;
      final values = {
        'GeneralComments': generalComments,
        'OutComeVerification': outcomeVerification,
        'GpsLocation': gpsLocation.join(', '),
        'StatusDate': time,
        'Status': status
      };
      await db.update(table, values,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateOfficeComments method line#1226-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateOfficeCommentStatus(int inqID) async {
    try {
      Database db = await DBHelper.initDB();
      final values = {'Status': '${InquiryStatus.Completed}'};
      await db.update(TABLE_STATUS, values,
          where: 'InquiryId = ? AND VerificationType = ?',
          whereArgs: [inqID, InquiryTypes.OfficeVerification]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateOfficeCommentStatus method line#1245-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateBankdb(
      int id,
      String generalComments,
      String outcomeVerification,
      List gpsLocation,
      String Status,
      String time) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_BANKSTATEMENT_VERIFICATION;
      final values = {
        'GeneralComments': generalComments,
        'OutComeVerification': outcomeVerification,
        'GpsLocation': gpsLocation.join(', '),
        'StatusDate': time,
        'Status': Status
      };
      await db.update(table, values,
          where: 'BankStatementVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateBankdb method line#1258-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateBankfinalstatus(int id, String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_BANKSTATEMENT_VERIFICATION;
      final values = {'Status': Status};
      await db.update(table, values,
          where: 'BankStatementVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateBankfinalstatus method line#1277-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updatetenantfinalstatus(int id, String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_TENANT_VERIFICATION;
      final values = {'Status': Status};
      await db.update(table, values,
          where: 'TenantVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updatetenantfinalstatus method line#1290-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateSalaryfinalstatus(int id, String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_SALARYSLIP_VERIFICATION;
      final values = {'Status': Status};
      await db.update(table, values,
          where: 'SalarySlipVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateSalaryfinalstatus method line#1303-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateBankStatus(int inqID) async {
    try {
      Database db = await DBHelper.initDB();
      final values = {'Status': '${InquiryStatus.Completed}'};
      await db.update(TABLE_STATUS, values,
          where: 'InquiryId = ? AND VerificationType = ?',
          whereArgs: [inqID, InquiryTypes.BankStatementVerification]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateBankStatus method line#1316-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateSalarydb(
      int id,
      String generalComments,
      String outcomeVerification,
      List gpsLocation,
      String Status,
      String time) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_SALARYSLIP_VERIFICATION;
      final values = {
        'GeneralComments': generalComments,
        'OutComeVerification': outcomeVerification,
        'GpsLocation': gpsLocation.join(', '),
        'StatusDate': time,
        'Status': Status
      };
      await db.update(table, values,
          where: 'SalarySlipVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateSalarydb method line#1329-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updatSalaryStatus(int inqID) async {
    try {
      Database db = await DBHelper.initDB();
      final values = {'Status': '${InquiryStatus.Completed}'};
      await db.update(TABLE_STATUS, values,
          where: 'InquiryId = ? AND VerificationType = ?',
          whereArgs: [inqID, InquiryTypes.SalarySlipSlipVerification]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updatSalaryStatus method line#1348-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateResidenceStatus(String Status, int id) async {
    try {
      Database db = await DBHelper.initDB();
      final table1 = TABLE_RESIDENCEVERIFICATION;
      final values = {'Status': Status};
      await db.update(table1, values,
          where: 'ResidenceVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateResidenceStatus method line#1361-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> UpdateRInquiryStatus(int inqID) async {
    try {
      Database db = await DBHelper.initDB();
      final values = {'Status': '${InquiryStatus.PartialCompleted}'};
      await db.update(TABLE_STATUS, values,
          where: 'InquiryId = ? AND VerificationType = ?',
          whereArgs: [inqID, InquiryTypes.ResidenceVerification]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on UpdateRInquiryStatus method line#1374-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateOfficeStatus(String Status, int id) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_OFFICEVERIFICATION;
      final values = {'Status': Status};
      await db.update(table, values,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateOfficeStatus method line#1387-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> UpdateOffInquiryStatus(int inqID) async {
    try {
      Database db = await DBHelper.initDB();
      final values = {'Status': '${InquiryStatus.PartialCompleted}'};
      await db.update(TABLE_STATUS, values,
          where: 'InquiryId = ? AND VerificationType = ?',
          whereArgs: [inqID, InquiryTypes.OfficeVerification]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on UpdateOffInquiryStatus method line#1400-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateOffAddressstatus(int id, String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_OFFICE_ADDRESSDETAILS;
      final values = {'Status': Status};
      await db.update(table, values,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateOffAddressstatus method line#1413-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateOffWRKstatus(int id, String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_OFFICE_BussWrkDETAILS;
      final values = {'Status': Status};
      await db.update(table, values,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateOffWRKstatus method line#1426-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateOffMARKstatus(int id, String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_OFFICE_NghbrCHECK;
      final values = {'Status': Status};
      await db.update(table, values,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateOffMARKstatus method line#1439-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateOffMARK2status(int id, String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_OFFICE_NghbrCHECK;
      final values = {'Status2': Status};
      await db.update(table, values,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateOffMARKstatus method line#1439-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateMarketchk2data(int id, MarketeCheck mcheck) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_OFFICE_NghbrCHECK;
      final values = {
        'NeighborsTwoName': mcheck.NeighborsTwoName,
        'NeighborsTwoAddress': mcheck.NeighborsTwoAddress,
        'NeighborsTwoKnowsApplicant': mcheck.NeighborsTwoKnowsApplicant,
        'NeighborsTwoKnowsHowLong': mcheck.NeighborsTwoKnowsHowLong,
        'NeighborsTwoBusinessEstablishedSinceMarketeCheck':
            mcheck.NeighborsTwoBusinessEstablishedSinceMarketeCheck,
        'NeighborsTwoNeighborComments': mcheck.NeighborsTwoNeighborComments
      };
      await db.update(table, values,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [id]);
    } catch (e) {}
  }

  static Future<void> updateResidenceNeighborchk2data(
      int id, NeighbourCheck mcheck) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_RESIDENCE_NEIGHBOUR;
      final values = {
        'NeighborsName2': mcheck.NeighborsName2,
        'NeighborsAddress2': mcheck.NeighborsAddress2,
        'KnowsApplicant2': mcheck.KnowsApplicant2,
        'KnowsHowLong2': mcheck.KnowsHowLong2,
        'NeighborComments2': mcheck.NeighborComments2
      };
      await db.update(table, values,
          where: 'ResidenceVerificationId = ?', whereArgs: [id]);
    } catch (e) {}
  }

  static Future<void> updateOffHRstatus(int id, String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_OFFICE_HR_DETAILS;
      final values = {'Status': Status};
      await db.update(table, values,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateOffHRstatus method line#1452-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateResHomestatus(int id, String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_RESIDENCE_DETAILS;
      final values = {'Status': Status};
      await db.update(table, values,
          where: 'ResidenceVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateResHomestatus method line#1465-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateResProfilestatus(int id, String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_RESIDENCE_PROFILE;
      final values = {'Status': Status};
      await db.update(table, values,
          where: 'ResidenceVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateResProfilestatus method line#1478-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateResNeighborstatus(int id, String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_RESIDENCE_NEIGHBOUR;
      final values = {'Status': Status};
      await db.update(table, values,
          where: 'ResidenceVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateResNeighborstatus method line#1491-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateResNeighbor2status(int id, String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_RESIDENCE_NEIGHBOUR;
      final values = {'Status2': Status};
      await db.update(table, values,
          where: 'ResidenceVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateResNeighborstatus method line#1491-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> updateTenantDb(
      int id,
      String tenantName,
      String contactNo,
      String CNIC,
      String Period,
      String rent,
      String Gcomments,
      String Outcome,
      String time,
      List location,
      String Status) async {
    try {
      Database db = await DBHelper.initDB();
      final table = TABLE_TENANT_VERIFICATION;
      final values = {
        'TenantName': tenantName,
        'TenantContactNo': contactNo,
        'TenantCNIC': CNIC,
        'TenancyPeriod': Period,
        'TenantRent': rent,
        'GeneralComments': Gcomments,
        'OutComeVerification': Outcome,
        'GpsLocation': location.join(', '),
        'StatusDate': time,
        'Status': Status,
      };
      await db.update(table, values,
          where: 'TenantVerificationId = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on updateTenantDb method line#1504-dbhelper: ${e.toString()} ");
    }
  }

  static Future<void> UpdateTenantInquiryStatus(int inqID) async {
    try {
      Database db = await DBHelper.initDB();
      final values = {'Status': '${InquiryStatus.Completed}'};
      await db.update(TABLE_STATUS, values,
          where: 'InquiryId = ? AND VerificationType = ?',
          whereArgs: [inqID, InquiryTypes.Tenant]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on UpdateTenantInquiryStatus method line#1537-Dbhelper: ${e.toString()} ");
    }
  }

// Methods for updating status on Inquiry table
  static Future<String> getStatusList(int inquiryId) async {
    Database db = await DBHelper.initDB();

    final result = await db.query(TABLE_STATUS,
        columns: ['Status'], where: 'InquiryId = ?', whereArgs: [inquiryId]);

    List<String> statusList =
        List<String>.from(result.map((row) => row['Status']));
    String determineMasterStatus(List<String> statusList) {
      String mastStatus = '';
      if (statusList
          .every((status) => status == "${InquiryStatus.Completed}")) {
        mastStatus = "${InquiryStatus.Completed}";
      } else if (statusList
          .every((status) => status == "${InquiryStatus.InProgress}")) {
        mastStatus = "${InquiryStatus.InProgress}";
      } else if (statusList.contains("${InquiryStatus.PartialCompleted}")) {
        mastStatus = "${InquiryStatus.PartialCompleted}";
      } else {
        mastStatus = "${InquiryStatus.PartialCompleted}";
      }
      return mastStatus;
    }

    String MasterStatus = determineMasterStatus(statusList);
    return MasterStatus;
  }

  static Future<void> updateInquiryTableStatus(int inquiryId) async {
    try {
      Database db = await DBHelper.initDB();
      String statusList = await getStatusList(inquiryId);
      await db.update(
        TABLE_INQUIRY,
        {'Status': statusList},
        where: 'InquiryId = ?',
        whereArgs: [inquiryId],
      );
      print(statusList);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on UpdateDataResponse method line#1550-dbhelper which is use to update status in inquiry Table: ${e.toString()}");
    }
  }

  static Future<void> saveindex(int Inquiryid, int? newIndex) async {
    try {
      Database db = await DBHelper.initDB();
      var pin = await db.update(TABLE_INQUIRY, {'orignalIndex': newIndex},
          where: 'InquiryId = ? ', whereArgs: [Inquiryid]);
      print(pin);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on saveindex method line#1594-Dbhelper which is use to save index in db: ${e.toString()}");
      throw e;
    }
  }

  static Future<void> AddedToTop(int Inquiryid, String added) async {
    try {
      Database db = await DBHelper.initDB();
      var pin = await db.update(TABLE_INQUIRY, {'addedtotop': added},
          where: 'InquiryId = ? ', whereArgs: [Inquiryid]);
      print(pin);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on AddedtoTop method line#1607-Dbhelper which is use to save added to top value : ${e.toString()}");
      throw e;
    }
  }

  static Future<void> saveLongPress(int long, int idd) async {
    try {
      Database db = await DBHelper.initDB();
      var pin = await db.update(TABLE_INQUIRY, {'isLongPressed': long},
          where: 'InquiryId = ? ', whereArgs: [idd]);
      print(pin);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on savelongPress method line#1620-Dbhelper which is use to save longpress value: ${e.toString()}");
      throw e;
    }
  }

// *******************************************************
//          METHODS FOR LOCKING NAVIGATION
// *******************************************************

  static Future<List<ResidenceDetail>> GetResidenceDetails(int resid) async {
    List<ResidenceDetail> residenceDetailList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_RESIDENCE_DETAILS != null) {
        List<Map<String, dynamic>> resDetailRows = await db.query(
            TABLE_RESIDENCE_DETAILS,
            where: 'ResidenceVerificationId = ?',
            whereArgs: [resid]);
        if (resDetailRows.isNotEmpty) {
          for (var row in resDetailRows) {
            resid = row['ResidenceVerificationId'];
            List<Map<String, dynamic>> resDetail = await db.query(
                TABLE_RESIDENCE_DETAILS,
                where: 'ResidenceVerificationId = ?',
                whereArgs: [resid]);
            List<ResidenceDetail> details = resDetail
                .map((residentDetails) =>
                    ResidenceDetail.fromJson(residentDetails))
                .toList();
            residenceDetailList.addAll(details);
          }
        } else {
          residenceDetailList = [];
        }
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on GetResidenceDetails method line#1637-dbhelper which is use in Residence Main Page (for allow/disallow Navigation): ${e.toString()}");

      throw e;
    }
    return residenceDetailList;
  }

  static Future<List<ResidenceProfile>> GetResidenceProfile(int resid) async {
    List<ResidenceProfile> residenceProfileList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_RESIDENCE_PROFILE != null) {
        List<Map<String, dynamic>> resRows = await db.query(
            TABLE_RESIDENCE_PROFILE,
            where: 'ResidenceVerificationId = ?',
            whereArgs: [resid]);
        if (resRows.isNotEmpty) {
          for (var row in resRows) {
            resid = row['ResidenceVerificationId'];

            List<Map<String, dynamic>> resProfile = await db.query(
                TABLE_RESIDENCE_PROFILE,
                where: 'ResidenceVerificationId = ?',
                whereArgs: [resid]);
            List<ResidenceProfile> Profile = resProfile
                .map((residentProfile) =>
                    ResidenceProfile.fromJson(residentProfile))
                .toList();
            residenceProfileList.addAll(Profile);
          }
        } else {
          residenceProfileList = [];
        }
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on GetResidenceProfile method line#1672-Dbhelper which is use in Residence Main Page (for allow/disallow Navigation): ${e.toString()}");
      throw e;
    }
    return residenceProfileList;
  }

  static Future<List<NeighbourCheck>> GetResidenceNeighbor(int resid) async {
    List<NeighbourCheck> residenceNeighborList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_RESIDENCE_NEIGHBOUR != null) {
        List<Map<String, dynamic>> resRows = await db.query(
            TABLE_RESIDENCE_NEIGHBOUR,
            where: 'ResidenceVerificationId = ?',
            whereArgs: [resid]);
        if (resRows.isNotEmpty) {
          for (var row in resRows) {
            resid = row['ResidenceVerificationId'];

            List<Map<String, dynamic>> resNeighbor = await db.query(
                TABLE_RESIDENCE_NEIGHBOUR,
                where: 'ResidenceVerificationId = ?',
                whereArgs: [resid]);
            List<NeighbourCheck> Neighbor = resNeighbor
                .map((residentNeighbor) =>
                    NeighbourCheck.fromJson(residentNeighbor))
                .toList();
            residenceNeighborList.addAll(Neighbor);
          }
        } else {
          residenceNeighborList = [];
        }
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on GetResidenceNeighbor method line#1707-Dbhelper which is use in Residence Main Page (for allow/disallow Navigation): ${e.toString()}");
      throw e;
    }
    return residenceNeighborList;
  }

  static Future<List<OfficeAddressDetail>> GetOfficeAddress(int offID) async {
    List<OfficeAddressDetail> OfficeAddressList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_OFFICE_ADDRESSDETAILS != null) {
        List<Map<String, dynamic>> OfficeRows = await db.query(
            TABLE_OFFICE_ADDRESSDETAILS,
            where: 'WorkOfficeVerificationId = ?',
            whereArgs: [offID]);
        if (OfficeRows.isNotEmpty) {
          for (var row in OfficeRows) {
            offID = row['WorkOfficeVerificationId'];

            List<Map<String, dynamic>> offAddress = await db.query(
                TABLE_OFFICE_ADDRESSDETAILS,
                where: 'WorkOfficeVerificationId = ?',
                whereArgs: [offID]);
            List<OfficeAddressDetail> Address = offAddress
                .map((OfficeAddress) =>
                    OfficeAddressDetail.fromJson(OfficeAddress))
                .toList();
            OfficeAddressList.addAll(Address);
          }
        } else {
          OfficeAddressList = [];
        }
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on GetOfficeAddress method line#1742-Dbhelper which is use in Office Main Page (for allow/disallow Navigation): ${e.toString()}");
      throw e;
    }
    return OfficeAddressList;
  }

  static Future<List<BusinessWorkOfficeDetail>> GetworkOfficeDetails(
      int offID) async {
    List<BusinessWorkOfficeDetail> OfficeDetailList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_OFFICE_BussWrkDETAILS != null) {
        List<Map<String, dynamic>> OfficeRows = await db.query(
            TABLE_OFFICE_BussWrkDETAILS,
            where: 'WorkOfficeVerificationId = ?',
            whereArgs: [offID]);
        if (OfficeRows.isNotEmpty) {
          for (var row in OfficeRows) {
            offID = row['WorkOfficeVerificationId'];

            List<Map<String, dynamic>> offDetail = await db.query(
                TABLE_OFFICE_BussWrkDETAILS,
                where: 'WorkOfficeVerificationId = ?',
                whereArgs: [offID]);
            List<BusinessWorkOfficeDetail> Details = offDetail
                .map((OfficeDetails) =>
                    BusinessWorkOfficeDetail.fromJson(OfficeDetails))
                .toList();
            OfficeDetailList.addAll(Details);
          }
        } else {
          OfficeDetailList = [];
        }
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on GetWorkofficeDetails method line#1777-Dbhelper which is use in Office Main Page (for allow/disallow Navigation): ${e.toString()}");
      throw e;
    }
    return OfficeDetailList;
  }

  static Future<List<OfficeHRDetail>> GetOffieHRchk(int offID) async {
    List<OfficeHRDetail> OfficeHRList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_OFFICE_HR_DETAILS != null) {
        List<Map<String, dynamic>> OfficeRows = await db.query(
            TABLE_OFFICE_HR_DETAILS,
            where: 'WorkOfficeVerificationId = ?',
            whereArgs: [offID]);
        if (OfficeRows.isNotEmpty) {
          for (var row in OfficeRows) {
            offID = row['WorkOfficeVerificationId'];

            List<Map<String, dynamic>> offHR = await db.query(
                TABLE_OFFICE_HR_DETAILS,
                where: 'WorkOfficeVerificationId = ?',
                whereArgs: [offID]);
            List<OfficeHRDetail> HR = offHR
                .map((OfficeHR) => OfficeHRDetail.fromJson(OfficeHR))
                .toList();
            OfficeHRList.addAll(HR);
          }
        } else {
          OfficeHRList = [];
        }
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on GetOfficeHRchk method line#1813-Dbhelper which is use in Office Main Page (for allow/disallow Navigation): ${e.toString()}");
      throw e;
    }
    return OfficeHRList;
  }

  static Future<List<MarketeCheck>> GetofficeMarketchk(int offID) async {
    List<MarketeCheck> OfficeMarketList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_OFFICE_NghbrCHECK != null) {
        if (TABLE_OFFICE_NghbrCHECK != null) {
          List<Map<String, dynamic>> OfficeRows = await db.query(
              TABLE_OFFICE_NghbrCHECK,
              where: 'WorkOfficeVerificationId = ?',
              whereArgs: [offID]);
          if (OfficeRows.isNotEmpty) {
            for (var row in OfficeRows) {
              final offID = row['WorkOfficeVerificationId'];

              List<Map<String, dynamic>> offMarket = await db.query(
                  TABLE_OFFICE_NghbrCHECK,
                  where: 'WorkOfficeVerificationId = ?',
                  whereArgs: [offID]);
              List<MarketeCheck> Market = offMarket
                  .map(
                      (OfficeNeighbor) => MarketeCheck.fromJson(OfficeNeighbor))
                  .toList();
              OfficeMarketList.addAll(Market);
            }
          }
        } else {
          OfficeMarketList = [];
        }
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on GetOfficeMarketchk method line#1847-Dbhelper which is use in Office Main Page (for allow/disallow Navigation): ${e.toString()}");
      throw e;
    }
    return OfficeMarketList;
  }

  static Future<List<Data>> Datares(int resID) async {
    List<Data> DetailList = [];
    try {
      Database db = await DBHelper.initDB();
      if (TABLE_INQUIRY != null) {
        List<Map<String, dynamic>> resDetailRows = await db
            .query(TABLE_INQUIRY, where: 'InquiryId = ?', whereArgs: [resID]);
        for (var row in resDetailRows) {
          resID = row['InquiryId'];
          List<Map<String, dynamic>> Detail = await db
              .query(TABLE_INQUIRY, where: 'InquiryId = ?', whereArgs: [resID]);
          List<Data> details =
              Detail.map((residentDetails) => Data.fromJson(residentDetails))
                  .toList();
          DetailList.addAll(details);
        }
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on Datares method line#1884-Dbhelper which is use in Inquiries screen for checking the orignalindex & longpress : ${e.toString()}");

      throw e;
    }
    return DetailList;
  }

  static Future<List<Data>> FilterResponse() async {
    List<Data> DataList = [];

    try {
      Database db = await DBHelper.initDB();
      List<Map<String, dynamic>> dataRows = await db.query(TABLE_INQUIRY);
      for (var datarow in dataRows) {
        final dataID = datarow['InquiryId'];
        List<Map<String, dynamic>> tenantRows = await db.query(
            TABLE_TENANT_VERIFICATION,
            orderBy: 'PersonName',
            where: 'InquiryId=?',
            whereArgs: [dataID]);
        List<Map<String, dynamic>> officeRows = await db.query(
            TABLE_OFFICEVERIFICATION,
            orderBy: 'PersonName',
            where: 'InquiryId=?',
            whereArgs: [dataID]);
        List<Map<String, dynamic>> ResidenceRows = await db.query(
            TABLE_RESIDENCEVERIFICATION,
            orderBy: 'PersonName',
            where: 'InquiryId=?',
            whereArgs: [dataID]);
        List<Map<String, dynamic>> BankRows = await db.query(
            TABLE_BANKSTATEMENT_VERIFICATION,
            orderBy: 'PersonName',
            where: 'InquiryId=?',
            whereArgs: [dataID]);
        List<Map<String, dynamic>> Sliprows = await db.query(
            TABLE_SALARYSLIP_VERIFICATION,
            orderBy: 'PersonName',
            where: 'InquiryId=?',
            whereArgs: [dataID]);
        List<TenantVerifications> tenants = tenantRows
            .map((tenent) => TenantVerifications.fromJson(tenent))
            .toList();
        List<WorkOfficeVerifications> office = officeRows
            .map((officedata) => WorkOfficeVerifications.fromJson(officedata))
            .toList();
        List<ResidenceVerifications> Residence = ResidenceRows.map(
            (residenceData) =>
                ResidenceVerifications.fromJson(residenceData)).toList();
        List<BankStatementVerifications> Bank = BankRows.map(
                (bankData) => BankStatementVerifications.fromJson(bankData))
            .toList();
        List<SalarySlipVerifications> Slip = Sliprows.map(
            (SlipData) => SalarySlipVerifications.fromJson(SlipData)).toList();

        DataList.add(Data(
            CompanyName: datarow['CompanyName'],
            ProductName: datarow['ProductName'],
            AppContact: datarow['AppContact'],
            InquiryId: datarow['InquiryId'],
            CompanyId: datarow['CompanyId'],
            BranchId: datarow['BranchId'],
            CustomerBranchId: datarow['CustomerBranchId'],
            ProductId: datarow['ProductId'],
            BranchName: datarow['BranchName'],
            CustomerBranchName: datarow['CustomerBranchName'],
            AppNo: datarow['AppNo'],
            AppName: datarow['AppName'],
            AppCNIC: datarow['AppCNIC'],
            Status: datarow['Status'],
            orignalIndex: datarow['orignalIndex'],
            addedtotop: datarow['addedtotop'],
            tenantVerifications: tenants,
            salarySlipVerifications: Slip,
            workOfficeVerifications: office,
            bankStatementVerifications: Bank,
            residenceVerifications: Residence));
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on FilterResponse method line#1910-Dbhelper which is use to show exact data from db(neglect of Added to top Option): ${e.toString()}");
      throw e;
    }

    return Future.value(DataList);
  }

  // *******************************************************
//          METHODS FOR DELETE TABLE DATA
// *******************************************************
  static Future<void> DeleteInquiryTable(int Inquiryid) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_INQUIRY;
    try {
      await db.delete(table, where: 'InquiryId = ?', whereArgs: [Inquiryid]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting Inquiry Table");
    }
  }

  static Future<void> DeleteInquiryPhotosTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_INQUIRYPHOTOS;
    try {
      await db.delete(table, where: 'VerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting InquiryPhotos Table");
    }
  }

  static Future<void> DeleteStatusTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_STATUS;
    try {
      await db.delete(table, where: 'VerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting InquiryStatus Table");
    }
  }

  static Future<void> DeletemainResidenceTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_RESIDENCEVERIFICATION;
    try {
      await db.delete(table,
          where: 'ResidenceVerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting Residence main Table");
    }
  }

  static Future<void> DeleteResidenceDetailsTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_RESIDENCE_DETAILS;
    try {
      await db.delete(table,
          where: 'ResidenceVerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting ResidenceDetails Table");
    }
  }

  static Future<void> DeleteResidenceProfileTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_RESIDENCE_PROFILE;
    try {
      await db.delete(table,
          where: 'ResidenceVerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting ResidenceProfile Table");
    }
  }

  static Future<void> DeleteResidenceNeighborTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_RESIDENCE_NEIGHBOUR;
    try {
      await db.delete(table,
          where: 'ResidenceVerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "${e.toString()} on Deleting ResidenceNeighbor Table");
    }
  }

  static Future<void> DeletemainOfficeTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_OFFICEVERIFICATION;
    try {
      await db.delete(table,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting OFFICE main Table");
    }
  }

  static Future<void> DeleteOfficeAddressTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_OFFICE_ADDRESSDETAILS;
    try {
      await db.delete(table,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting OFFICE Address Table");
    }
  }

  static Future<void> DeleteOfficewrkBussinessTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_OFFICE_BussWrkDETAILS;
    try {
      await db.delete(table,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "${e.toString()} \n on Deleting OFFICE WorkOffice Table");
    }
  }

  static Future<void> DeleteOfficeHRTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_OFFICE_HR_DETAILS;
    try {
      await db.delete(table,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting OFFICE Address Table");
    }
  }

  static Future<void> DeleteOfficeNeighborTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_OFFICE_NghbrCHECK;
    try {
      await db.delete(table,
          where: 'WorkOfficeVerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting OFFICE Neighbor Table");
    }
  }

  static Future<void> DeleteSalaryTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_SALARYSLIP_VERIFICATION;
    try {
      await db.delete(table,
          where: 'SalarySlipVerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting SALARY Table");
    }
  }

  static Future<void> DeleteBankTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_BANKSTATEMENT_VERIFICATION;
    try {
      await db.delete(table,
          where: 'BankStatementVerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting BANKSTATEMENT Table");
    }
  }

  static Future<void> DeleteTenantTable(int verID) async {
    Database db = await DBHelper.initDB();
    var table = TABLE_TENANT_VERIFICATION;
    try {
      await db
          .delete(table, where: 'TenantVerificationId = ?', whereArgs: [verID]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting BANKSTATEMENT Table");
    }
  }

  static Future<void> DeleteUserDb() async {
    Database db = await DBHelper.initDB();
    var table = TABLE_USER;
    try {
      await db.delete(table, where: 'Id = ?', whereArgs: [id]);
    } on Exception catch (e) {
      EVSLogger.appendLog("${e.toString()} on Deleting User Table");
    }
  }

  static Future<void> printTable() async {
    Database db = await DBHelper.initDB();
    List<Map<String, dynamic>> tableData = await db.query(
      TABLE_STATUS,
    );
    for (var rows in tableData) {
      if (tableData == null) {
        print("Null");
      } else {
        print(rows);
      }
    }
  }

  static Future<bool> getInquirybyID(int InqID) async {
    Database db = await DBHelper.initDB();
    List<Map<String, dynamic>> maps = await db.query(
      TABLE_INQUIRY,
      where: 'InquiryId = ?',
      whereArgs: [InqID],
    );
    if (maps.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Delete the Complete Database from Application
  static Future<void> DeleteDB() async {
    var dbpath = await getDatabasesPath();
    String path = join(dbpath + DBname);
    await databaseFactory.deleteDatabase(path);
    await deleteDatabase(path);
  }

  static Future<List<WorkOfficeVerifications>> AssignOfficeData(int id) async {
    List<WorkOfficeVerifications> office = [];
    Database db = await DBHelper.initDB();
    List<Map<String, dynamic>> workRow = await db.query(
        TABLE_OFFICEVERIFICATION,
        where: 'InquiryId = ?',
        whereArgs: [id]);
    for (var off in workRow) {
      office.add(WorkOfficeVerifications(
          InquiryId: off['InquiryId'],
          WorkOfficeVerificationId: off['WorkOfficeVerificationId'],
          PersonName: off['PersonName'],
          PersonType: off['PersonType'],
          PersonContactNo: off['PersonContactNo'],
          PersonDesignation: off['PersonDesignation'],
          OfficeName: off['OfficeName'],
          OfficeAddress: off['OfficeAddress'],
          NearestLandMark: off['NearestLandMark'],
          Status: off['Status']));
    }
    return office;
  }

  static Future<List<SalarySlipVerifications>> AssignSalaryData(int id) async {
    List<SalarySlipVerifications> salary = [];
    Database db = await DBHelper.initDB();
    List<Map<String, dynamic>> SalaryRow = await db.query(
        TABLE_SALARYSLIP_VERIFICATION,
        where: 'InquiryId = ?',
        whereArgs: [id]);
    for (var sal in SalaryRow) {
      salary.add(SalarySlipVerifications(
          InquiryId: sal['InquiryId'],
          SalarySlipVerificationId: sal['SalarySlipVerificationId'],
          PersonName: sal['PersonName'],
          PersonType: sal['PersonType'],
          PersonContactNo: sal['PersonContactNo'],
          OfficeName: sal['OfficeName'],
          OfficeAddress: sal['OfficeAddress'],
          NearestLandMark: sal['NearestLandMark'],
          Status: sal['Status']));
    }
    return salary;
  }

  static Future<List<TenantVerifications>> AssignTenantData(int id) async {
    List<TenantVerifications> tenant = [];
    Database db = await DBHelper.initDB();
    List<Map<String, dynamic>> TenantRow = await db.query(
        TABLE_TENANT_VERIFICATION,
        where: 'InquiryId = ?',
        whereArgs: [id]);
    for (var ten in TenantRow) {
      tenant.add(TenantVerifications(
          InquiryId: ten['InquiryId'],
          TenantVerificationId: ten['TenantVerificationId'],
          PersonName: ten['PersonName'],
          PersonType: ten['PersonType'],
          TenantAddress: ten['TenantAddress'],
          PersonContactNo: ten['PersonContactNo'],
          NearestLandMark: ten['NearestLandMark'],
          Status: ten['Status']));
    }
    return tenant;
  }

  static Future<List<ResidenceVerifications>> AssignResidenceData(
      int id) async {
    List<ResidenceVerifications> residence = [];
    Database db = await DBHelper.initDB();
    List<Map<String, dynamic>> ResidenceRow = await db.query(
        TABLE_RESIDENCEVERIFICATION,
        where: 'InquiryId = ?',
        whereArgs: [id]);
    for (var res in ResidenceRow) {
      residence.add(ResidenceVerifications(
          InquiryId: res['InquiryId'],
          ResidenceVerificationId: res['ResidenceVerificationId'],
          ResidenceAddress: res['ResidenceAddress'],
          PersonName: res['PersonName'],
          PersonType: res['PersonType'],
          PersonContactNo: res['PersonContactNo'],
          NearestLandMark: res['NearestLandMark'],
          Status: res['Status']));
    }
    return residence;
  }

  static Future<List<BankStatementVerifications>> AssignBankData(int id) async {
    List<BankStatementVerifications> bank = [];
    Database db = await DBHelper.initDB();
    List<Map<String, dynamic>> BankRow = await db.query(
        TABLE_BANKSTATEMENT_VERIFICATION,
        where: 'InquiryId = ?',
        whereArgs: [id]);
    for (var r in BankRow) {
      bank.add(BankStatementVerifications(
          InquiryId: r['InquiryId'],
          BankStatementVerificationId: r['BankStatementVerificationId'],
          BankName: r['BankName'],
          BankAddress: r['BankAddress'],
          PersonName: r['PersonName'],
          PersonType: r['PersonType'],
          PersonContactNo: r['PersonContactNo'],
          NearestLandMark: r['NearestLandMark'],
          Status: r['Status']));
    }
    return bank;
  }

  static Future<User> ReadUserResponse() async {
    User newUser = User();
    try {
      Database db = await DBHelper.initDB();
      var userresponse = await db.query(TABLE_USER, orderBy: 'userName');
      if (userresponse != null) {
        newUser = User.fromJson(userresponse.first);
      } else {
        newUser = User(
            firstName: '',
            lastName: '',
            passwordHash: '',
            code: '',
            branchId: 0,
            id: '',
            userName: '');
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on ReadResponse method line#396-dbhelper: ${e.toString()}");
    }
    return Future.value(newUser);
  }

  static Future<List<PostImages>> getImages(int InqID) async {
    List<PostImages> newImages = [];
    Database db = await DBHelper.initDB();
    List<Map<String, dynamic>> photos = await db
        .query(TABLE_INQUIRYPHOTOS, where: 'InquiryId = ?', whereArgs: [InqID]);
    for (var pic in photos) {
      newImages.add(PostImages(
        PersonType: pic['PersonType'],
        InquiryId: pic['InquiryId'],
        VerificationId: pic['VerificationId'],
        VerificationType: pic['VerificationType'],
        appPhoto: pic['appPhoto'],
      ));
    }
    return newImages;
  }
}
