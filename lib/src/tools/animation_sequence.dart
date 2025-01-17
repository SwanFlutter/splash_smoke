import 'package:splash_smoke/src/tools/circle_data.dart';

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
