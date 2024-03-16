import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyDialog {
  static Future<void> show(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Calibri',
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
        );
      },
    ).then((value) => null); // use .then to dismiss dialog box
  }

  static Loading(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shadowColor: Colors.black38,
              content: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SpinKitPouringHourGlass(
                      color: Colors.white,
                      size: 40.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "please wait\nsyncing in progress!",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Calibri',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ));
        }).then((value) => null);
  }
}

// // To call the dialog:
// MyDialog.show(context, "Hello, World!");

// // To show dialog for 2 seconds:
// Future.delayed(Duration(seconds: 2), () {
//   Navigator.of(context, rootNavigator: true).pop();
// });

class TextFileViewer extends StatelessWidget {
  const TextFileViewer({super.key, required this.filePath});
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Logs"),
      content: Container(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: File(filePath).readAsString(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error loading file');
                  }
                  return Text(snapshot.data ?? '');
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Close"))
      ],
    );
  }
}

Widget finalDialog(BuildContext context, String titles, String newContent,
    String buttonName, final VoidCallback imageButton) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0))),
    backgroundColor: Colors.grey[300],
    title: Text(
      titles,
    ),
    content: Text(newContent),
    contentTextStyle: TextStyle(
        fontWeight: FontWeight.w100,
        fontSize: 19,
        fontFamily: 'Calibri',
        color: Colors.black),
    titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        fontFamily: 'Calibri',
        color: Colors.black),
    actions: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Divider(
            color: Colors.black,
          ),
          InkWell(
            onTap: imageButton,
            child: Container(
              height: 25,
              child: Text(
                "${buttonName}",
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 19,
                    fontFamily: 'Calibri',
                    color: Colors.black),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 28,
              child: Text(
                "back",
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 19,
                    fontFamily: 'Calibri',
                    color: Colors.black),
              ),
            ),
          ),
        ],
      )
    ],
  );
}

Widget SalariedDialog(BuildContext context, String titles, String newContent,
    String buttonName, final VoidCallback imageButton) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0))),
    backgroundColor: Colors.grey[300],
    title: Text(
      titles,
    ),
    content: Text(newContent),
    contentTextStyle: TextStyle(
        fontWeight: FontWeight.w100,
        fontSize: 19,
        fontFamily: 'Calibri',
        color: Colors.black),
    titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        fontFamily: 'Calibri',
        color: Colors.black),
    actions: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Divider(
            color: Colors.black,
          ),
          InkWell(
            onTap: imageButton,
            child: Container(
              height: 25,
              child: Text(
                "${buttonName}",
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 19,
                    fontFamily: 'Calibri',
                    color: Colors.black),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 28,
              child: Text(
                "No",
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 19,
                    fontFamily: 'Calibri',
                    color: Colors.black),
              ),
            ),
          ),
        ],
      )
    ],
  );
}

Widget NeighbrDialog(
    BuildContext context,
    String titles,
    String newContent,
    String buttonName,
    String buttonName2,
    final VoidCallback saveButton,
    final VoidCallback fillformButton) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0))),
    backgroundColor: Colors.grey[300],
    title: Text(
      titles,
    ),
    content: Text(newContent),
    contentTextStyle: TextStyle(
        fontWeight: FontWeight.w100,
        fontSize: 19,
        fontFamily: 'Calibri',
        color: Colors.black),
    titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        fontFamily: 'Calibri',
        color: Colors.black),
    actions: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Divider(
            color: Colors.black,
          ),
          InkWell(
            onTap: saveButton,
            child: Container(
              height: 25,
              child: Text(
                "${buttonName}",
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 19,
                    fontFamily: 'Calibri',
                    color: Colors.black),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          InkWell(
            onTap: fillformButton,
            child: Container(
              height: 28,
              child: Text(
                buttonName2,
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 19,
                    fontFamily: 'Calibri',
                    color: Colors.black),
              ),
            ),
          ),
        ],
      )
    ],
  );
}

Widget NeighbrfinalyesDialog(
  BuildContext context,
  String titles,
  String newContent,
  String buttonName,
  final VoidCallback saveButton,
) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0))),
    backgroundColor: Colors.grey[300],
    title: Text(
      titles,
    ),
    content: Text(newContent),
    contentTextStyle: TextStyle(
        fontWeight: FontWeight.w100,
        fontSize: 19,
        fontFamily: 'Calibri',
        color: Colors.black),
    titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        fontFamily: 'Calibri',
        color: Colors.black),
    actions: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Divider(
            color: Colors.black,
          ),
          InkWell(
            onTap: saveButton,
            child: Container(
              height: 25,
              child: Text(
                "${buttonName}",
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 19,
                    fontFamily: 'Calibri',
                    color: Colors.black),
              ),
            ),
          ),
        ],
      )
    ],
  );
}
