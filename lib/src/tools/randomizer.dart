import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:splash_smoke/src/tools/circle_data.dart';

/// Generates a list of random circle data sets.
///
/// This function creates a specified number of sets (`setCount`),
/// where each set contains `N` randomly generated `CircleData` objects.
///
/// Parameters:
/// - `N`: The number of `CircleData` objects in each set.
/// - `setCount`: The total number of sets to generate.
///
/// Returns:
/// A list of `setCount` lists, where each inner list contains `N`
/// randomly generated `CircleData` objects.
List<List<CircleData>> generateRandomCircleSets(int N, int setCount) {
  assert(N > 0 && setCount > 0, "N and setCount must be positive integers");

  final random = math.Random();
  List<List<CircleData>> sequences = [];
  Set<int> usedQuadrants = {};

  for (int set = 0; set < setCount; set++) {
    List<CircleData> circleSet = [];
    int quadrant;

    // Choose a random quadrant that hasn't been used
    do {
      quadrant = random.nextInt(4);
    } while (usedQuadrants.contains(quadrant) && usedQuadrants.length < 4);
    usedQuadrants.add(quadrant);

    // Generate the main circle for this set
    Offset mainPosition = _getRandomPositionInQuadrant(quadrant, random);
    circleSet.add(_generateCircleData('0', mainPosition, random));

    // Generate satellite circles
    for (int i = 1; i < N; i++) {
      Offset satellitePosition =
          _getNearbySatellitePosition(mainPosition, random);
      circleSet
          .add(_generateCircleData(i.toString(), satellitePosition, random));
    }

    sequences.add(circleSet);
  }

  return sequences;
}

Offset _getRandomPositionInQuadrant(int quadrant, math.Random random) {
  double x, y;
  switch (quadrant) {
    case 0: // Top-left
      x = random.nextDouble() * 0.5;
      y = random.nextDouble() * 0.5;
      break;
    case 1: // Top-right
      x = 0.5 + random.nextDouble() * 0.5;
      y = random.nextDouble() * 0.5;
      break;
    case 2: // Bottom-left
      x = random.nextDouble() * 0.5;
      y = 0.5 + random.nextDouble() * 0.5;
      break;
    case 3: // Bottom-right
      x = 0.5 + random.nextDouble() * 0.5;
      y = 0.5 + random.nextDouble() * 0.5;
      break;
    default:
      throw ArgumentError('Invalid quadrant');
  }
  return Offset(x, y);
}

/// Generates a nearby satellite position relative to a given main position.
///
/// This function calculates a random position near the specified `mainPosition`
/// within a certain spread. The spread is controlled by the `distance` value,
/// which is a random value between 0 and 0.5. The resulting position is clamped
/// to ensure it stays within the bounds of (0.0, 1.0) for both x and y coordinates.
///
/// - Parameters:
///   - mainPosition: The main position around which the satellite position is generated.
///   - random: An instance of `math.Random` used to generate random values for angle and distance.
///
/// - Returns: A new `Offset` representing the nearby satellite position.
Offset _getNearbySatellitePosition(Offset mainPosition, math.Random random) {
  double angle = random.nextDouble() * 2 * math.pi;
  double distance =
      random.nextDouble() * 0.5; // Adjust this value to control spread
  double x = mainPosition.dx + distance * math.cos(angle);
  double y = mainPosition.dy + distance * math.sin(angle);
  return Offset(x.clamp(0.0, 1.0), y.clamp(0.0, 1.0));
}

/// Generates a `CircleData` object with random properties.
///
/// This function creates a `CircleData` instance with the following properties:
/// - A unique identifier (`id`) provided as a parameter.
/// - A normalized position (`normalizedPosition`) based on the given `Offset`.
/// - A random radius between 30 and 130.
/// - A random color with full opacity.
///
/// Parameters:
/// - `id`: A `String` representing the unique identifier for the circle.
/// - `position`: An `Offset` representing the normalized position of the circle.
/// - `random`: A `math.Random` instance used to generate random values.
///
/// Returns:
/// A `CircleData` object with the generated properties.
CircleData _generateCircleData(String id, Offset position, math.Random random) {
  return CircleData(
    id: id,
    normalizedPosition: position,
    radius: random.nextDouble() * 100 + 30, // Random radius between 10 and 40
    color: Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    ),
  );
}
