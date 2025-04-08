import 'dart:ui';

/// A class representing data for a circle, including its unique identifier,
/// normalized position, radius, and color.
///
/// The `normalizedPosition` represents the position of the circle as a
/// normalized [Offset] where both `dx` and `dy` values must be between 0 and 1
/// (inclusive). This ensures the position is within a normalized coordinate
/// space.
///
/// The `radius` defines the size of the circle, and the `color` specifies its
/// visual appearance.
///
/// Throws an [AssertionError] if the `normalizedPosition` values are not
/// within the range of 0 to 1.
class CircleData {
  final String id;
  final Offset normalizedPosition;
  final double radius;
  final Color color;

  CircleData({
    required this.id,
    required this.normalizedPosition,
    required this.radius,
    required this.color,
  }) : assert(
            normalizedPosition.dx >= 0 &&
                normalizedPosition.dx <= 1 &&
                normalizedPosition.dy >= 0 &&
                normalizedPosition.dy <= 1,
            "Normalized position must be between 0 and 1");

  CircleData lerp(CircleData other, double t) {
    return CircleData(
      id: id,
      normalizedPosition:
          Offset.lerp(normalizedPosition, other.normalizedPosition, t)!,
      radius: lerpDouble(radius, other.radius, t)!,
      color: Color.lerp(color, other.color, t)!,
    );
  }
}
