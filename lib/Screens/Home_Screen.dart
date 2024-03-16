import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pvs/Screens/Login_screen.dart';
import 'package:pvs/Screens/Profile_screen.dart';
import 'package:pvs/Widgets/Dialogbox.dart';
import 'package:pvs/Widgets/Gridview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Database/Database_Helper.dart';
import '../Module for Get Data/Login_response.dart';
import '../Widgets/Graphs/Status_count.dart';
import '../Widgets/Logs/LoggerEmail.dart';
import '../Widgets/Perferences.dart';
import 'Setting_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool isLoading = false;
  DateTime? currentBackpressTime;

  //**************************************** */
  //**************************************** */

  Future<bool> _onwillPop() {
    DateTime now = DateTime.now();
    if (currentBackpressTime == null ||
        now.difference(currentBackpressTime!) > Duration(seconds: 2)) {
      currentBackpressTime = now;
      showSnck(context, "Press back button again to exit", Colors.red);
      return Future.value(false);
    }
    return Future.value(true);
  }

  // Future<void> _deleteCache() async {
  //   final cacheDir = await getTemporaryDirectory();
  //   if (cacheDir.existsSync()) {
  //     cacheDir.deleteSync(recursive: true);
  //   } else {
  //     return;
  //   }
  //   final appDir = await getApplicationSupportDirectory();
  //   if (appDir.existsSync()) {
  //     appDir.deleteSync(recursive: true);
  //   } else {
  //     return;
  //   }
  // }

  @override
  void initState() {
    DBHelper.Readresponse();
    DBHelper.CreateAppversion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didpop) {
        _onwillPop();
      },
      child: Scaffold(
        key: _drawerKey,
        backgroundColor: Colors.indigo[50],
        drawer: Drawer(
          width: MediaQuery.of(context).size.width - 110,
          backgroundColor: Colors.indigo[50],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(55.0),
            bottomRight: Radius.circular(55.0),
          )),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 190,
                child: DrawerHeader(
                    curve: Curves.easeInOutSine,
                    decoration: BoxDecoration(color: Color(0xff453658)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text("Welcome!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Calibri',
                                  fontSize: 27.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic)),
                          const SizedBox(
                            height: 2.0,
                          ),
                          FutureBuilder(
                              future: DBHelper.ReadUserResponse(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<User> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (!snapshot.hasData) {
                                    return Text('No Data Found',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Calibri',
                                          fontSize: 25.0,
                                        ));
                                  } else {
                                    return Text(
                                        "${snapshot.data!.firstName} ${snapshot.data!.lastName}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Calibri',
                                          fontSize: 25.0,
                                        ));
                                  }
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SpinKitThreeBounce(
                                    size: 12.0,
                                    color: Colors.white38,
                                  );
                                } else {
                                  return Text(
                                    "Error While Loading Data",
                                    style: TextStyle(
                                      fontFamily: 'Calibri',
                                      fontSize: 20,
                                    ),
                                  );
                                }
                              }),
                        ],
                      ),
                    )),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.grey,
                ),
                title: const Text(
                  "Home",
                  style: TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_outline_outlined,
                  color: Colors.grey,
                ),
                title: const Text(
                  "Profile",
                  style: TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.bar_chart_outlined,
                  color: Colors.grey,
                ),
                title: const Text(
                  "Inquiries Status",
                  style: TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                onTap: () {
                  setState(() {
                    getStatusCount();
                  });

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Graph()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  color: Colors.grey,
                ),
                title: const Text(
                  "Settings",
                  style: TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout_outlined,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  "Sign-Out",
                  style: TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  if (isLoading) {
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ),
                    );
                  }
                  setState(() {
                    isLoading = true;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return finalDialog(
                            context,
                            "Sign Out",
                            "Are you sure you want to sign out?",
                            "Sign-Out", () {
                          UserPerference.setLoggedin(false).then((value) async {
                            await DBHelper.DeleteUserDb();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          });
                          prefs.clear();
                        });
                      });

                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CustomPaint(
                painter: CurvePainter(),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.11,
                    ),
                    Stack(
                      children: <Widget>[
                        Positioned(
                          bottom: 0,
                          child: Container(
                              padding: EdgeInsets.only(left: 0.0),
                              child: IconButton(
                                padding: EdgeInsets.only(left: 0.0, top: 9.0),
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _drawerKey.currentState!.openDrawer();
                                },
                              )),
                        ),
                        Center(
                          child: Text(
                            "H O M E",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Calibri',
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 80.0,
                    ),
                    Expanded(
                        child: Container(
                      child: GridDashboard(),
                    ))
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final path = Path();
    paint.style = PaintingStyle.fill;
    paint.shader = LinearGradient(colors: [
      Color(0xff392850),
      Color(0xff453658),
      Color(0xff8f77dc),
      Color(0xff8f67bc),
    ], begin: Alignment.topLeft, end: Alignment.bottomRight)
        .createShader(Rect.fromLTRB(size.width * 0.15, size.height * 0.15,
            size.width, size.height * 0.1));
    path.moveTo(0, size.height * 0.15);
    path.quadraticBezierTo(
        size.width * 0.30, size.height * 0.30, size.width, size.height * 0.20);
    path.quadraticBezierTo(
        size.width * 0.9, size.height * 0.30, size.width, size.height * 0.20);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
