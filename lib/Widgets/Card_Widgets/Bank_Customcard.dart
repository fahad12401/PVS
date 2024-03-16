import 'package:flutter/material.dart';

class Bank_CustomCard extends StatelessWidget {
  final String NameOfBank;
  final String NameOfPerson;
  final String typeofPerson;
  final String landmark;
  Bank_CustomCard(
      {super.key,
      required this.NameOfBank,
      required this.NameOfPerson,
      required this.typeofPerson,
      required this.landmark});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        shape: RoundedRectangleBorder(
            // side: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0))),
        elevation: 3.0,
        color: Color(0xff453658),
        child: Container(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("${typeofPerson}'s Name: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 21.0,
                              fontFamily: 'Calibri')),
                      Expanded(
                        child: Text(
                          "${NameOfPerson}",
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
                      const Text("Bank Name: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 21.0,
                              fontFamily: 'Calibri')),
                      Expanded(
                        child: Text(
                          "${NameOfBank}",
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
                          "${landmark}",
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
                      Text(
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
