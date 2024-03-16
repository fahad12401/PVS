import 'dart:async';
import 'package:flutter/material.dart';

import '../../Screens/Home_Screen.dart';

class Animatedcheck extends StatefulWidget {
  final String Dialogname;
  final Color color;
  final IconData icon;
  const Animatedcheck(
      {super.key,
      required this.Dialogname,
      required this.color,
      required this.icon});

  @override
  State<Animatedcheck> createState() => _AnimatedcheckState();
}

class _AnimatedcheckState extends State<Animatedcheck>
    with TickerProviderStateMixin {
  late AnimationController scalecontroller =
      AnimationController(vsync: this, duration: Duration(seconds: 2));
  late AnimationController checkController =
      AnimationController(vsync: this, duration: Duration(seconds: 1));
  late Animation<double> scaleanimation = CurvedAnimation(
      parent: scalecontroller, curve: Curves.easeInOutCubicEmphasized);
  late Animation<double> checkAnimation = CurvedAnimation(
      parent: checkController, curve: Curves.easeInOutCubicEmphasized);
  @override
  void initState() {
    super.initState();
    scalecontroller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scalecontroller.forward();

    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
    // Timer(Duration(seconds: 3), () => Navigator.pop(context));
  }

  @override
  void dispose() {
    scalecontroller.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double circleSize = 100;
    double iconSize = 70;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                fit: StackFit.loose,
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Container(
                      height: circleSize,
                      width: circleSize,
                      decoration: BoxDecoration(
                          color: widget.color, shape: BoxShape.circle),
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: checkAnimation,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 5.0,
                          ),
                          Icon(
                            widget.icon,
                            color: Colors.white,
                            size: iconSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 130.0,
                        ),
                        Text(
                          "${widget.Dialogname}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 29.0,
                              fontFamily: 'Calibri'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
