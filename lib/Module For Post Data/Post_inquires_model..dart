import '../Widgets/Inquiry_status.dart';

ResidenceDetail residencedetail = new ResidenceDetail();
ResidenceProfile residenceProfile = new ResidenceProfile();

OfficeAddressDetail officeAddressDetail = new OfficeAddressDetail();
BusinessWorkOfficeDetail businessWorkOfficeDetail =
    new BusinessWorkOfficeDetail();
OfficeHRDetail officeHRDetail = new OfficeHRDetail();
MarketeCheck marketeCheck = new MarketeCheck();
List<PostImages> RecieveImages = [];

class ResidenceDetail {
  int? ResidenceVerificationId;
  int? InquiryId;
  String? PersonType;
  String? Status;
  String? IsApplicantAvailable; //Did you meet the applicant
  String? NameOfPersonToMet; //if applicant not available.
  String?
      RelationWithApplicant; //RelatioinWithApplicant if applicant not available.
  String? WasActualAddressSame; //Was actual address same as above?
  String? CorrectAddress; //Give correct addres if address not same ..
  String? PhoneNo;
  String? LivesAtGivenAddress; //does applicant lives at the given address
  String?
      PermanentAddress; //Permanent address if not lives at the given address
  String?
      SinceHowintLiving; //Since how int applicant is living on the same address
  String? CNICNo; //applicant cnic no.

  ResidenceDetail(
      {this.ResidenceVerificationId,
      this.IsApplicantAvailable,
      this.NameOfPersonToMet,
      this.RelationWithApplicant,
      this.WasActualAddressSame,
      this.CorrectAddress,
      this.PhoneNo,
      this.LivesAtGivenAddress,
      this.PermanentAddress,
      this.SinceHowintLiving,
      this.CNICNo,
      this.InquiryId,
      this.PersonType,
      this.Status});
  ResidenceDetail.fromJson(Map<String, dynamic> json)
      : ResidenceVerificationId = json['ResidenceVerificationId'],
        IsApplicantAvailable = json['IsApplicantAvailable'],
        NameOfPersonToMet = json['NameOfPersonToMet'],
        WasActualAddressSame = json['WasActualAddressSame'],
        CorrectAddress = json['CorrectAddress'],
        PhoneNo = json['PhoneNo'],
        LivesAtGivenAddress = json['LivesAtGivenAddress'],
        PermanentAddress = json['PermanentAddress'],
        RelationWithApplicant = json['RelationWithApplicant'],
        SinceHowintLiving = json['SinceHowintLiving'],
        CNICNo = json['CNICNo'],
        Status = json['Status'],
        InquiryId = json['InquiryId'],
        PersonType = json['PersonType'];
}

class ResidenceProfile {
  int? ResidenceVerificationId;
  int? InquiryId;
  String? TypeOfResidence; //House - Portion - Apartment
  String? ApplicantIsA; //Owner - Tenant - Other
  double? MentionOther;
  String? MentionRent; // if Tenant mention rent
  String? SizeApproxArea;
  String? UtilizationOfResidence; // Residential - Commercial
  String? RentDeedVerified; //If application means if Tenant
  String? Neighborhood; // neighborhood fields
  String? AreaAccessibility;
  String? ResidentsBelongsTo;
  String? RepossessionInTheArea;
  String? Status;

  ResidenceProfile(
      {this.ResidenceVerificationId,
      this.InquiryId,
      this.TypeOfResidence,
      this.ApplicantIsA,
      this.MentionOther,
      this.MentionRent,
      this.SizeApproxArea,
      this.UtilizationOfResidence,
      this.RentDeedVerified,
      this.Neighborhood,
      this.AreaAccessibility,
      this.ResidentsBelongsTo,
      this.RepossessionInTheArea,
      this.Status});
  ResidenceProfile.fromJson(Map<String, dynamic> json)
      : ResidenceVerificationId = json['ResidenceVerificationId'],
        InquiryId = json['InquiryId'],
        TypeOfResidence = json['TypeOfResidence'],
        ApplicantIsA = json['ApplicantIsA'],
        MentionOther = json['MentionOther'] as double,
        MentionRent = json['MentionRent'],
        SizeApproxArea = json['SizeApproxArea'],
        UtilizationOfResidence = json['UtilizationOfResidence'],
        RentDeedVerified = json['RentDeedVerified'],
        Neighborhood = json['Neighborhood'],
        AreaAccessibility = json['AreaAccessibility'],
        ResidentsBelongsTo = json['ResidentsBelongsTo'],
        Status = json['Status'],
        RepossessionInTheArea = json['RepossessionInTheArea'];
}

