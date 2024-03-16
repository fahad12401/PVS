import '../Module For Post Data/Post_inquires_model..dart';

Verification verificationobj = Verification();
List<Data>? dataa;
List<Data> includeData = [];
List<ResidenceVerifications> residenceverifys = [];
List<WorkOfficeVerifications> workOfficeVerify = [];
List<BankStatementVerifications> bankStatementVerify = [];
List<SalarySlipVerifications> salarySlipVerify = [];
List<TenantVerifications> tenantVerify = [];

class Verification {
  final String? message;

  final int? Status;

  final List<Data>? data;

  final List<dynamic>? salarySlipIds;

  final List<dynamic>? residenceIds;

  final List<dynamic>? workOfficeIds;

  final List<dynamic>? bankStatementIds;

  final List<dynamic>? tenantIds;

  Verification({
    this.message,
    this.Status,
    this.data,
    this.salarySlipIds,
    this.residenceIds,
    this.workOfficeIds,
    this.bankStatementIds,
    this.tenantIds,
  });

  Verification.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String?,
        Status = json['Status'] as int?,
        data = (json['data'] as List?)
            ?.map((dynamic e) => Data.fromJson(e as Map<String, dynamic>))
            .toList(),
        salarySlipIds = json['salarySlipIds'] as List?,
        residenceIds = json['residenceIds'] as List?,
        workOfficeIds = json['workOfficeIds'] as List?,
        bankStatementIds = json['bankStatementIds'] as List?,
        tenantIds = json['tenantIds'] as List?;
}

class Data {
  final int? InquiryId;
  final dynamic CompanyId;
  final String? CompanyName;
  final dynamic BranchId;
  final String? BranchName;
  final dynamic CustomerBranchId;
  final String? CustomerBranchName;
  final dynamic ProductId;
  final String? ProductName;
  final dynamic AppNo;
  final String? AppName;
  final String? AppContact;
  final String? AppCNIC;
  final String? Status;
  final List<ResidenceVerifications>? residenceVerifications;
  final List<WorkOfficeVerifications>? workOfficeVerifications;
  final List<TenantVerifications>? tenantVerifications;
  final List<SalarySlipVerifications>? salarySlipVerifications;
  final List<BankStatementVerifications>? bankStatementVerifications;

  int? islongPressed;
  String? addedtotop;
  int? orignalIndex;

  Data(
      {this.InquiryId,
      this.Status,
      this.CompanyId,
      this.CompanyName,
      this.BranchId,
      this.BranchName,
      this.CustomerBranchId,
      this.CustomerBranchName,
      this.ProductId,
      this.ProductName,
      this.AppNo,
      this.AppName,
      this.AppContact,
      this.AppCNIC,
      this.residenceVerifications,
      this.workOfficeVerifications,
      this.tenantVerifications,
      this.salarySlipVerifications,
      this.bankStatementVerifications,
      this.orignalIndex,
      this.islongPressed = 0,
      this.addedtotop});

  Data.fromJson(Map<String, dynamic> json)
      : InquiryId = json['InquiryId'],
        CompanyId = json['CompanyId'],
        addedtotop = json['addedtotop'],
        islongPressed = json['islongPressed'],
        CompanyName = json['CompanyName'] as String?,
        BranchId = json['BranchId'],
        BranchName = json['BranchName'] as String?,
        CustomerBranchId = json['CustomerBranchId'],
        CustomerBranchName = json['CustomerBranchName'] as String?,
        ProductId = json['ProductId'],
        ProductName = json['ProductName'] as String?,
        AppNo = json['AppNo'],
        AppName = json['AppName'] as String?,
        AppContact = json['AppContact'] as String?,
        AppCNIC = json['AppCNIC'] as String?,
        orignalIndex = json['orignalIndex'],
        Status = json['Status'],
        residenceVerifications = (json['ResidenceVerifications'] as List?)
            ?.map((dynamic e) =>
                ResidenceVerifications.fromJson(e as Map<String, dynamic>))
            .toList(),
        workOfficeVerifications = (json['WorkOfficeVerifications'] as List?)
            ?.map((dynamic e) =>
                WorkOfficeVerifications.fromJson(e as Map<String, dynamic>))
            .toList(),
        tenantVerifications = (json['TenantVerifications'] as List?)
            ?.map((dynamic e) =>
                TenantVerifications.fromJson(e as Map<String, dynamic>))
            .toList(),
        salarySlipVerifications = (json['SalarySlipVerifications'] as List?)
            ?.map((dynamic e) =>
                SalarySlipVerifications.fromJson(e as Map<String, dynamic>))
            .toList(),
        bankStatementVerifications = (json['BankStatementVerifications']
                as List?)
            ?.map((dynamic e) =>
                BankStatementVerifications.fromJson(e as Map<String, dynamic>))
            .toList();
}

