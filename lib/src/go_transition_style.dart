import 'package:flutter/cupertino.dart';

import 'go_transition.dart';

@immutable
class GoTransitionStyle {
  const GoTransitionStyle({
    this.applyOnPrevious = false,
    this.curve,
    this.reverseCurve,
    this.alignment,
    this.offset,
    this.secondaryOffset,
    this.axis,
    this.axisAlignment,
    this.beginScale,
    this.endScale,
    this.beginOpacity,
    this.endOpacity,
    this.blur,
    this.rotationTurns,
  });

  /// Whether to apply the transition on the previous [Route].
  ///
  /// Requires [GoTransition.observer] to work.
  final bool applyOnPrevious;

  /// The transition [MatrixTransition.alignment].
  final Alignment? alignment;

  /// The transition [SlideTransition.position] begin [Offset].
  final Offset? offset;

  /// The previous route [SlideTransition.position] end [Offset].
  final Offset? secondaryOffset;

  /// The transition [SizeTransition.axis].
  final Axis? axis;

  /// The transition [SizeTransition.alignment].
  final double? axisAlignment;

  /// The transition [Curve] to use.
  final Curve? curve;

  /// The transition reverse [Curve] to use. If null, uses [curve].
  final Curve? reverseCurve;

  /// The transition scale begin value.
  final double? beginScale;

  /// The transition scale end value.
  final double? endScale;

  /// The transition opacity begin value.
  final double? beginOpacity;

  /// The transition opacity end value.
  final double? endOpacity;

  /// The transition blur sigma.
  final double? blur;

  /// The number of turns used by [RotationTransition].
  final double? rotationTurns;

  GoTransitionStyle copyWith({
    bool? applyOnPrevious,
    Curve? curve,
    Curve? reverseCurve,
    Alignment? alignment,
    Offset? offset,
    Offset? secondaryOffset,
    Axis? axis,
    double? axisAlignment,
    double? beginScale,
    double? endScale,
    double? beginOpacity,
    double? endOpacity,
    double? blur,
    double? rotationTurns,
  }) {
    return GoTransitionStyle(
      applyOnPrevious: applyOnPrevious ?? this.applyOnPrevious,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,
      alignment: alignment ?? this.alignment,
      offset: offset ?? this.offset,
      secondaryOffset: secondaryOffset ?? this.secondaryOffset,
      axis: axis ?? this.axis,
      axisAlignment: axisAlignment ?? this.axisAlignment,
      beginScale: beginScale ?? this.beginScale,
      endScale: endScale ?? this.endScale,
      beginOpacity: beginOpacity ?? this.beginOpacity,
      endOpacity: endOpacity ?? this.endOpacity,
      blur: blur ?? this.blur,
      rotationTurns: rotationTurns ?? this.rotationTurns,
    );
  }
}