class NeighbourCheck {
  int? ResidenceVerificationId;
  int? InquiryId;
  String? NeighborName;
  String? NeighborAddress;
  String? KnowsApplicant; //Does Neighbor know the applicant
  String? KnowsHowLong; // if neighbor knows the applicant then how int.
  String? NeighborComments; // Comments Regarding the applicant
  String? NeighborsName2;
  String? NeighborsAddress2;
  String? KnowsApplicant2;
  String? KnowsHowLong2;
  String? NeighborComments2;
  String? Status;
  String? Status2;

  NeighbourCheck(
      {this.ResidenceVerificationId,
      this.NeighborName,
      this.NeighborAddress,
      this.KnowsApplicant,
      this.KnowsHowLong,
      this.NeighborComments,
      this.InquiryId,
      this.Status,
      this.KnowsApplicant2,
      this.KnowsHowLong2,
      this.NeighborComments2,
      this.NeighborsAddress2,
      this.NeighborsName2,
      this.Status2});
  NeighbourCheck.fromJson(Map<String, dynamic> json)
      : ResidenceVerificationId = json['ResidenceVerificationId'],
        InquiryId = json['InquiryId'],
        NeighborName = json['NeighborName'],
        NeighborAddress = json['NeighborAddress'],
        KnowsApplicant = json['KnowsApplicant'],
        KnowsHowLong = json['KnowsHowLong'],
        Status = json['Status'],
        NeighborComments = json['NeighborComments'],
        KnowsApplicant2 = json['KnowsApplicant2'],
        KnowsHowLong2 = json['KnowsHowLong2'],
        NeighborComments2 = json['NeighborComments2'],
        NeighborsAddress2 = json['NeighborsAddress2'],
        Status2 = json['Status2'],
        NeighborsName2 = json['NeighborsName2'];
}

class OfficeAddressDetail {
  int? InquiryId;
  int? WorkOfficeVerificationId;
  String? WasActualAddressSame; //Was actual address same as above mention.?
  String? CorrectAddress; //Give correct addres if address not same ..
  String?
      EstablishedTime; //Length of time the business / office has been established
  String? WorkAtGivenAddress; //does applicant work at the given address
  String? GiveNewAddress;
  String? IsApplicantAvailable; //Did you meet the applicant
  String? MetPersonName;
  String?
      GiveReason; //if applicant not available give the reason y not u meet the applicant.
  String? CNICOS; // Applicant's NIC # (O/s Physically if possible)
  String? CNICNo;
  String? MetPersonCNIC;
  String? Status;

  OfficeAddressDetail({
    this.InquiryId,
    this.WorkOfficeVerificationId,
    this.WasActualAddressSame,
    this.CorrectAddress,
    this.EstablishedTime,
    this.WorkAtGivenAddress,
    this.GiveNewAddress,
    this.IsApplicantAvailable,
    this.MetPersonName,
    this.GiveReason,
    this.CNICOS,
    this.CNICNo,
    this.MetPersonCNIC,
    this.Status,
  });
  OfficeAddressDetail.fromJson(Map<String, dynamic> json)
      : WorkOfficeVerificationId = json['WorkOfficeVerificationId'],
        InquiryId = json['InquiryId'],
        WasActualAddressSame = json['WasActualAddressSame'],
        CorrectAddress = json['CorrectAddress'],
        EstablishedTime = json['EstablishedTime'],
        WorkAtGivenAddress = json['WorkAtGivenAddress'],
        GiveNewAddress = json['GiveNewAddress'],
        IsApplicantAvailable = json['IsApplicantAvailable'],
        MetPersonName = json['MetPersonName'],
        GiveReason = json['GiveReason'],
        CNICOS = json['CNICOS'],
        CNICNo = json['CNICNo'],
        Status = json['Status'],
        MetPersonCNIC = json['MetPersonCNIC'];
}