class ResidenceVerifications {
  int? ResidenceVerificationId;
  int? InquiryId;
  String? PersonType;
  String? PersonName;
  String? PersonCNIC;
  String? PersonContactNo;
  String? ResidenceAddress;
  String? NearestLandMark;
  dynamic GeneralComments;
  dynamic OutComeVerification;
  dynamic GpsLocation;
  dynamic GpsURL;
  String? Status;
  String? StatusDate;
  dynamic Price;
  dynamic VerifiedBy;
  dynamic Inquiry;
  ResidenceDetail? residentDetails;
  ResidenceProfile? residenceProfile;
  NeighbourCheck? resNeighborCheck;
  String? QcComments;
  dynamic InquiryApplicationUser;
  dynamic Images;
  List<dynamic>? Statuses;

  ResidenceVerifications({
    this.ResidenceVerificationId,
    this.InquiryId,
    this.PersonType,
    this.PersonName,
    this.PersonCNIC,
    this.PersonContactNo,
    this.ResidenceAddress,
    this.NearestLandMark,
    this.GeneralComments,
    this.OutComeVerification,
    this.GpsLocation,
    this.GpsURL,
    this.Status,
    this.StatusDate,
    this.Price,
    this.QcComments,
    this.VerifiedBy,
    this.Inquiry,
    this.residentDetails,
    this.residenceProfile,
    this.resNeighborCheck,
    this.InquiryApplicationUser,
    this.Images,
    this.Statuses,
  });

  ResidenceVerifications.fromJson(
    Map<String, dynamic> json,
  )   : ResidenceVerificationId = json['ResidenceVerificationId'] as int?,
        InquiryId = json['InquiryId'] as int?,
        PersonType = json['PersonType'] as String?,
        PersonName = json['PersonName'] as String?,
        PersonCNIC = json['PersonCNIC'] as String?,
        PersonContactNo = json['PersonContactNo'] as String?,
        ResidenceAddress = json['ResidenceAddress'] as String?,
        NearestLandMark = json['NearestLandMark'] as String?,
        GeneralComments = json['GeneralComments'],
        OutComeVerification = json['OutComeVerification'],
        GpsLocation = json['GpsLocation'],
        GpsURL = json['GpsURL'],
        Status = json['Status'] as String?,
        StatusDate = json['StatusDate'] as String?,
        Price = json['Price'],
        QcComments = json['QcComments'],
        VerifiedBy = json['VerifiedBy'],
        Inquiry = json['Inquiry'],
        residentDetails = json['residentDetails'],
        residenceProfile = json['residenceProfile'],
        resNeighborCheck = json['resNeighborCheck'],
        InquiryApplicationUser = json['InquiryApplicationUser'],
        Images = json['Images'],
        Statuses = json['Statuses'] as List?;
}

class WorkOfficeVerifications {
  int? WorkOfficeVerificationId;
  int? InquiryId;
  String? PersonType;
  String? PersonName;
  String? PersonContactNo;
  String? PersonDesignation;
  String? OfficeName;
  String? OfficeAddress;
  String? NearestLandMark;
  dynamic GeneralComments;
  dynamic OutComeVerification;
  dynamic GpsLocation;
  dynamic GpsURL;
  String? Status;
  String? StatusDate;
  dynamic QcComments;
  dynamic Price;
  dynamic VerifiedBy;
  dynamic Inquiry;
  OfficeAddressDetail? officeAddressDetail;
  BusinessWorkOfficeDetail? workOfficeDetails;
  MarketeCheck? OfficeMarketCheck;
  OfficeHRDetail? HRDetail;
  dynamic InquiryApplicationUser;
  dynamic Address;
  dynamic Images;
  List<dynamic>? Statuses;

  WorkOfficeVerifications({
    this.WorkOfficeVerificationId,
    this.InquiryId,
    this.PersonType,
    this.PersonName,
    this.PersonContactNo,
    this.PersonDesignation,
    this.OfficeName,
    this.OfficeAddress,
    this.NearestLandMark,
    this.GeneralComments,
    this.OutComeVerification,
    this.GpsLocation,
    this.GpsURL,
    this.Status,
    this.StatusDate,
    this.QcComments,
    this.Price,
    this.VerifiedBy,
    this.Inquiry,
    this.officeAddressDetail,
    this.workOfficeDetails,
    this.OfficeMarketCheck,
    this.HRDetail,
    this.InquiryApplicationUser,
    this.Address,
    this.Images,
    this.Statuses,
  });

