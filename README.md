
## SplashSmoke

A Flutter package to create a splash screen with a smoke effect.

## Features

![20250117_060241](https://github.com/user-attachments/assets/6647ce3c-09f4-453d-aa84-9f54a37cc2bf)


## Getting started

- Installation
  Add the dependency to your pubspec.yaml:

```yaml
dependencies:
    splash_smoke: ^0.0.3
```

Run the following command to fetch the package:

```yaml
flutter pub get
```

Import the package into your Dart file:

```yaml

import 'package:splash_smoke/splash_smoke.dart';

```

## Usage
 Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
class SplashScreenV extends StatelessWidget {
  const SplashScreenV({super.key});

  // Function to check user login status
  bool isUserLoggedIn() {
    // Implement your login status check logic here
    // For example:
    // return AuthService.instance.isLoggedIn;
    return false; // For example, assuming user is not logged in
  }

  @override
  Widget build(BuildContext context) {
    return SplashSmoke(
      duration: const Duration(seconds: 6),
      // Using conditionalNavigation instead of directly using nextPage
      conditionalNavigation: ConditionalNavigation(
        condition: () => isUserLoggedIn(),
        truePage: const HomePage(), // Page to navigate if user is logged in
        falsePage: const Description(), // Page to navigate if user is not logged in
      ),
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
        width: Get.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Image.asset("assets/vote2.png"),
        ),
      ),
    );
  }
}
```

## Additional information

If you have any issues, questions, or suggestions related to this package, please feel free to contact us at [swan.dev1993@gmail.com](mailto:swan.dev1993@gmail.com). We welcome your feedback and will do our best to address any problems or provide assistance.
For more information about this package, you can also visit our [GitHub repository](https://github.com/SwanFlutter/splash_smoke) where you can find additional resources, contribute to the package's development, and file issues or bug reports. We appreciate your contributions and feedback, and we aim to make this package as useful as possible for our users.
Thank you for using our package, and we look forward to hearing from you!