class BusinessWorkOfficeDetail {
  int?
      WorkOfficeVerificationId; //Business Work Office Verification For (SEB/SEP)
  String? TypeOfBusiness; // Shop - Office - Restaurant Factory - other
  String? OtherTypeOfBusiness;
  String? ApplicantIsA;
  String? MentionOther;
  String? MentionRent;
  int? InquiryId;
  String?
      NatureOfBusiness; // Manufacturing - Services - Trading - Govt Emp. - other
  String? OtherNatureOfBusiness;
  String?
      BusinessLegalEntity; // Proprietor - Partnership - Pvt. Ltd. - Public Lt. - Govt
  String? GovtEmpBusinessLegalEntity;
  String?
      NamePlateAffixed; //Was Business Name plate affixed at business place same as in application.
  String? SizeApproxArea;
  String? BusinessActivity; // Low - Medium - High
  int? NoOfEmployees; //Number of employees work in
  String? BusinessEstablesSince;
  String? LineOfBusiness; //bool bankStatmentVerified;
  String? Status;
  BusinessWorkOfficeDetail(
      {this.InquiryId,
      this.WorkOfficeVerificationId,
      this.TypeOfBusiness,
      this.OtherTypeOfBusiness,
      this.ApplicantIsA,
      this.MentionOther,
      this.MentionRent,
      this.NatureOfBusiness,
      this.OtherNatureOfBusiness,
      this.BusinessLegalEntity,
      this.GovtEmpBusinessLegalEntity,
      this.NamePlateAffixed,
      this.SizeApproxArea,
      this.BusinessActivity,
      this.NoOfEmployees,
      this.BusinessEstablesSince,
      this.LineOfBusiness,
      this.Status});
  BusinessWorkOfficeDetail.fromJson(Map<String, dynamic> json)
      : WorkOfficeVerificationId = json['WorkOfficeVerificationId'],
        InquiryId = json['InquiryId'],
        TypeOfBusiness = json['TypeOfBusiness'],
        OtherTypeOfBusiness = json['OtherTypeOfBusiness'],
        ApplicantIsA = json['ApplicantIsA'],
        MentionOther = json['MentionOther'],
        MentionRent = json['MentionRent'],
        NatureOfBusiness = json['NatureOfBusiness'],
        OtherNatureOfBusiness = json['OtherNatureOfBusiness'],
        BusinessLegalEntity = json['BusinessLegalEntity'],
        GovtEmpBusinessLegalEntity = json['GovtEmpBusinessLegalEntity'],
        NamePlateAffixed = json['NamePlateAffixed'],
        SizeApproxArea = json['SizeApproxArea'],
        BusinessActivity = json['BusinessActivity'],
        NoOfEmployees = json['NoOfEmployees'],
        BusinessEstablesSince = json['BusinessEstablesSince'],
        Status = json['Status'],
        LineOfBusiness = json['LineOfBusiness'];
}

class MarketeCheck {
  int? WorkOfficeVerificationId; // Neighbor / Markete Check
  int? InquiryId;
  String? NeighborsName;
  String? NeighborsAddress;
  String? KnowsApplicant; // Does Neighbor know the applicant
  String? KnowsHowint; // if neighbor knows the applicant then how int.
  String? NeighborComments; // Comments Regarding the applicant
  String? BusinessEstablishedSinceMarketeCheck;
  String? NeighborsTwoName;
  String? NeighborsTwoAddress;
  String? NeighborsTwoKnowsApplicant;
  String? NeighborsTwoKnowsHowLong;
  String? NeighborsTwoNeighborComments;
  String? NeighborsTwoBusinessEstablishedSinceMarketeCheck;
  String? Status2;
  String? Status;

