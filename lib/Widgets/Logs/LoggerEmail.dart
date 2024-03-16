import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pvs/Widgets/Logs/Gmailsender.dart';
import 'package:pvs/Widgets/Logs/Logeger.dart';
import '../Gridview.dart';

class EVSLoggerEmail {
  BuildContext context;
  EVSLoggerEmail(
    this.context,
  );

  Future<void> showEmailDialog() async {
    String logs = await readLogFile();

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('EVS Logs',
            style: TextStyle(
              fontFamily: 'Calibri',
            )),
        content: SingleChildScrollView(
            child: Text(
          "${logs.toString()}",
          style: TextStyle(fontFamily: 'Calibri'),
        )),
        actions: [
          TextButton(
            child: Text(
              'EMAIL LOGS',
              style: TextStyle(fontFamily: 'Calibri'),
            ),
            onPressed: () async {
              await sendEmail(await logs.toString());
            },
          ),
        ],
      ),
    );
  }

  Future<void> sendEmail(String body) async {
    String appVersion = await getAppVersion();
    try {
      GMailSender sender =
          GMailSender('fk2039391@gmail.com', 'yzth ykel xgkk nejd', context);
      sender.sendMail(
          "EVS LOG from AppVersion:" +
              appVersion +
              "  Username=" +
              GetUsername() +
              "   UserID=" +
              GetUserID() +
              "   TABLET",
          body,
          'fk2039391@gmail.com',
          'fk6300244@gmail.com');
    } on IOException catch (e) {
      EVSLogger.appendLog(
          "EVSLogger- IOException  SentEmail():  " + e.toString() + "");
    } on OutOfMemoryError catch (e) {
      EVSLogger.appendLog(
          "EVSLogger- RuntimeException  SentEmail():  " + e.toString() + "");
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "EVSLogger- Exception SentEmail():  " + e.toString() + "");

      throw e;
    }
  }

  Future<String> readLogFile() async {
    Directory? directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/logs.txt');
    String contents = '';

    try {
      if (await file.exists()) {
        contents = await file.readAsString();
      } else {
        EVSLogger.appendLog("The Log file doesn't Exist");
      }
    } catch (e) {
      EVSLogger.appendLog(
          'EVSLogger- Exception readLogFile(): ${e.toString()}');
    }
    return contents.toString();
  }
}

String GetUsername() {
  String username = UserName.toString();
  return username;
}

String GetUserID() {
  String userid = id.toString();
  return userid;
}

Future<String> getAppVersion() async {
  String result = '';
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (packageInfo.version != null && packageInfo.version.isNotEmpty) {
      result = packageInfo.version;
    }
  } catch (e) {
    print(e.toString());
  }
  return result.toString();
}

void showSnck(BuildContext context, text, Color clr) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 5),
      backgroundColor: clr,
      content: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontFamily: 'Calibri', fontSize: 22.0),
      )));
}
