import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pvs/Widgets/Gps_Widgets/gps_loc.dart';
import 'package:pvs/Widgets/Logs/Logeger.dart';

class GPSLocation extends StatefulWidget {
  GPSLocation({
    super.key,
  });

  @override
  State<GPSLocation> createState() => _GPSLocationState();
}

class _GPSLocationState extends State<GPSLocation> {
  bool locationupdate = false;
  bool chkupdate = false;
  bool isLoading = false;
  checkGPS() async {
    try {
      setState(() {
        isLoading = true;
      });
      // final status = await Permission.location.request();
      // if (status.isGranted) {
      servicestatus = await Geolocator.isLocationServiceEnabled();
      if (servicestatus) {
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            isLoading = false;
          });
          permission = await Geolocator.requestPermission();

          if (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always) {
            setState(() {
              isLoading = true;
            });
            haspermission = true;
          }
          if (permission == LocationPermission.denied) {
            setState(() {
              isLoading = false;
            });
            print("GPS service is Disabled");
          }
        } else if (permission == LocationPermission.deniedForever) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "GPS service is Permanently  Disabled",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.red,
          ));
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
      if (haspermission) {
        getlocation();
        setState(() {
          isLoading = false;
        });
      } else {
        print("GPS Service is not enabled, turn on GPS location");
        showalertdialog(
            context, "GPS Service is not enabled, turn on GPS location");
      }
      // }
      // else {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //       "Kindly open location",
      //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //     ),
      //     backgroundColor: Colors.red,
      //     duration: Duration(seconds: 2),
      //   ));
      // }
      // else if (status.isPermanentlyDenied) {

      //   openAppSettings();
      // }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "${e.toString()}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      EVSLogger.appendLog(
          "Exception on checkGPS method GPSLocation: ${e.toString()}");
    }
  }

  getlocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(position.latitude);
      print(position.longitude);
      setState(() {
        long = position.longitude.toString();
        lat = position.latitude.toString();
      });
    } on Exception catch (e) {
      EVSLogger.appendLog(
          "Exception on getlocation method GPSLocation: ${e.toString()}");
    }
  }

  @override
  void initState() {
    if (lat.isNotEmpty && long.isNotEmpty) {
      locationupdate = true;
      chkupdate = false;
    } else {
      locationupdate = false;
      chkupdate = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text("GPS Location:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24.0,
                    fontFamily: 'Calibri')),
            AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeInOut,
                child: chkupdate
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                        key: ValueKey('check_icon'),
                      )
                    : Icon(
                        Icons.info,
                        color: Colors.red,
                        key: ValueKey('info_icon'),
                      ))
          ],
        ),
        Text("Latitude: ${lat} \nLongtitude : ${long}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontFamily: 'Calibri',
            )),
        const SizedBox(
          height: 3.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // if (isLoading)
            //   Stack(children: [
            //     Container(
            //       child: Center(
            //         child: SpinKitFadingCircle(
            //           color: Colors.black,
            //           size: 40.0,
            //         ),
            //       ),
            //     ),
            //   ]),
            if (isLoading == true)
              Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 180,
                  child: Stack(children: [
                    Container(
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: Colors.black,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ]))
            else
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff392850)),
                  onPressed: () {
                    if (lat.isNotEmpty && long.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      getlocation();
                      locationupdate = true;
                      chkupdate = true;
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      checkGPS();
                      locationupdate = true;
                      chkupdate = true;
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: Text(
                      locationupdate ? "Update Location" : "Get Location",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'Calibri')))
          ],
        ),
      ],
    );
  }
}
