import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pvs/Widgets/Inquiry_status.dart';
import '../../Database/Database_Helper.dart';
import '../../Module for Get Data/Inquires_response.dart';
import '../Logs/Logeger.dart';

int? inProgress;
int? Completed;
int? partial;
int? total;

Future getStatusCount() async {
  try {
    List<Data> datalist = await DBHelper.DataResponse();
    int totallength = datalist.length;
    int InProgressCount = datalist
        .where((data) => data.Status == InquiryStatus.InProgress)
        .length;
    int CompletedCount =
        datalist.where((data) => data.Status == InquiryStatus.Completed).length;
    int PartialCount = datalist
        .where((data) => data.Status == InquiryStatus.PartialCompleted)
        .length;
    inProgress = InProgressCount;
    Completed = CompletedCount;
    partial = PartialCount;
    total = totallength;
  } on Exception catch (e) {
    EVSLogger.appendLog(
        "Exception on getStatusCount method graph screen : ${e.toString()}");
  }
}

class Graph extends StatefulWidget {
  const Graph({
    Key? key,
  }) : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff392850),
        title: Text(
          "Inquiries Status",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Calibri',
              fontSize: 20.0),
        ),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.1,
            child: Card(
              elevation: 0,
              child: PieChart(
                PieChartData(
                    sections: _generateSections(),
                    centerSpaceRadius: 50,
                    sectionsSpace: 0,
                    pieTouchData: PieTouchData(touchCallback:
                        (FlTouchEvent event,
                            PieTouchResponse? pieTouchResponse) {
                      setState(() {
                        if (event is FlLongPressEnd || event is FlPanEndEvent) {
                          touchedIndex = -1;
                        } else {
                          touchedIndex = pieTouchResponse
                                  ?.touchedSection?.touchedSectionIndex ??
                              -1;
                        }
                      });
                    })),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      width: 20.0,
                      decoration: BoxDecoration(color: Colors.green),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    const Text(
                      "Total Inquiries :",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Calibri',
                          fontSize: 20.0),
                    ),
                    Text(
                      " ${total ?? 0}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Calibri',
                          fontSize: 20.0),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      width: 20.0,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 250, 77, 25)),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    const Text(
                      "In-Progress:",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Calibri',
                          fontSize: 20.0),
                    ),
                    Text(
                      " ${inProgress ?? 0}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Calibri',
                          fontSize: 20.0),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      width: 20.0,
                      decoration: BoxDecoration(color: Colors.blue),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    const Text(
                      "Partial Completed :",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Calibri',
                          fontSize: 20.0),
                    ),
                    Text(
                      " ${partial ?? 0}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Calibri',
                          fontSize: 20.0),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      width: 20.0,
                      decoration:
                          BoxDecoration(color: Color.fromARGB(255, 50, 248, 0)),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    const Text(
                      "Completed :",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Calibri',
                          fontSize: 20.0),
                    ),
                    Text(
                      " ${Completed ?? 0}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Calibri',
                          fontSize: 20.0),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    final int inProgressCount = inProgress ?? 0;
    final int completedCount = Completed ?? 0;
    final int partialCount = partial ?? 0;

    return [
      _createSectionData(
        value: inProgressCount.toDouble(),
        title: 'In-Progress',
        color: Color.fromARGB(255, 250, 77, 25),
      ),
      _createSectionData(
        value: completedCount.toDouble(),
        title: 'Completed',
        color: Color.fromARGB(255, 50, 248, 0),
      ),
      _createSectionData(
        value: partialCount.toDouble(),
        title: 'Partial',
        color: Colors.blue,
      ),
      // _createSectionData(
      //   value: totalCount.toDouble(),
      //   title: 'Total',
      //   color: Colors.orange,
      // ),
    ];
  }

  PieChartSectionData _createSectionData({
    required double value,
    required String title,
    required Color color,
  }) {
    final isTouched = touchedIndex == -1 ? false : touchedIndex == 0;

    return PieChartSectionData(
      color: color,
      value: value,
      title: '$title\n${value.toInt()}',
      radius: isTouched ? 100 : 80,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xffffffff),
      ),
    );
  }
}
