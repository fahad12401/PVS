class InquiryTypes {
  // Product Types
  static const String CarAjara = "CARAJARA";
  static const String ConsumerVerification = "CONSUMER";
  static const String EasyHome = "EASYHOME";

  // Verification Types
  static const String ResidenceVerification = "Residence";
  static const String OfficeVerification = "WorkOffice";
  static const String TenantVerification = "TenantVerification";
  static const String BankStatementVerification = "BankStatement";
  static const String SalarySlipSlipVerification = "SalarySlip";
  // Office Sub Verificationtypes
  static const String OfficeAddress = "OfficeAddress";
  static const String WorkOffice = "WorkOffice";
  static const String OfficeMarket = "OfficeMarket";
  static const String OfficeHR = "OfficeHR";
  // Residence Sub Verificationtypes
  static const String ResidenceProfile = "ResidenceProfile";
  static const String ResidenceAddress = "ResidenceAddress";
  static const String ResidenceNeighbor = "ResidenceNeighbor";

  // Person Types
  static const String Applicant = "Applicant";
  static const String Guarantor1 = "Guarantor 1";
  static const String Guarantor2 = "Guarantor 2";

  static const String Spouse1 = "Spouse 1";
  static const String Spouse2 = "Spouse 2";

  static const String Tenant = "Tenant";
  static const String ReferenceOne = "Reference 1";
  static const String ReferenceTwo = "Reference 2";
  static const String ReferenceThree = "Reference 3";
}

int getBooleanasInt(bool value) {
  return value ? 1 : 0;
}
