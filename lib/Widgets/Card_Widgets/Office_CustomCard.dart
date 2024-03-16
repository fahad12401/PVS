import 'package:flutter/material.dart';

class OfficeCustomCard extends StatelessWidget {
  final String NameofOffice;
  final String AddressofOffice;
  final String NameofPerson;
  final String Landmark;
  final String typeOfPerson;

  OfficeCustomCard(
      {super.key,
      required this.NameofOffice,
      required this.AddressofOffice,
      required this.NameofPerson,
      required this.Landmark,
      required this.typeOfPerson});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        elevation: 3.0,
        color: Color(0xff453658),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0))),
        child: Container(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("${typeOfPerson}'s Name: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 21.0,
                              fontFamily: 'Calibri')),
                      Expanded(
                        child: Text(
                          "${NameofPerson}",
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
                      const Text("Company/Office Name: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 21.0,
                              fontFamily: 'Calibri')),
                      Expanded(
                        child: Text(
                          "${NameofOffice}",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: const Text("Company/Office Address: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 21.0,
                                fontFamily: 'Calibri')),
                      ),
                      Expanded(
                        child: Text(
                          "${AddressofOffice}",
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
                      Flexible(
                        fit: FlexFit.loose,
                        child: const Text("Nearest Landmark: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 21.0,
                                fontFamily: 'Calibri')),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
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
