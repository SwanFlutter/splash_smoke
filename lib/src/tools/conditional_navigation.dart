import 'package:flutter/material.dart';

/// A class that facilitates conditional navigation between two pages based on a specified condition.
///
/// The `ConditionalNavigations` class evaluates a boolean condition and navigates to either
/// the `truePage` or the `falsePage` depending on the result of the condition.
///
/// - [condition]: A function that returns a boolean value. If `true`, navigation will proceed
///   to the `truePage`. Otherwise, it will navigate to the `falsePage`.
/// - [truePage]: The widget to navigate to if the condition evaluates to `true`.
/// - [falsePage]: The widget to navigate to if the condition evaluates to `false`.
class ConditionalNavigations {
  final bool Function() condition;
  final Widget truePage;
  final Widget falsePage;

  ConditionalNavigations({
    required this.condition,
    required this.truePage,
    required this.falsePage,
  });

  Widget evaluate() {
    return condition() ? truePage : falsePage;
  }
}
