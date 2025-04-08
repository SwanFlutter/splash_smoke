// ignore_for_file: use_build_context_synchronously, dead_code, must_be_immutable, unnecessary_null_comparison

library;

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splash_smoke/src/tools/animated_circles.dart';
import 'package:splash_smoke/src/tools/animation_sequence.dart';
import 'package:splash_smoke/src/tools/circle_data.dart';
import 'package:splash_smoke/src/tools/conditional_navigation.dart';
import 'package:splash_smoke/src/tools/custom_transition_route.dart';
import 'package:splash_smoke/transition_type.dart';

export 'package:splash_smoke/src/tools/conditional_navigation.dart';
export 'package:splash_smoke/transition_type.dart';

/// A widget that displays a splash screen with a smoke effect before navigating
/// to the next page or performing conditional navigation.
///
/// The `SplashSmoke` widget provides a customizable splash screen with various
/// visual effects and navigation options.
///
/// ### Parameters:
///
/// - `nextPage`:
///   The widget to navigate to after the splash screen. This is required unless
///   `conditionalNavigation` is provided.
///
/// - `child`:
///   The main content of the splash screen.
///
/// - `transitionType`:
///   The type of transition to use when navigating to the next page. Defaults to
///   `TransitionType.fade`.
///
/// - `arguments`:
///   Optional arguments to pass to the next page during navigation.
///
/// - `routeName`:
///   The name of the route to navigate to. This is optional.
///
/// - `backgroundColor`:
///   The background color of the splash screen. Defaults to `Colors.black`.
///
/// - `effectColor`:
///   The color of the smoke effect. Defaults to `Color.fromRGBO(176, 176, 176, 1)`.
///
/// - `duration`:
///   The duration of the splash screen. Defaults to `Duration(seconds: 8)`.
///
/// - `routeDuration`:
///   The duration of the transition to the next page. Defaults to `Duration(seconds: 1)`.
///
/// - `durationColorEffect`:
///   The duration of the color effect animation. Defaults to `Duration(seconds: 1)`.
///
/// - `rotatingLodingWidget`:
///   An optional widget to display a rotating loading animation during the splash screen.
///
/// - `sigmaX`:
///   The horizontal blur intensity for the smoke effect. Defaults to `100`.
///
/// - `sigmaY`:
///   The vertical blur intensity for the smoke effect. Defaults to `100`.
///
/// - `curve`:
///   The animation curve for the transition. Defaults to `Curves.ease`.
///
/// - `conditionalNavigation`:
///   An optional parameter for conditional navigation logic. If provided, it
///   overrides the `nextPage` parameter.
///
/// ### Assertions:
///
/// - Either `nextPage` or `conditionalNavigation` must be provided. If neither
///   is provided, an assertion error will be thrown.
///
/// This widget is highly customizable and can be used to create visually
/// appealing splash screens with smooth transitions and effects.
class SplashSmoke extends StatefulWidget {
  final Widget nextPage;
  final TransitionType transitionType;
  final Object? arguments;
  final String? routeName;
  final Color backgroundColor;
  final Color effectColor;
  final Duration duration;
  final Duration routeDuration;
  final Duration durationColorEffect;
  final Widget? rotatingLodingWidget;
  final double sigmaX;
  final double sigmaY;
  Curve curve;
  // Conditional navigation properties
  final ConditionalNavigation? conditionalNavigation;
  final Widget child;
  SplashSmoke({
    super.key,
    required this.nextPage,
    required this.child,
    this.transitionType = TransitionType.fade,
    this.arguments,
    this.routeName,
    this.backgroundColor = Colors.black,
    this.effectColor = const Color.fromRGBO(176, 176, 176, 1),
    this.duration = const Duration(seconds: 8),
    this.routeDuration = const Duration(seconds: 1),
    this.durationColorEffect = const Duration(seconds: 1),
    this.sigmaX = 100,
    this.sigmaY = 100,
    this.rotatingLodingWidget,
    this.curve = Curves.ease,
    this.conditionalNavigation,
  }) : assert(nextPage != null || conditionalNavigation != null,
            'Either nextPage or conditionalNavigation must be provided');

  @override
  State<SplashSmoke> createState() => _SplashSmokeState();
}