  WorkOfficeVerifications.fromJson(Map<String, dynamic> json)
      : WorkOfficeVerificationId = json['WorkOfficeVerificationId'] as int?,
        InquiryId = json['InquiryId'] as int?,
        PersonType = json['PersonType'] as String?,
        PersonName = json['PersonName'] as String?,
        PersonContactNo = json['PersonContactNo'] as String?,
        PersonDesignation = json['PersonDesignation'] as String?,
        OfficeName = json['OfficeName'] as String?,
        OfficeAddress = json['OfficeAddress'] as String?,
        NearestLandMark = json['NearestLandMark'] as String?,
        GeneralComments = json['GeneralComments'],
        OutComeVerification = json['OutComeVerification'],
        GpsLocation = json['GpsLocation'],
        GpsURL = json['GpsURL'],
        Status = json['Status'],
        StatusDate = json['StatusDate'] as String?,
        QcComments = json['QcComments'],
        Price = json['Price'],
        VerifiedBy = json['VerifiedBy'],
        Inquiry = json['Inquiry'],
        officeAddressDetail = json['OfficeAddressDetail'],
        workOfficeDetails = json['BusinessWorkOfficeDetail'],
        OfficeMarketCheck = json['MarketeCheck'],
        HRDetail = json['OfficeHRDetail'],
        InquiryApplicationUser = json['InquiryApplicationUser'],
        Address = json['Address'],
        Images = json['Images'],
        Statuses = json['Statuses'] as List?;
}

class BankStatementVerifications {
  int? BankStatementVerificationId;
  int? InquiryId;
  String? PersonType;
  String? PersonName;
  String? PersonContactNo;
  String? BankName;
  String? BankAddress;
  String? NearestLandMark;
  dynamic GeneralComments;
  String? OutComeVerification;
  dynamic GpsLocation;
  dynamic GpsURL;
  String? Status;
  String? StatusDate;
  dynamic Price;
  dynamic QcComments;
  dynamic VerifiedBy;
  dynamic Inquiry;
  dynamic InquiryApplicationUser;
  dynamic Images;
  List<dynamic>? Statuses;
  BankStatementVerifications({
    this.BankStatementVerificationId,
    this.InquiryId,
    this.PersonType,
    this.PersonName,
    this.PersonContactNo,
    this.BankName,
    this.BankAddress,
    this.NearestLandMark,
    this.GeneralComments,
    this.OutComeVerification,
    this.GpsLocation,
    this.GpsURL,
    this.Status,
    this.StatusDate,
    this.Price,
    this.QcComments,
    this.VerifiedBy,
    this.Inquiry,
    this.InquiryApplicationUser,
    this.Images,
    this.Statuses,
  });

  BankStatementVerifications.fromJson(Map<String, dynamic> json)
      : BankStatementVerificationId =
            json['BankStatementVerificationId'] as int?,
        InquiryId = json['InquiryId'] as int?,
        PersonType = json['PersonType'] as String?,
        PersonName = json['PersonName'] as String?,
        PersonContactNo = json['PersonContactNo'] as String?,
        BankName = json['BankName'] as String?,
        BankAddress = json['BankAddress'] as String?,
        NearestLandMark = json['NearestLandMark'] as String?,
        GeneralComments = json['GeneralComments'],
        OutComeVerification = json['OutComeVerification'] as String?,
        GpsLocation = json['GpsLocation'],
        GpsURL = json['GpsURL'],
        Status = json['Status'] as String?,
        StatusDate = json['StatusDate'] as String?,
        Price = json['Price'],
        QcComments = json['QcComments'],
        VerifiedBy = json['VerifiedBy'],
        Inquiry = json['Inquiry'],
        InquiryApplicationUser = json['InquiryApplicationUser'],
        Images = json['Images'],
        Statuses = json['Statuses'] as List?;
}

