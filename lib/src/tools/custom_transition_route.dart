import 'package:flutter/widgets.dart';
import 'package:splash_smoke/transition_type.dart';

/// A custom page route that allows specifying a transition type, duration,
/// reverse duration, and additional route information.
///
/// This class extends [PageRouteBuilder] to provide a customizable transition
/// animation for navigating between pages.
///
/// - [child]: The widget to display as the content of the route.
/// - [transitionType]: The type of transition animation to use.
/// - [duration]: The duration of the forward transition animation.
/// - [reverseDuration]: The duration of the reverse transition animation.
/// - [routeName]: An optional name for the route, useful for debugging or
///   analytics purposes.
/// - [arguments]: Optional arguments to pass to the route.
class CustomTransitionRoute extends PageRouteBuilder {
  final Widget child;
  final TransitionType transitionType;
  final Duration duration;
  final Duration reverseDuration;
  final String? routeName;
  final Object? arguments;

  CustomTransitionRoute({
    required this.child,
    this.transitionType = TransitionType.fade,
    this.duration = const Duration(milliseconds: 600),
    this.reverseDuration = const Duration(milliseconds: 600),
    this.routeName,
    this.arguments,
  }) : super(
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          pageBuilder: (context, animation, secondaryAnimation) => child,
          settings: RouteSettings(name: routeName, arguments: arguments),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            switch (transitionType) {
              case TransitionType.leftToRight:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              case TransitionType.rightToLeft:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              case TransitionType.topToBottom:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              case TransitionType.bottomToTop:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              case TransitionType.fade:
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              case TransitionType.scale:
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              case TransitionType.rotate:
                return RotationTransition(
                  turns: animation,
                  child: child,
                );
            }
          },
        );
}
