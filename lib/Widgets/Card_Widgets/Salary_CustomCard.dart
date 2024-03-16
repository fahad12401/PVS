import 'package:flutter/material.dart';

class SalarySlip_CustomCard extends StatelessWidget {
  SalarySlip_CustomCard(
      {super.key,
      required this.NameofPerson,
      required this.NameofOffice,
      required this.landmark,
      required this.typeofPerson,
      required this.AddressofOffice});
  final String NameofPerson;
  final String NameofOffice;
  final String landmark;
  final String typeofPerson;
  final String AddressofOffice;
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
                      Text("${typeofPerson}'s Name: ",
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
                              fontSize: 20.0,
                              fontFamily: 'Calibri'),
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text("Office Name: ",
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
                              fontSize: 20.0,
                              fontFamily: 'Calibri'),
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text("Office Address: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 21.0,
                              fontFamily: 'Calibri')),
                      Expanded(
                        child: Text(
                          "${AddressofOffice}",
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
