import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pvs/Screens/Home_Screen.dart';
import '../Database/Database_Helper.dart';
import '../Module for Get Data/Inquires_response.dart';
import '../Widgets/Inquiry_status.dart';
import '../Widgets/Logs/Logeger.dart';
import 'assigned_inq_screen.dart';

class InquiresScreen extends StatefulWidget {
  InquiresScreen({
    super.key,
  });

  @override
  State<InquiresScreen> createState() => _InquiresScreenState();
}

class _InquiresScreenState extends State<InquiresScreen> {
  TextEditingController searchcontroller = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  List<Data> finalData = [];
  List<Data> newdata = [];
  int? press;
  int? inqid;
  int? orignaldex;
  bool filteration = false;
  bool filterlist = true;

  Future<void> moveIndex(
      int index, int islongpress, int originalIndex, int inquiryId) async {
    try {
      if (originalIndex != 0 && islongpress != 0) {
        await DBHelper.saveindex(inquiryId, 0);
        await DBHelper.AddedToTop(inquiryId, "Added to top");
        finalData[index].orignalIndex = 0;

        for (var i = 0; i < finalData.length; i++) {
          if (i != index && finalData[i].orignalIndex! <= originalIndex) {
            final newOriginalIndex = finalData[i].orignalIndex! + 1;

            // finalData[i].orignalIndex = newOriginalIndex;
            await DBHelper.saveindex(finalData[i].InquiryId!, newOriginalIndex);
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.deepPurple,
            content: Text(
              "Added to Top",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Calibri',
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            )));
      } else if (islongpress == 0) {
        var newindex = finalData.length;

        if (newindex != originalIndex) {
          await DBHelper.saveindex(
            inquiryId,
            newindex,
          );
          await DBHelper.AddedToTop(inquiryId, "");
          finalData[index].orignalIndex = newindex;
          finalData[index].addedtotop = '';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.deepPurple,
              content: Text(
                "Remove from Top",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Calibri',
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              )));
        }
      }
      setState(() {});
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on moveIndex method Inquiries Screen: ${e.toString()}");
    }
  }

  List<Data> filterData(List<Data> data, String Query) {
    if (Query.isEmpty) {
      return data;
    } else {
      return data
          .where((element) =>
              element.AppName!.toLowerCase().contains(Query.toLowerCase()) ||
              element.AppCNIC!.toLowerCase().contains(Query.toLowerCase()) ||
              element.AppContact!.toLowerCase().contains(Query.toLowerCase()) ||
              element.ProductName!
                  .toLowerCase()
                  .contains(Query.toLowerCase()) ||
              element.CompanyName!.toLowerCase().contains(Query.toLowerCase()))
          .toList();
    }
  }

  fetchData() async {
    finalData = await DBHelper.DataResponse();

    if (mounted) {
      setState(() {});
    }
    return finalData;
  }

  @override
  void initState() {
    super.initState();
    searchcontroller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      filteration = !filteration;
    });
  }

  Color _getStatusColor(String status) {
    if (status == InquiryStatus.InProgress) {
      return Color.fromARGB(255, 250, 77, 25);
    } else if (status == InquiryStatus.PartialCompleted) {
      return Colors.blue;
    } else {
      return Color.fromARGB(255, 50, 248, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return PopScope(
        canPop: true,
        onPopInvoked: (didpop) {
          if (didpop) {
            return;
          }
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        child: Scaffold(
            key: scaffoldkey,
            backgroundColor: Colors.white60,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xff392850),
              toolbarHeight: 150.0,
              centerTitle: true,
              title: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "I N Q U I R I E S",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          fontFamily: 'Calibri'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 8.0, top: 8.0),
                      child: Row(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: TextField(
                              controller: searchcontroller,
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Calibri'),
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Calibri',
                                      color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          IconButton(
                              onPressed: _toggle,
                              icon: filteration
                                  ? Icon(Icons.filter_alt_off_sharp)
                                  : Icon(
                                      Icons.filter_alt,
                                      color: Colors.white,
                                    ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: filteration
                  ? FutureBuilder(
                      future: DBHelper.FilterResponse(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Data>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text("There is no data found!",
                                  style: TextStyle(
                                      fontFamily: 'Calibri',
                                      fontSize: 22.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            );
                          } else {
                            finalData = filterData(
                                snapshot.data!, searchcontroller.text);
                            if (finalData.isNotEmpty) {
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: finalData.length,
                                  itemBuilder: (context, int index) {
                                    return GestureDetector(
                                      child: InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0, top: 0.0),
                                          child: Card(
                                            elevation: 3.0,
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3,
                                              width: double.infinity,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 11.0,
                                                    right: 5.0,
                                                    top: 9.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Company Name: ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Calibri',
                                                                  fontSize:
                                                                      20.0),
                                                            ),
                                                            Text(
                                                              "${finalData[index].CompanyName}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'Calibri',
                                                                  fontSize:
                                                                      20.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Product Name:   ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Calibri',
                                                              fontSize: 20.0),
                                                        ),
                                                        Text(
                                                          "${finalData[index].ProductName}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Calibri',
                                                              fontSize: 20.0),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    if (finalData[index]
                                                            .AppNo ==
                                                        null)
                                                      Text(
                                                        "Applicant No:      NA",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Calibri',
                                                            fontSize: 20.0),
                                                      )
                                                    else
                                                      Text(
                                                        "Applicant No:      ${finalData[index].AppNo}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Calibri',
                                                            fontSize: 20.0),
                                                      ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                      "Applicant Name:   ${finalData[index].AppName}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Calibri',
                                                          fontSize: 20.0),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                      "Applicant CNIC:    ${finalData[index].AppCNIC}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Calibri',
                                                          fontSize: 20.0),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                      "Applicant ContactNo:  ${finalData[index].AppContact}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Calibri',
                                                          fontSize: 20.0),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Status:   ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Calibri',
                                                              fontSize: 20.0),
                                                        ),
                                                        Text(
                                                          "${finalData[index].Status}",
                                                          style: TextStyle(
                                                              color: _getStatusColor(
                                                                  finalData[
                                                                          index]
                                                                      .Status
                                                                      .toString()),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Calibri',
                                                              fontSize: 20.0),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        Text("${index}")
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AssignedInquiries(
                                                        InquiryID:
                                                            finalData[index]
                                                                .InquiryId,
                                                      )));
                                        },
                                      ),
                                    );
                                  });
                            } else {
                              return Center(
                                child: Text("There is no data found!",
                                    style: TextStyle(
                                        fontFamily: 'Calibri',
                                        fontSize: 22.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              );
                            }
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SpinKitThreeBounce(
                            size: 15.0,
                            color: Colors.white,
                          );
                        } else {
                          return Center(
                            child: Text("Error while fetching data!",
                                style: TextStyle(
                                    fontFamily: 'Calibri',
                                    fontSize: 22.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          );
                        }
                      })
                  : FutureBuilder(
                      future: DBHelper.DataResponse(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Data>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text("There is no data found!",
                                  style: TextStyle(
                                      fontFamily: 'Calibri',
                                      fontSize: 22.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            );
                          } else {
                            finalData = filterData(
                                snapshot.data!, searchcontroller.text);
                            if (finalData.isNotEmpty) {
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: finalData.length,
                                  itemBuilder: (context, int index) {
                                    return GestureDetector(
                                      child: InkWell(
                                        onLongPress: () async {
                                          newdata = await DBHelper.Datares(
                                              finalData[index].InquiryId!);
                                          press = newdata[0].islongPressed!;
                                          inqid = newdata[0].InquiryId;
                                          orignaldex = newdata[0].orignalIndex;

                                          if (press == 0) {
                                            press = 1;
                                          } else if (press == 1) {
                                            press = 0;
                                          }
                                          await DBHelper.saveLongPress(press!,
                                              finalData[index].InquiryId!);
                                          await moveIndex(index, press!,
                                              orignaldex!, inqid!);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Card(
                                            elevation: 3.0,
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3,
                                              width: double.infinity,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: 11.0,
                                                  right: 5.0,
                                                  top: 9.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Company Name: ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Calibri',
                                                                  fontSize:
                                                                      20.0),
                                                            ),
                                                            Text(
                                                              "${finalData[index].CompanyName}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'Calibri',
                                                                  fontSize:
                                                                      20.0),
                                                            ),
                                                          ],
                                                        ),
                                                        if (finalData[index]
                                                                .addedtotop ==
                                                            "")
                                                          Text("")
                                                        else
                                                          Container(
                                                              child: Icon(
                                                            Icons.push_pin,
                                                            color: Colors.green,
                                                          )
                                                              // Text(
                                                              //   "${finalData[index].addedtotop}",
                                                              //   style: TextStyle(
                                                              //       color: Colors
                                                              //           .green,
                                                              //       fontWeight:
                                                              //           FontWeight
                                                              //               .bold,
                                                              //       fontFamily:
                                                              //           'Calibri',
                                                              //       fontSize: 20.0),
                                                              // ),
                                                              )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Product Name:   ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Calibri',
                                                              fontSize: 20.0),
                                                        ),
                                                        Text(
                                                          "${finalData[index].ProductName}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Calibri',
                                                              fontSize: 20.0),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    if (finalData[index]
                                                            .AppNo ==
                                                        null)
                                                      Text(
                                                        "Applicant No:      NA",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Calibri',
                                                            fontSize: 20.0),
                                                      )
                                                    else
                                                      Text(
                                                        "Applicant No:      ${finalData[index].AppNo}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Calibri',
                                                            fontSize: 20.0),
                                                      ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                      "Applicant Name:   ${finalData[index].AppName}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Calibri',
                                                          fontSize: 20.0),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                      "Applicant CNIC:    ${finalData[index].AppCNIC}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Calibri',
                                                          fontSize: 20.0),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                      "Applicant ContactNo:  ${finalData[index].AppContact}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Calibri',
                                                          fontSize: 20.0),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Status:   ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Calibri',
                                                              fontSize: 20.0),
                                                        ),
                                                        Text(
                                                          "${finalData[index].Status}",
                                                          style: TextStyle(
                                                              color: _getStatusColor(
                                                                  finalData[
                                                                          index]
                                                                      .Status
                                                                      .toString()),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Calibri',
                                                              fontSize: 20.0),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        Text("${index}")
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AssignedInquiries(
                                                        InquiryID:
                                                            finalData[index]
                                                                .InquiryId,
                                                      )));
                                        },
                                      ),
                                    );
                                  });
                            } else {
                              return Center(
                                child: Text("There is no data found!",
                                    style: TextStyle(
                                        fontFamily: 'Calibri',
                                        fontSize: 22.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              );
                            }
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SpinKitThreeBounce(
                            size: 15.0,
                            color: Colors.white,
                          );
                        } else {
                          return Center(
                            child: Text("Error while fetching Data!",
                                style: TextStyle(
                                    fontFamily: 'Calibri',
                                    fontSize: 22.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          );
                        }
                      }),
            )),
      );
    } on Exception catch (e) {
      EVSLogger.appendLog("Exception on Inquiries Screen: ${e.toString()}");
      throw e;
    }
  }

  Widget _buildRow(String label, String value, {bool status = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            "${label}",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Calibri',
              fontSize: 16.0,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Calibri',
                  fontSize: status ? 18.0 : 16.0,
                  fontWeight: status ? FontWeight.bold : FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }
}