  MarketeCheck(
      {this.WorkOfficeVerificationId,
      this.InquiryId,
      this.NeighborsName,
      this.NeighborsAddress,
      this.KnowsApplicant,
      this.KnowsHowint,
      this.NeighborComments,
      this.BusinessEstablishedSinceMarketeCheck,
      this.NeighborsTwoAddress,
      this.NeighborsTwoBusinessEstablishedSinceMarketeCheck,
      this.NeighborsTwoKnowsApplicant,
      this.NeighborsTwoKnowsHowLong,
      this.NeighborsTwoName,
      this.NeighborsTwoNeighborComments,
      this.Status,
      this.Status2});
  MarketeCheck.fromJson(Map<String, dynamic> json)
      : WorkOfficeVerificationId = json['WorkOfficeVerificationId'],
        InquiryId = json['InquiryId'],
        NeighborsName = json['NeighborsName'],
        NeighborsAddress = json['NeighborsAddress'],
        KnowsApplicant = json['KnowsApplicant'],
        KnowsHowint = json['KnowsHowint'],
        NeighborComments = json['KnowsHowint'],
        Status = json['Status'],
        Status2 = json['Status2'],
        BusinessEstablishedSinceMarketeCheck =
            json['BusinessEstablishedSinceMarketeCheck'],
        NeighborsTwoBusinessEstablishedSinceMarketeCheck =
            json['NeighborsTwoBusinessEstablishedSinceMarketeCheck'],
        NeighborsTwoName = json['NeighborsTwoName'],
        NeighborsTwoAddress = json['NeighborsTwoAddress'],
        NeighborsTwoKnowsApplicant = json['NeighborsTwoKnowsApplicant'],
        NeighborsTwoNeighborComments = json['NeighborsTwoNeighborComments'],
        NeighborsTwoKnowsHowLong = json['NeighborsTwoKnowsHowLong'];
}

//Office /Hr Verifcation For (Salary Salaried Individual);
class OfficeHRDetail {
  int? WorkOfficeVerificationId;
  int? InquiryId;
  String? NameOfPersonToMeet;
  String? OHrKnowsApplicant;
  String? ApplicantEmployementStatus;
  String? ApplicantEmployementPeriod;
  String? ApplicantDesignation;
  String? OHrNatureOfBusiness;
  String? OHrOtherNatureOfBusiness; // this field was missing
  double? GrossSalary;
  double? NetTakeHomeSalary;
  String? SalarySlipVerified; // late bool oHrBankStatmentVerified;
  String? Status = InquiryStatus.InProgress;

  OfficeHRDetail({
    this.WorkOfficeVerificationId,
    this.InquiryId,
    this.NameOfPersonToMeet,
    this.OHrKnowsApplicant,
    this.ApplicantEmployementStatus,
    this.ApplicantEmployementPeriod,
    this.ApplicantDesignation,
    this.OHrNatureOfBusiness,
    this.OHrOtherNatureOfBusiness,
    this.GrossSalary,
    this.NetTakeHomeSalary,
    this.SalarySlipVerified,
    this.Status,
  });

  OfficeHRDetail.fromJson(Map<String, dynamic> json)
      : WorkOfficeVerificationId = json['WorkOfficeVerificationId'],
        InquiryId = json['InquiryId'],
        NameOfPersonToMeet = json['NameOfPersonToMeet'],
        OHrKnowsApplicant = json['OHrKnowsApplicant'],
        ApplicantEmployementStatus = json['ApplicantEmployementStatus'],
        ApplicantEmployementPeriod = json['ApplicantEmployementPeriod'],
        ApplicantDesignation = json['ApplicantDesignation'],
        OHrNatureOfBusiness = json['OHrNatureOfBusiness'],
        OHrOtherNatureOfBusiness = json['OHrOtherNatureOfBusiness'],
        GrossSalary = json['GrossSalary'],
        Status = json['Status'],
        NetTakeHomeSalary = json['NetTakeHomeSalary'],
        SalarySlipVerified = json['SalarySlipVerified'];
}

class PostImages {
  int? VerificationId;
  int? InquiryId;
  String? VerificationType;
  String? PersonType;
  String? appPhoto;

  PostImages(
      {this.appPhoto,
      this.InquiryId,
      this.PersonType,
      this.VerificationId,
      this.VerificationType});

  PostImages.fromJson(Map<String, dynamic> json)
      : VerificationId = json['VerificationId'],
        PersonType = json['PersonType'],
        VerificationType = json['VerificationType'],
        InquiryId = json['InquiryId'],
        appPhoto = json['appPhoto'];
}
