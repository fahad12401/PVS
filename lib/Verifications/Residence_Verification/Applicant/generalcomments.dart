import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pvs/Widgets/Card_Widgets/Residence_customcard.dart';
import '../../../Database/Database_Helper.dart';
import '../../../Screens/assigned_inq_screen.dart';
import '../../../Widgets/Dialogbox.dart';
import '../../../Widgets/Gps_Widgets/GPS.dart';
import '../../../Widgets/Gps_Widgets/gps_loc.dart';
import '../../../Widgets/Inquiry_status.dart';
import '../../../Widgets/Logs/Logeger.dart';

class ResidenceGeneralComment extends StatefulWidget {
  final String Persontype;
  final String PersonName;
  final String Landmark;
  final String PersonAddress;
  final int resVerid;
  final int inqid;

  ResidenceGeneralComment(
      {super.key,
      required this.Persontype,
      required this.PersonName,
      required this.Landmark,
      required this.PersonAddress,
      required this.resVerid,
      required this.inqid});

  @override
  State<ResidenceGeneralComment> createState() =>
      _ResidenceGeneralCommentState();
}

class _ResidenceGeneralCommentState extends State<ResidenceGeneralComment> {
  GlobalKey<FormState> _CommentformKey = GlobalKey<FormState>();
  TextEditingController commentcontroller = TextEditingController();
  String selectedoption = "";

  @override
  void dispose() {
    commentcontroller;
    super.dispose();
  }

  saveResidenceComments() async {
    try {
      final DateTime now = DateTime.now();
      String dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      await DBHelper.updateResidenceComments(
          widget.resVerid,
          commentcontroller.text.toString(),
          selectedoption.toString(),
          [Residencelatitude.toString(), Residencelongtitude.toString()],
          InquiryStatus.Completed,
          dateFormat);
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on saveResidenceComments ResidenceGeneralComment: ${e.toString()} ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didpop) async {
        if (didpop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Color(0xff392850),
          title: Text(
            "General Comments & Outcome of Verification (${widget.Persontype})",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Calibri',
                fontSize: 20.0),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
          },
          child: SingleChildScrollView(
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Residence_CustomCard(
                      TypeofPerson: widget.Persontype,
                      Name: widget.PersonName,
                      Address: widget.PersonAddress,
                      Landmark: widget.Landmark),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
                    child: Form(
                      key: _CommentformKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text("Comments:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  fontFamily: 'Calibri')),
                          TextFormField(
                            controller: commentcontroller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white54,
                                hintText: "Enter Comments Here.",
                                hintStyle: TextStyle(fontFamily: 'Calibri'),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff392850), width: 2.0))),
                            validator: (val) {
                              if (val == null ||
                                  val.isEmpty ||
                                  val.trim().isEmpty) {
                                return "Kindly fill the Field";
                              }
                              return null;
                            },
                            maxLines: 5,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text("Outcome of Verification:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  fontFamily: 'Calibri')),
                          RadioListTile<String>(
                              activeColor: Color(0xff392850),
                              value: "Satisfactory",
                              title: Text(
                                "Satisfactory",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Calibri',
                                    fontSize: 18.0),
                              ),
                              groupValue: selectedoption,
                              onChanged: (value) {
                                setState(() {
                                  selectedoption = value!;
                                });
                              }),
                          const SizedBox(height: 1.0),
                          RadioListTile(
                              activeColor: Color(0xff392850),
                              value: "Unsatisfactory",
                              title: Text(
                                "Unsatisfactory",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Calibri',
                                    fontSize: 18.0),
                              ),
                              groupValue: selectedoption,
                              onChanged: (value) {
                                setState(() {
                                  selectedoption = value!;
                                });
                              }),
                          const Divider(),
                          const SizedBox(
                            height: 5.0,
                          ),
                          GPSLocation(),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: 120.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                backgroundColor: Color(0xff392850)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Back",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Calibri',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      Container(
                        height: 40.0,
                        width: 120.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                backgroundColor: Color(0xff392850)),
                            onPressed: () {
                              try {
                                Residencelongtitude = long;
                                Residencelatitude = lat;
                                if (_CommentformKey.currentState!.validate() &&
                                    selectedoption.isNotEmpty &&
                                    Residencelatitude!.isNotEmpty &&
                                    Residencelongtitude!.isNotEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext contextt) {
                                        return finalDialog(
                                            contextt,
                                            "All Fields are Completed!",
                                            "Do you want to save it?",
                                            "Save", () async {
                                          saveResidenceComments();
                                          await DBHelper
                                              .updateResidenceCommentStatus(
                                                  widget.inqid);
                                          await DBHelper
                                              .updateInquiryTableStatus(
                                                  widget.inqid);

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AssignedInquiries(
                                                        InquiryID: widget.inqid,
                                                      )));
                                          MyDialog.show(
                                              context, "Successfully Saved!");
                                          Future.delayed(Duration(seconds: 2),
                                              () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          });
                                        });
                                      });
                                } else {
                                  MyDialog.show(
                                      context, 'Kindly fill all fields');
                                  Future.delayed(Duration(seconds: 1), () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  });
                                }
                              } on Exception catch (e) {
                                EVSLogger.appendLog(
                                    "Exception on ResidenceGeneralComment: ${e.toString()}");
                              }
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Calibri',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
