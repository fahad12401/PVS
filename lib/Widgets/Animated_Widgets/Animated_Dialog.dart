import 'dart:async';
import 'package:flutter/material.dart';
import '../../Screens/Home_Screen.dart';
import '../Gridview.dart';

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({super.key});
  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with TickerProviderStateMixin {
  late AnimationController scalecontroller =
      AnimationController(vsync: this, duration: Duration(seconds: 1));
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
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
  }

  @override
  void dispose() {
    scalecontroller.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double circleSize = 110;
    double iconSize = 102;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            height: 200.0,
            width: 200.0,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  fit: StackFit.loose,
                  children: [
                    Center(
                      child: Container(
                        height: circleSize,
                        width: circleSize,
                        decoration: BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: checkAnimation,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: iconSize,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 130.0,
                          ),
                          Text(
                            "${finalchk} Inquires Downloaded",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                fontFamily: 'Calibri'),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
