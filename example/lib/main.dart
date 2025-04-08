import 'package:flutter/material.dart';
import 'package:splash_smoke/splash_smoke.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreenV(),
    );
  }
}

class Description extends StatelessWidget {
  const Description({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Description'),
      ),
      body: const Center(
        child: Text('Description'),
      ),
    );
  }
}

class SplashScreenV extends StatelessWidget {
  const SplashScreenV({super.key});

  // Function to check user login status
  bool isUserLoggedIn() {
    // Implement your login status check logic here
    // For example:
    // return AuthService.instance.isLoggedIn;
    return true; // For example, assuming user is not logged in
  }

  @override
  Widget build(BuildContext context) {
    return SplashSmoke(
      // Remove this line since we're using conditionalNavigation
      // nextPage: const HomePage(),
      duration: const Duration(seconds: 6),
      conditionalNavigation: ConditionalNavigations(
        condition: () => isUserLoggedIn(),
        truePage: const HomePage(), // Page to navigate if user is logged in
        falsePage:
            const Description(), // Page to navigate if user is not logged in
      ),
      // Use a simple placeholder widget instead of an asset
      rotatingLodingWidget: const Icon(
        Icons.hourglass_bottom,
        size: 35,
        color: Colors.white,
      ),
      backgroundColor: Colors.deepPurpleAccent,
      transitionType: TransitionType.rightToLeft,
      sigmaX: 10,
      sigmaY: 10,
      effectColor: Colors.white,
      nextPage:
          const HomePage(), // This will be ignored due to conditionalNavigation
      child: SizedBox(
        height: 200,
        width: MediaQuery.of(context).size.width * 0.9,
        // Use a simple logo widget instead of an asset
        child: const Center(
          child: FlutterLogo(size: 150),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: const Center(
        child: Text('HomePage'),
      ),
    );
  }
}
