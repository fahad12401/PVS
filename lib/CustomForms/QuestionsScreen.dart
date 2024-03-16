import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pvs/CustomForms/AnswerScreen.dart';
import 'package:pvs/CustomForms/QuestionModel.dart';
import '../Module for Get Data/Inquires_response.dart';

List<Data> PersonData = [];

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<CustomQuestion> cusques = [];
  TextEditingController controller = TextEditingController();
  List<String> answerTypes = ['text', 'checklist'];

  bool added = false;
  String selectedAnsType = '';
  String PersonName = '';
  String productName = "";
  String CompanyName = "";
  String cnic = "";
  String contactNo = "";
  int count = 1;

  updateFelds() {
    Data? selectedData = PersonData.firstWhere(
      (person) => person.AppName == PersonName,
      orElse: () => Data(),
    );
    setState(() {
      productName = selectedData.ProductName.toString();
      CompanyName = selectedData.CompanyName.toString();
      cnic = selectedData.AppCNIC.toString();
      contactNo = selectedData.AppContact.toString();
    });
    print(productName);
  }

  addQuestion() {
    if (controller.text.isNotEmpty &&
        selectedAnsType.isNotEmpty &&
        controller.text.trim().isNotEmpty) {
      added = true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Kindly Fill the Question"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
    }

    if (added == true) {
      setState(() {
        count++;
        cusques.add(CustomQuestion(
            AnsType: selectedAnsType,
            question: controller.text,
            filled: true,
            ctr: controller));
        controller.clear();
        selectedAnsType = '';
      });
    } else {
      print("Added");
    }
    setState(() {
      added = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff392850),
        centerTitle: true,
        title: Text(
          "Custom Questions",
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30.0),
                    ),
                  ),
                  filled: true,
                ),
                items: PersonData.map<DropdownMenuItem<String>>((Data person) {
                  return DropdownMenuItem<String>(
                      value: person.AppName,
                      child: Text(person.AppName ?? " "));
                }).toList(),
                hint: Text("Select Person Name"),
                onChanged: (String? newValue) {
                  setState(() {
                    PersonName = newValue!;
                    updateFelds();
                  });
                },
              ),
              const SizedBox(
                height: 9.0,
              ),
              Container(
                padding: EdgeInsets.all(13.0),
                width: double.infinity,
                height: 200,
                child: Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Text(
                              "Company Name: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Calibri',
                                  fontSize: 20.0),
                            ),
                            Text(
                              "${CompanyName}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Calibri',
                                  fontSize: 20.0),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Product Name: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Calibri',
                                  fontSize: 20.0),
                            ),
                            Text(
                              "${productName}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Calibri',
                                  fontSize: 20.0),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "CNIC: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Calibri',
                                  fontSize: 20.0),
                            ),
                            Text(
                              "${cnic}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Calibri',
                                  fontSize: 20.0),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Contact No: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Calibri',
                                  fontSize: 20.0),
                            ),
                            Text(
                              "${contactNo}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Calibri',
                                  fontSize: 20.0),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                    hintText: "Add Question",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 3.0),
                        borderRadius: BorderRadius.circular(30.0))),
              ),
              SizedBox(
                height: 6.0,
              ),
              DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 3.0),
                          borderRadius: BorderRadius.circular(30.0))),
                  items:
                      answerTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                        value: value, child: Text(value.toString()));
                  }).toList(),
                  onChanged: (String? val) {
                    selectedAnsType = val!;
                  }),
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton(
                      child: Text(
                        "Remove Question List",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        setState(() {
                          cusques.clear();
                        });
                      }),
                  CupertinoButton(
                      child: Text("Add Question"),
                      onPressed: () {
                        addQuestion();
                      }),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                width: double.infinity,
                child: Card(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cusques.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Question : " + cusques[index].question,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Answer Type : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  Text(
                                    "${cusques[index].AnsType}",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                            ],
                          );
                        })),
              )
            ],
          ),
        ),
      )),
      floatingActionButton: SizedBox(
        height: 50.0,
        width: 150.0,
        child: FloatingActionButton(
          backgroundColor: Color(0xff392850),
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onPressed: () {
            if (PersonName == '' || cusques.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Kindly Fill All Requirements"),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ));
            } else {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          AnswerScreen(QuestionList: cusques)));
            }
          },
          child: Text(
            "Generate Form",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
