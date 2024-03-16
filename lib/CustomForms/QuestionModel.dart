import 'package:flutter/widgets.dart';

class CustomQuestion {
  String question = "";
  String AnsType = "";
  bool filled = false;
  TextEditingController ctr = TextEditingController();

  CustomQuestion(
      {required this.AnsType,
      required this.question,
      required this.filled,
      required this.ctr});
}