class _SplashSmokeState extends State<SplashSmoke> with WidgetsBindingObserver {
  late Timer _navigationTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _navigationTimer = Timer(widget.duration, _navigateToNextPage);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    enterFullScreen();
  }

  void _navigateToNextPage() {
    if (mounted) {
      Widget destinationPage;

      // Determine which page to navigate to
      if (widget.conditionalNavigation != null) {
        destinationPage = widget.conditionalNavigation!.evaluate();
      } else {
        destinationPage = widget.nextPage;
      }

      Navigator.pushReplacement(
        context,
        CustomTransitionRoute(
          child: destinationPage,
          transitionType: widget.transitionType,
          duration: widget.routeDuration,
          reverseDuration: widget.routeDuration,
          arguments: widget.arguments,
          routeName: widget.routeName,
        ),
      );
    }
  }

  @override
  void dispose() {
    _navigationTimer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    exitFullScreen();
    super.dispose();
  }

  void enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BlurredCircle(
          splashSmoke: widget,
        ),
      ),
    );
  }
}

class BlurredCircle extends StatelessWidget {
  final SplashSmoke splashSmoke;

  const BlurredCircle({
    super.key,
    required this.splashSmoke,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<_StartScreenState> startScreenKey = GlobalKey();
    bool isDev = false;
    var manualSequence = AnimationSequence(
      sequences: [
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.red : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.blue : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.green : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.yellow : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.orange : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.purple : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.cyan : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.indigo : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(.83, .93),
            radius: 80,
            color: isDev ? Colors.red : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.94, .80),
            radius: 70,
            color: isDev ? Colors.blue : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(.6, .97),
            radius: 60,
            color: isDev ? Colors.green : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(.94, .68),
            radius: 40,
            color: isDev ? Colors.yellow : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(0.9, .6),
            radius: 30,
            color: isDev ? Colors.orange : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(0.75, 0.70),
            radius: 40,
            color: isDev ? Colors.purple : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(.4, .97),
            radius: 40,
            color: isDev ? Colors.cyan : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(.3, .97),
            radius: 20,
            color: isDev ? Colors.indigo : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(0.45, .47),
            radius: 30,
            color: isDev ? Colors.red : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.28, .56),
            radius: 30,
            color: isDev ? Colors.blue : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(.17, .57),
            radius: 30,
            color: isDev ? Colors.green : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(.6, .4),
            radius: 20,
            color: isDev ? Colors.yellow : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(.07, .7),
            radius: 70,
            color: isDev ? Colors.orange : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(0.35, 0.590),
            radius: 25,
            color: isDev ? Colors.purple : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(.4, .55),
            radius: 20,
            color: isDev ? Colors.cyan : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(.25, .6),
            radius: 20,
            color: isDev ? Colors.indigo : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(0.45, .35),
            radius: 40,
            color: isDev ? Colors.red : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.36, .16),
            radius: 15,
            color: isDev ? Colors.blue : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(.30, .4),
            radius: 10,
            color: isDev ? Colors.green : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(.6, .4),
            radius: 20,
            color: isDev ? Colors.yellow : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(.15, .075),
            radius: 90,
            color: isDev ? Colors.orange : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(0.42, 0.2),
            radius: 25,
            color: isDev ? Colors.purple : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(.15, .26),
            radius: 120,
            color: isDev ? Colors.cyan : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(.48, .41),
            radius: 15,
            color: isDev ? Colors.indigo : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(0.0, .0),
            radius: 20,
            color: isDev ? Colors.red : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.25, .10),
            radius: 25,
            color: isDev ? Colors.blue : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(.45, .06),
            radius: 20,
            color: isDev ? Colors.green : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(.025, .025),
            radius: 80,
            color: isDev ? Colors.yellow : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(.15, .015),
            radius: 20,
            color: isDev ? Colors.orange : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(0.25, 0.015),
            radius: 50,
            color: isDev ? Colors.purple : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(.45, .0),
            radius: 30,
            color: isDev ? Colors.cyan : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(.38, .0),
            radius: 35,
            color: isDev ? Colors.indigo : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(1, .0),
            radius: 20,
            color: isDev ? Colors.red : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.955, .125),
            radius: 80,
            color: isDev ? Colors.blue : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(.79, .080),
            radius: 15,
            color: isDev ? Colors.green : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(.725, .025),
            radius: 20,
            color: isDev ? Colors.yellow : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(.955, .015),
            radius: 80,
            color: isDev ? Colors.orange : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(.725, .050),
            radius: 15,
            color: isDev ? Colors.purple : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(.82, .10),
            radius: 10,
            color: isDev ? Colors.cyan : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(.725, .080),
            radius: 15,
            color: isDev ? Colors.indigo : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(1, .5),
            radius: 20,
            color: isDev ? Colors.red : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.955, .125),
            radius: 80,
            color: isDev ? Colors.blue : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(1, .6),
            radius: 35,
            color: isDev ? Colors.green : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(1, .30),
            radius: 80,
            color: isDev ? Colors.yellow : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(1, .7),
            radius: 50,
            color: isDev ? Colors.orange : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(1, .9),
            radius: 70,
            color: isDev ? Colors.purple : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(1, .5),
            radius: 70,
            color: isDev ? Colors.cyan : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
              id: '8',
              normalizedPosition: const Offset(1, .40),
              radius: 20,
              color: isDev
                  ? Colors.indigo
                  : splashSmoke
                      .effectColor), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(1, 1),
            radius: 20,
            color: isDev ? Colors.red : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.8, .8),
            radius: 110,
            color: isDev ? Colors.blue : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(1, .6),
            radius: 35,
            color: isDev ? Colors.green : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(1, .30),
            radius: 80,
            color: isDev ? Colors.yellow : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(.45, 1),
            radius: 50,
            color: isDev ? Colors.orange : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(.8, .98),
            radius: 70,
            color: isDev ? Colors.purple : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(1, .5),
            radius: 100,
            color: isDev ? Colors.cyan : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(1, .80),
            radius: 120,
            color: isDev ? Colors.indigo : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
      ],
      stepDuration: splashSmoke.durationColorEffect,
      onSequenceChange: (int index) {
        debugPrint("New sequence started: $index");
        // Perform any other actions you need here
        //switch from 0 to 7
        if (index == 0) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: 0, textOpacity: 0);
        } else if (index == 1) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: 1, textOpacity: 1);
        } else if (index == 2) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .7, textOpacity: .1);
        } else if (index == 3) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .1, textOpacity: .1);
        } else if (index == 4) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .1, textOpacity: .1);
        } else if (index == 5) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .6, textOpacity: .1);
        } else if (index == 6) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: 1, textOpacity: 1);
        } else if (index == 7) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .2, textOpacity: .6);
        }
      },
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: splashSmoke.backgroundColor,
      child: Stack(
        children: [
          AnimatedCircles(sequence: manualSequence), //sequence
          BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: splashSmoke.sigmaX,
              sigmaY: splashSmoke.sigmaY,
            ),
            child: Container(color: Colors.transparent),
          ),
          StartScreen(key: startScreenKey, widget: splashSmoke),
        ],
      ),
    );
  }
}