class TenantVerifications {
  int? TenantVerificationId;
  int? InquiryId;
  String? PersonType;
  String? PersonName;
  String? PersonContactNo;
  String? TenantAddress;
  String? NearestLandMark;
  String? TenantName;
  String? TenantContactNo;
  String? TenantCNIC;
  String? TenancyPeriod;
  int? TenantRent;
  String? Status;
  String? StatusDate;
  String? GeneralComments;
  String? OutComeVerification;
  String? GpsLocation;
  String? GpsURL;
  String? Price;
  String? QcComments;
  String? VerifiedBy;
  dynamic Inquiry;
  String? InquiryApplicationUser;
  String? Images;
  List<dynamic>? Statuses;
  TenantVerifications(
      {this.TenantVerificationId,
      this.InquiryId,
      this.PersonType,
      this.PersonName,
      this.PersonContactNo,
      this.TenantAddress,
      this.NearestLandMark,
      this.TenantName,
      this.TenantContactNo,
      this.TenantCNIC,
      this.TenancyPeriod,
      this.TenantRent,
      this.Status,
      this.StatusDate,
      this.GeneralComments,
      this.OutComeVerification,
      this.GpsLocation,
      this.GpsURL,
      this.Images,
      this.Inquiry,
      this.InquiryApplicationUser,
      this.Statuses,
      this.VerifiedBy,
      this.Price,
      this.QcComments});

  TenantVerifications.fromJson(Map<String, dynamic> json)
      : TenantVerificationId = json['TenantVerificationId'] as int?,
        InquiryId = json['InquiryId'] as int?,
        PersonType = json['PersonType'] as String?,
        PersonName = json['PersonName'] as String?,
        PersonContactNo = json['PersonContactNo'],
        TenantAddress = json['TenantAddress'] as String?,
        NearestLandMark = json['NearestLandMark'] as String?,
        TenantName = json['TenantName'] as String?,
        TenantContactNo = json['TenantContactNo'],
        TenantCNIC = json['TenantCNIC'],
        TenancyPeriod = json['TenancyPeriod'],
        TenantRent = json['TenantRent'] as int?,
        Status = json['Status'] as String?,
        StatusDate = json['StatusDate'] as String?,
        GeneralComments = json['GeneralComments'],
        OutComeVerification = json['OutComeVerification'],
        GpsLocation = json['GpsLocation'],
        GpsURL = json['GpsURL'],
        Price = json['Price'],
        QcComments = json['QcComments'] as String?,
        VerifiedBy = json['VerifiedBy'] as String?,
        Inquiry = json['Inquiry'],
        InquiryApplicationUser = json['InquiryApplicationUser'],
        Images = json['Images'] as String?,
        Statuses = json['Statuses'];
}

class SalarySlipVerifications {
  int? SalarySlipVerificationId;
  int? InquiryId;
  String? PersonType;
  String? PersonName;
  String? PersonContactNo;
  String? OfficeName;
  String? OfficeAddress;
  String? NearestLandMark;
  String? PaySlipPath;
  String? GeneralComments;
  String? OutComeVerification;
  String? GpsLocation;
  String? GpsURL;
  String? Status;
  String? StatusDate;
  String? QcComments;
  dynamic Price;
  String? VerifiedBy;
  String? Inquiry;
  String? InquiryApplicationUser;
  String? Images;
  List<dynamic>? Statuses;
  SalarySlipVerifications(
      {this.SalarySlipVerificationId,
      this.InquiryId,
      this.PersonType,
      this.PersonName,
      this.PersonContactNo,
      this.OfficeName,
      this.OfficeAddress,
      this.NearestLandMark,
      this.PaySlipPath,
      this.GeneralComments,
      this.OutComeVerification,
      this.GpsLocation,
      this.GpsURL,
      this.Status,
      this.StatusDate,
      this.Inquiry,
      this.InquiryApplicationUser,
      this.Price,
      this.QcComments,
      this.Statuses,
      this.VerifiedBy,
      this.Images});

  SalarySlipVerifications.fromJson(Map<String, dynamic> json)
      : SalarySlipVerificationId = json['SalarySlipVerificationId'] as int?,
        InquiryId = json['InquiryId'] as int?,
        PersonType = json['PersonType'] as String?,
        PersonName = json['PersonName'] as String?,
        PersonContactNo = json['PersonContactNo'] as String?,
        OfficeName = json['OfficeName'] as String?,
        OfficeAddress = json['OfficeAddress'] as String?,
        NearestLandMark = json['NearestLandMark'] as String?,
        PaySlipPath = json['PaySlipPath'] as String?,
        GeneralComments = json['GeneralComments'] as String?,
        OutComeVerification = json['OutComeVerification'],
        GpsLocation = json['GpsLocation'],
        GpsURL = json['GpsURL'],
        Status = json['Status'] as String?,
        StatusDate = json['StatusDate'] as String?,
        QcComments = json['QcComments'],
        Price = json['Price'] as int?,
        VerifiedBy = json['VerifiedBy'],
        Inquiry = json['Inquiry'],
        InquiryApplicationUser = json['InquiryApplicationUser'],
        Images = json['Images'],
        Statuses = json['Statuses'];
}
