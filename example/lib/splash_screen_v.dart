import 'package:example/description.dart';
import 'package:flutter/material.dart';
import 'package:splash_smoke/splash_smoke.dart';

class SplashScreenV extends StatelessWidget {
  const SplashScreenV({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SplashSmoke(
      duration: const Duration(seconds: 6),
      nextPage: const Description(),
      rotatingLodingWidget: Image.asset(
        'assets/bottom_logo.png',
        width: 35,
        height: 35,
        color: Colors.white,
      ),
      backgroundColor: Colors.deepPurpleAccent,
      transitionType: TransitionType.rightToLeft,
      sigmaX: 10,
      sigmaY: 10,
      effectColor: Colors.white,
      child: SizedBox(
        height: 200,
        width: size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Image.asset("assets/vote2.png"),
        ),
      ),
    );
  }
}