class StartScreen extends StatefulWidget {
  final SplashSmoke widget;
  const StartScreen({super.key, required this.widget});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;

  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(_logoController);
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(_textController);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void updateOpacities(
      {required double logoOpacity, required double textOpacity}) {
    setState(() {
      _logoOpacity = Tween<double>(begin: _logoOpacity.value, end: logoOpacity)
          .animate(CurvedAnimation(
              parent: _logoController, curve: widget.widget.curve));
      _textOpacity = Tween<double>(begin: _textOpacity.value, end: textOpacity)
          .animate(CurvedAnimation(
              parent: _textController, curve: widget.widget.curve));

      // _logoOpacity = Tween<double>(begin: _logoOpacity.value, end: logoOpacity)
      //     .animate(_logoController);
      // _textOpacity = Tween<double>(begin: _textOpacity.value, end: textOpacity)
      //     .animate(_textController);
    });
    _logoController.forward(from: 0);
    _textController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Main logo at the top center
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _logoOpacity,
              child: Center(
                child: widget.widget.child,
              ),
            ),
          ),
          // Rotating widget and text at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: FadeTransition(
              opacity: _textOpacity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RotationTransition(
                    turns: _rotateController,
                    child: widget.widget.rotatingLodingWidget ??
                        Image.asset(
                          'assets/bottom_logo.png',
                          width: 35,
                          height: 35,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/** // ignore_for_file: use_build_context_synchronously, dead_code, must_be_immutable

library;

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splash_smoke/src/tools/animated_circles.dart';
import 'package:splash_smoke/src/tools/animation_sequence.dart';
import 'package:splash_smoke/src/tools/circle_data.dart';
import 'package:splash_smoke/src/tools/custom_transition_route.dart';
import 'package:splash_smoke/transition_type.dart';

export 'package:splash_smoke/transition_type.dart';

class SplashSmoke extends StatefulWidget {
  final Widget nextPage;
  final TransitionType transitionType;
  final Object? arguments;
  final String? routeName;
  final Color backgroundColor;
  final Color effectColor;
  final Duration duration;
  final Duration routeDuration;
  final Duration durationColorEffect;
  final Widget? rotatingLodingWidget;
  final double sigmaX;
  final double sigmaY;
  Curve curve;
  final Widget child;
  SplashSmoke({
    super.key,
    required this.nextPage,
    required this.child,
    this.transitionType = TransitionType.fade,
    this.arguments,
    this.routeName,
    this.backgroundColor = Colors.black,
    this.effectColor = const Color.fromRGBO(176, 176, 176, 1),
    this.duration = const Duration(seconds: 8),
    this.routeDuration = const Duration(seconds: 1),
    this.durationColorEffect = const Duration(seconds: 1),
    this.sigmaX = 100,
    this.sigmaY = 100,
    this.rotatingLodingWidget,
    this.curve = Curves.ease,
  });

  @override
  State<SplashSmoke> createState() => _SplashSmokeState();
}

class _SplashSmokeState extends State<SplashSmoke> with WidgetsBindingObserver {
  late Timer _navigationTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _navigationTimer = Timer(widget.duration, _navigateToNextPage);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    enterFullScreen();
  }

  void _navigateToNextPage() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        CustomTransitionRoute(
          child: widget.nextPage,
          transitionType: widget.transitionType,
          duration: widget.routeDuration,
          reverseDuration: widget.routeDuration,
          arguments: widget.arguments,
          routeName: widget.routeName,
        ),
      );
    }
  }

  @override
  void dispose() {
    _navigationTimer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    exitFullScreen();
    super.dispose();
  }

  void enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BlurredCircle(
          splashSmoke: widget,
        ),
      ),
    );
  }
}

class BlurredCircle extends StatelessWidget {
  final SplashSmoke splashSmoke;

  const BlurredCircle({
    super.key,
    required this.splashSmoke,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<_StartScreenState> startScreenKey = GlobalKey();
    bool isDev = false;
    var manualSequence = AnimationSequence(
      sequences: [
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.red : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.blue : splashSmoke.effectColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        
      ],
      stepDuration: splashSmoke.durationColorEffect,
      onSequenceChange: (int index) {
        debugPrint("New sequence started: $index");
        // Perform any other actions you need here
        //switch from 0 to 7
        if (index == 0) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: 0, textOpacity: 0);
        } else if (index == 1) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: 1, textOpacity: 1);
        } else if (index == 2) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .7, textOpacity: .1);
        } else if (index == 3) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .1, textOpacity: .1);
        } else if (index == 4) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .1, textOpacity: .1);
        } else if (index == 5) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .6, textOpacity: .1);
        } else if (index == 6) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: 1, textOpacity: 1);
        } else if (index == 7) {
          startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .2, textOpacity: .6);
        }
      },
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: splashSmoke.backgroundColor,
      child: Stack(
        children: [
          AnimatedCircles(sequence: manualSequence), //sequence
          BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: splashSmoke.sigmaX,
              sigmaY: splashSmoke.sigmaY,
            ),
            child: Container(color: Colors.transparent),
          ),
          StartScreen(key: startScreenKey, widget: splashSmoke),
        ],
      ),
    );
  }
}

class StartScreen extends StatefulWidget {
  final SplashSmoke widget;
  const StartScreen({super.key, required this.widget});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;

  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(_logoController);
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(_textController);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void updateOpacities(
      {required double logoOpacity, required double textOpacity}) {
    setState(() {
      _logoOpacity = Tween<double>(begin: _logoOpacity.value, end: logoOpacity)
          .animate(CurvedAnimation(
              parent: _logoController, curve: widget.widget.curve));
      _textOpacity = Tween<double>(begin: _textOpacity.value, end: textOpacity)
          .animate(CurvedAnimation(
              parent: _textController, curve: widget.widget.curve));

      // _logoOpacity = Tween<double>(begin: _logoOpacity.value, end: logoOpacity)
      //     .animate(_logoController);
      // _textOpacity = Tween<double>(begin: _textOpacity.value, end: textOpacity)
      //     .animate(_textController);
    });
    _logoController.forward(from: 0);
    _textController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Main logo at the top center
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _logoOpacity,
              child: Center(
                child: widget.widget.child,
              ),
            ),
          ),
          // Rotating widget and text at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: FadeTransition(
              opacity: _textOpacity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RotationTransition(
                    turns: _rotateController,
                    child: widget.widget.rotatingLodingWidget ??
                        Image.asset(
                          'assets/bottom_logo.png',
                          width: 35,
                          height: 35,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
