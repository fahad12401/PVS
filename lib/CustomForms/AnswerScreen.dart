import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pvs/CustomForms/QuestionModel.dart';
import 'package:pvs/Screens/Home_Screen.dart';

class AnswerScreen extends StatefulWidget {
  final List<CustomQuestion> QuestionList;
  AnswerScreen({super.key, required this.QuestionList});

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  List<TextEditingController> AnsController = [];
  List<String> Chklist = [];
  List<String> answerTypes = ['Yes', 'No'];

  @override
  void initState() {
    AnsController = List.generate(
        widget.QuestionList.length, (index) => TextEditingController());

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff392850),
        centerTitle: true,
        title: Text(
          "Custom Answers",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(17.0),
              child: Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.QuestionList.length,
                    itemBuilder: (context, index) {
                      AnsController.add(widget.QuestionList[index].ctr);
                      String ques = widget.QuestionList[index].question;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 9.0,
                          ),
                          Text(
                            "Question : ${ques}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                          SizedBox(
                            height: 9.0,
                          ),
                          if (widget.QuestionList[index].AnsType == 'text')
                            TextFormField(
                              controller: AnsController[index],
                              decoration: InputDecoration(
                                  hintText: "Answer",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 3.0),
                                      borderRadius:
                                          BorderRadius.circular(30.0))),
                            )
                          else if (widget.QuestionList[index].AnsType ==
                              'checklist')
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30.0),
                                  ),
                                ),
                                filled: true,
                              ),
                              items: answerTypes.map<DropdownMenuItem<String>>(
                                  (String person) {
                                return DropdownMenuItem<String>(
                                    value: person, child: Text(person));
                              }).toList(),
                              hint: Text("Select the Answer"),
                              onChanged: (String? newValue) {
                                setState(() {
                                  Chklist.add(newValue!);
                                });
                              },
                            )
                        ],
                      );
                    }),
              ),
            ),
            Center(
              child: CupertinoButton(
                  color: Color(0xff392850),
                  child: Text(
                    "Submit Form",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                  onPressed: () {
                    for (int i = 0; i < AnsController.length; i++) {
                      if (AnsController[i].text.isEmpty ||
                          AnsController[i].text.trim().isEmpty ||
                          Chklist.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Kindly Fill All Answers"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ));
                        break;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Answer Submitted"),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ));
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      }
                    }
                  }),
            )
          ],
        ),
      )),
    );
  }
}
