SyncInquiryModel newSync = SyncInquiryModel();
var inquiryID;

class SyncInquiryModel {
  final int? status;
  final String? message;
  final String? messageType;
  final List<dynamic>? residenceIds;
  final List<dynamic>? bankStatementIds;
  final List<dynamic>? tenantIds;
  final List<dynamic>? workOfficeIds;
  final List<dynamic>? salarySlipIds;
  SyncInquiryModel(
      {this.status,
      this.message,
      this.messageType,
      this.residenceIds,
      this.bankStatementIds,
      this.salarySlipIds,
      this.tenantIds,
      this.workOfficeIds});
  SyncInquiryModel.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String?,
        status = json['status'] as int?,
        messageType = json['messageType'] as String?,
        residenceIds = json['residenceIds'] as List?,
        bankStatementIds = json['bankStatementIds'] as List?,
        tenantIds = json['tenantIds'] as List?,
        workOfficeIds = json['workOfficeIds'] as List?,
        salarySlipIds = json['salarySlipIds'] as List?;
}
