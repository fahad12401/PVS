import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pvs/Widgets/Logs/LoggerEmail.dart';
import '../Animated_Widgets/animated_popup.dart';
import 'Logeger.dart';

bool? mounted;

class GMailSender {
  final String username;
  final String password;
  final String mailhost = "smtp.gmail.com";
  final _smtpServer;
  BuildContext context;
  GMailSender(
    this.username,
    this.password,
    this.context,
  ) : _smtpServer = gmail(username, password);

  Future<void> sendMail(
      String subject, String body, String sender, String recipients) async {
    final message = Message()
      ..from = Address(sender, 'Fahad')
      ..recipients.addAll(recipients.split(','))
      ..subject = subject
      ..text = body;

    try {
      await send(message, _smtpServer);
      mounted = true;
      EVSLogger.appendLog("Email is Send");
      if (mounted == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Animatedcheck(
                    Dialogname: "Send Email Successfully!",
                    color: Colors.green,
                    icon: Icons.check)));
      } else {
        print("Error while sending Email");
      }
      // showSnck(context, "Email send successfully!", Colors.green);
    } on MailerException catch (e) {
      EVSLogger.appendLog("MailerException While sending mail ${e.toString()}");
      showSnck(context, "MailerException While sending mail ${e.toString()}",
          Colors.red);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } on SocketException catch (e) {
      print("Messge not sent. \n" + e.toString());
      EVSLogger.appendLog("SocketException while Sending mail ${e.toString()}");
      showSnck(context, "SocketException While sending mail ${e.toString()}",
          Colors.red);
      throw e;
    } on Exception catch (e) {
      EVSLogger.appendLog("Exception while sending mail ${e}");
      showSnck(
          context, "Exception While sending mail ${e.toString()}", Colors.red);
      throw e;
    }
    var connection = PersistentConnection(_smtpServer);
    await connection.send(message);
    await connection.close();
  }
}
