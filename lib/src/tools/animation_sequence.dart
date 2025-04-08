import 'package:splash_smoke/src/tools/circle_data.dart';

/// A class that represents a sequence of animations, where each sequence
/// consists of a list of `CircleData` objects.
///
/// This class allows you to define multiple animation sequences and control
/// their timing and behavior.
///
/// ### Parameters:
/// - `sequences`: A list of animation sequences, where each sequence is a list
///   of `CircleData` objects. This parameter is required.
/// - `stepDuration`: The duration of each step in the animation sequence.
///   Defaults to 1 second if not provided.
/// - `onSequenceChange`: An optional callback function that gets triggered
///   whenever the sequence changes. The callback receives the index of the
///   current sequence.
///
/// ### Properties:
/// - `length`: The total number of animation sequences.
///
/// ### Example:
/// ```dart
/// final animationSequence = AnimationSequence(
///   sequences: [
///     [CircleData(...), CircleData(...)],
///     [CircleData(...), CircleData(...)],
///   ],
///   stepDuration: Duration(milliseconds: 500),
///   onSequenceChange: (index) {
///     print('Sequence changed to: $index');
///   },
/// );
/// ```
class AnimationSequence {
  final List<List<CircleData>> sequences;
  final Duration stepDuration;
  final Function(int)? onSequenceChange;

  AnimationSequence({
    required this.sequences,
    this.stepDuration = const Duration(seconds: 1),
    this.onSequenceChange,
  });

  int get length => sequences.length;
}
