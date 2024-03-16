import 'package:flutter/material.dart';

class Residence_CustomCard extends StatelessWidget {
  final String TypeofPerson;
  final String Name;
  final String Address;
  final String Landmark;

  Residence_CustomCard({
    super.key,
    required this.TypeofPerson,
    required this.Name,
    required this.Address,
    required this.Landmark,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0))),
        color: Color(0xff453658),
        child: Container(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("${TypeofPerson}'s Name: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 21.0,
                              fontFamily: 'Calibri')),
                      Expanded(
                        child: Text(
                          "${Name}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 21.0,
                              fontFamily: 'Calibri'),
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text("Residence Address: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 21.0,
                              fontFamily: 'Calibri')),
                      Expanded(
                        child: Text(
                          "${Address}",
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 21.0,
                              fontFamily: 'Calibri'),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Text("Nearest Landmark: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 21.0,
                              fontFamily: 'Calibri')),
                      Expanded(
                        child: Text(
                          "${Landmark}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 21.0,
                              fontFamily: 'Calibri'),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text("Application No: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 21.0,
                              fontFamily: 'Calibri')),
                      const Text(
                        "NA",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 21.0,
                            fontFamily: 'Calibri'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
