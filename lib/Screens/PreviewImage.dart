import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Database/Database_Helper.dart';
import '../Module For Post Data/Post_inquires_model..dart';
import '../Widgets/Dialogbox.dart';
import '../Widgets/InquiryTypes.dart';
import '../Widgets/Inquiry_status.dart';
import '../Widgets/Logs/Logeger.dart';
import 'assigned_inq_screen.dart';

// ignore: must_be_immutable
class PreviewImage extends StatefulWidget {
  PreviewImage(
      {super.key,
      this.Persntype,
      this.inquiryid,
      this.Vtype,
      required this.capimages,
      this.verifyID,
      this.subVertype});
  List<File>? capimages = [];
  String? Persntype;
  int? inquiryid;
  String? Vtype;
  int? verifyID;
  String? subVertype;

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  List<PostImages> postImages = [];

  List<File> fileImage = [];

  convertbase64() {
    if (widget.capimages!.isNotEmpty) {
      fileImage.addAll(widget.capimages!);
      for (int i = 0; i < fileImage.length; i++) {
        final bytes = fileImage[i].readAsBytesSync();
        String base64 = base64Encode(bytes);
        postImages.add(PostImages(
            appPhoto: base64,
            InquiryId: widget.inquiryid,
            PersonType: widget.Persntype,
            VerificationId: widget.verifyID,
            VerificationType: widget.Vtype));
      }
    }
  }

  Future<void> newImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 480,
          maxWidth: 640);
      if (image == null) {
        MyDialog.show(context, 'Kindly Take Photo');
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      } else {
        setState(() {
          widget.capimages!.add(File(image.path));
          // images.add(widget.capimages);
        });
      }
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on newImage method PreviewImageScreen: ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  void removeImage(int index) {
    setState(() {
      widget.capimages!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xff392850),
        title: Text(
          "Photos",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Calibri',
              fontSize: 20.0),
        ),
      ),
      body: SingleChildScrollView(
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (widget.capimages != null)
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.capimages!.length,
                      itemBuilder: (BuildContext ctx, index) {
                        final cap = widget.capimages![index];
                        if (cap != null) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 25.0,
                                    width: 100.0,
                                    margin:
                                        EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10)))),
                                        onPressed: () {
                                          removeImage(index);
                                        },
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'remove?',
                                          style:
                                              TextStyle(fontFamily: 'Calibri'),
                                        )),
                                  )
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                height: 400.0,
                                child: Image.file(cap),
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 1.5,
                              )
                            ],
                          );
                        }
                        return null;
                      })
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: Center(
                            child: Text(
                              "Capture Photo First",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                                fontFamily: 'Calibri',
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          newImage();
                        },
                        child: CircleAvatar(
                          radius: 44.0,
                          backgroundColor: Colors.indigo[50],
                          child: Icon(
                            Icons.linked_camera_outlined,
                            size: 30.0,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 5.0,
                ),
                Column(
                  children: [
                    Container(
                      child: TextButton(
                          onPressed: () {
                            newImage();
                          },
                          child: Text(
                            "Capture Photo?",
                            style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                if (widget.capimages != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        height: 40.0,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                backgroundColor: Color(0xff392850)),
                            onPressed: () async {
                              if (widget.capimages!.isNotEmpty) {
                                convertbase64();
                                await DBHelper.createImageDB(postImages);
                                if (widget.Vtype ==
                                    InquiryTypes.BankStatementVerification) {
                                  setState(() {
                                    DBHelper.updateBankfinalstatus(
                                        widget.verifyID!,
                                        InquiryStatus.Completed);
                                  });
                                } else if (widget.Vtype ==
                                    InquiryTypes.SalarySlipSlipVerification) {
                                  setState(() {
                                    DBHelper.updateSalaryfinalstatus(
                                        widget.verifyID!,
                                        InquiryStatus.Completed);
                                  });
                                } else if (widget.Vtype ==
                                    InquiryTypes.TenantVerification) {
                                  setState(() {
                                    DBHelper.updatetenantfinalstatus(
                                        widget.verifyID!,
                                        InquiryStatus.Completed);
                                  });
                                } else if (widget.Vtype ==
                                        InquiryTypes.OfficeVerification &&
                                    widget.subVertype ==
                                        InquiryTypes.OfficeAddress) {
                                  setState(() {
                                    DBHelper.updateOffAddressstatus(
                                        widget.verifyID!,
                                        InquiryStatus.Completed);
                                  });
                                } else if (widget.Vtype ==
                                        InquiryTypes.ResidenceVerification &&
                                    widget.subVertype ==
                                        InquiryTypes.ResidenceAddress) {
                                  setState(() {
                                    DBHelper.updateResHomestatus(
                                        widget.verifyID!,
                                        InquiryStatus.Completed);
                                  });
                                }
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AssignedInquiries(
                                              InquiryID: widget.inquiryid,
                                            )));

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.green,
                                        content: Text(
                                          "Successfully Saved!",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'Calibri'),
                                        )));
                                // MyDialog.show(context, "Successfully Saved!");
                                // Future.delayed(Duration(seconds: 2), () {
                                //   Navigator.of(context, rootNavigator: true)
                                //       .pop();
                                // });
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          "Kindly, Capture atleast one photo",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontFamily: 'Calibri'),
                                        )));
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
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
