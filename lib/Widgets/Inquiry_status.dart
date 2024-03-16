import 'package:intl/intl.dart';

class InquiryStatus {
  static const String Completed = "Completed";
  static const String InProgress = "In Progress";
  static const String New = "New";
  static const String PartialCompleted = "Partial Completed";

  static const String SyncCompleted = "Complete Sync";
  static const String SyncInProgress = "Ready to Sync";
  static const String SyncNotReady = "Not Ready to Sync";

  static const String SyncPartialCompleted = "Partial Sync";

  static String getStatusDate() {
    return DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.now());
  }

  static String getDateTime() {
    return DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now());
    // return DateFormat("yyyyMMddhh:mm:ss").format(DateTime.now());
  }

  static void displayMenuStatus(String msg) {
    // Display the message
    print(msg);
  }
}

String BankStatus = '';
