import 'package:flutter/material.dart';

import '../Widgets/Gridview.dart';
import '../Widgets/Logs/LoggerEmail.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _settingformkey = GlobalKey<FormState>();
  String _selecteddropdown = "Primary";
  bool _showinputfield = false;
  String? _selecteddropvalue;
  TextEditingController _mannualurlcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Calibri',
              fontWeight: FontWeight.bold,
              fontSize: 23.0),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(
                      child: Text(
                    predefurl,
                    style: TextStyle(fontFamily: 'Calibri', fontSize: 20.0),
                  )),
                ),
                SizedBox(
                  height: 14.0,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Radio(
                              activeColor: Color(0xff453658),
                              value: true,
                              groupValue: _showinputfield,
                              onChanged: (value) {
                                setState(() {
                                  _showinputfield = value!;
                                });
                              }),
                          Expanded(
                              child: Text(
                            "Mannual",
                            style: TextStyle(fontFamily: 'Calibri'),
                          )),
                          Radio(
                              activeColor: Color(0xff453658),
                              value: false,
                              groupValue: _showinputfield,
                              onChanged: (value) {
                                setState(() {
                                  _showinputfield = value!;
                                });
                              }),
                          Expanded(
                              child: Text(
                            "Pre-Defined",
                            style: TextStyle(fontFamily: 'Calibri'),
                          ))
                        ],
                      ),
                      if (_showinputfield)
                        Form(
                          key: _settingformkey,
                          child: Container(
                            child: TextFormField(
                              controller: _mannualurlcontroller,
                              decoration: InputDecoration(
                                  labelText: "Url",
                                  labelStyle: TextStyle(
                                      fontFamily: 'Calibri',
                                      color: Color.fromARGB(255, 12, 15, 87)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 12, 15, 87),
                                          width: 1.5)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 14, 17, 107),
                                        width: 2.0),
                                  )),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please Enter url";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      if (!_showinputfield)
                        Padding(
                          padding: EdgeInsets.fromLTRB(13.0, 10.0, 13.0, 0.0),
                          child: SizedBox(
                            height: 60,
                            child: DropdownButtonFormField(
                              value: _selecteddropdown,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onSaved: (value) {
                                _selecteddropvalue = value;
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select an option';
                                }
                                return null;
                              },
                              items: [
                                DropdownMenuItem(
                                  child: Text("Primary"),
                                  value: _selecteddropdown,
                                ),
                                DropdownMenuItem(
                                  child: Text("Secondary"),
                                  value: 'Secondary',
                                ),
                              ],
                              onChanged: (String? value) {
                                _selecteddropvalue = value!;
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff453658),
                        ),
                        onPressed: () {
                          if (_showinputfield) {
                            if (_settingformkey.currentState!.validate()) {
                              setState(() {
                                predefurl = _mannualurlcontroller.text;
                              });
                            }
                          } else if (!_showinputfield) {
                            if (_selecteddropvalue == 'Primary') {
                              setState(() {
                                predefurl = "No URL Found";
                              });
                            } else if (_selecteddropvalue == 'Secondary') {
                              setState(() {
                                predefurl = "No Url Found";
                              });
                            }
                          } else {
                            print("there is problem");
                          }
                        },
                        child: Text(
                          "Change Server Url",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Calibri',
                              fontSize: 18),
                        )),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextButton(
                    onPressed: () {
                      EVSLoggerEmail email = EVSLoggerEmail(context);
                      email.showEmailDialog();
                    },
                    child: Text("View Logs")),
                SizedBox(
                  height: 15.0,
                ),
                Center(
                  child: Container(
                    height: 40,
                    width: 90,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                      child: Text(
                        "Version : ${Application}",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                            fontFamily: 'Calibri',
                            fontSize: 18),
                      ),
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

String predefurl = "http://10.65.171.91/";
