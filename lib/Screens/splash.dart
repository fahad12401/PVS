import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pvs/Screens/Home_Screen.dart';
import '../Widgets/Animated_Widgets/custom_image.dart';
import '../Widgets/Logs/LoggerEmail.dart';
import '../Widgets/Perferences.dart';
import 'Login_screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  // setSharedPerference(BuildContext context) async {
  //   preferences = await SharedPreferences.getInstance();
  //   var evs = preferences!.getString("evs");
  //   if (evs != null && evs.isNotEmpty) {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //   } else {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //   }
  // }

  @override
  void initState() {
    Timer(Duration(seconds: 3), navigatetoNextScreen);
    super.initState();
  }

  Future<void> navigatetoNextScreen() async {
    final login = await UserPerference.isLoggedin();
    if (login) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackpressTime;
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

    return PopScope(
      canPop: false,
      onPopInvoked: (bool canpopp) {
        if (canpopp) {
          return;
        }
        _onwillPop;
      },
      child: Scaffold(
        backgroundColor: Color(0xff453658),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Transform.scale(
                        scale: 1.5,
                        child: CustomImage(image: "assets/pvslogo.png"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
