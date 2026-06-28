import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'go_transition.dart';

extension GoTransitionModifiers on GoTransition {
  /// Returns a new [GoTransition] with the given [style] properties.
  GoTransition withStyle({
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
    return copyWith(
      style: style.copyWith(
        curve: curve,
        reverseCurve: reverseCurve,
        alignment: alignment,
        offset: offset,
        secondaryOffset: secondaryOffset,
        axis: axis,
        axisAlignment: axisAlignment,
        beginScale: beginScale,
        endScale: endScale,
        beginOpacity: beginOpacity,
        endOpacity: endOpacity,
        blur: blur,
        rotationTurns: rotationTurns,
      ),
    );
  }

  /// Returns a new [GoTransition] with the given [settings] properties.
  GoTransition withSettings({
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
    Duration? duration,
    Duration? reverseDuration,
    bool? allowSnapshotting,
    bool? maintainState,
    bool? fullscreenDialog,
    bool? opaque,
    bool? barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    CanTransition? canTransitionTo,
    CanTransition? canTransitionFrom,
  }) {
    return copyWith(
      settings: settings.copyWith(
        key: key,
        name: name,
        arguments: arguments,
        restorationId: restorationId,
        duration: duration,
        reverseDuration: reverseDuration,
        allowSnapshotting: allowSnapshotting,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        canTransitionTo: canTransitionTo,
        canTransitionFrom: canTransitionFrom,
      ),
    );
  }

  /// Returns a new [GoTransition] with transition applied on the previous page.
  ///
  /// You must set [GoTransition.observer] to use this feature.
  GoTransition get onPrevious {
    return copyWith(
      style: style.copyWith(applyOnPrevious: true),
      builder: (route, context, animation, secondaryAnimation, child) {
        final previousChild = GoTransition.previousChildOf(context);
        if (previousChild == null) return child;

        return Stack(
          alignment: Alignment.center,
          children: [
            child,
            builder(
              route,
              context,
              animation,
              secondaryAnimation,
              previousChild,
            ),
          ],
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [FadeTransition].
  GoTransition get withFade {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final go = GoTransition.styleOf(context);
        final begin = style.beginOpacity ?? go?.beginOpacity ?? 0.0;
        final end = style.endOpacity ?? go?.endOpacity ?? 1.0;

        return FadeTransition(
          opacity: Tween<double>(begin: begin, end: end).animate(animation),
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [ScaleTransition].
  GoTransition get withScale {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final go = GoTransition.styleOf(context);
        final alignment = style.alignment ?? go?.alignment;
        final begin = style.beginScale ?? go?.beginScale ?? 0.0;
        final end = style.endScale ?? go?.endScale ?? 1.0;

        return ScaleTransition(
          alignment: alignment ?? Alignment.center,
          scale: Tween<double>(begin: begin, end: end).animate(animation),
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [SizeTransition].
  GoTransition get withSize {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final go = GoTransition.styleOf(context);

        final axis = style.axis ?? go?.axis ?? Axis.vertical;
        final axisAlign = style.axisAlignment ?? go?.axisAlignment ?? 0.0;
        return Align(
          alignment: style.alignment ?? go?.alignment ?? Alignment.center,
          child: SizeTransition(
            sizeFactor: animation,
            axis: axis,
            alignment: axis == Axis.vertical
                ? Alignment(0, axisAlign)
                : Alignment(axisAlign, 0),
            child: builder(
              route,
              context,
              animation,
              secondaryAnimation,
              child,
            ),
          ),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [SlideTransition].
  GoTransition get withSlide {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final go = GoTransition.styleOf(context);

        return SlideTransition(
          position: Tween<Offset>(
            begin: style.offset ?? go?.offset ?? Offset.zero,
            end: Offset.zero,
          ).animate(animation),
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] that also slides the previous route.
  GoTransition get withSecondarySlide {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final go = GoTransition.styleOf(context);

        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: style.secondaryOffset ?? go?.secondaryOffset ?? Offset.zero,
          ).animate(secondaryAnimation),
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [RotationTransition].
  GoTransition get withRotation {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final go = GoTransition.styleOf(context);

        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: style.rotationTurns ?? go?.rotationTurns ?? 1.0,
          ).animate(animation),
          alignment: style.alignment ?? go?.alignment ?? Alignment.center,
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with an [ImageFiltered] blur.
  GoTransition get withBlur {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final go = GoTransition.styleOf(context);
        final blur = style.blur ?? go?.blur ?? 12.0;

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final sigma = blur * (1 - animation.value);
            return ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: child,
            );
          },
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a fade-through Material motion pattern.
  GoTransition get withFadeThrough {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: const Interval(0.0, 0.35),
          ),
        );
        final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: const Interval(0.35, 1.0)),
        );

        return FadeTransition(
          opacity: fadeOut,
          child: FadeTransition(
            opacity: fadeIn,
            child: builder(
              route,
              context,
              animation,
              secondaryAnimation,
              child,
            ),
          ),
        );
      },
    );
  }

  /// Returns a new [GoTransition] clipped by an expanding circle.
  GoTransition get withCircularReveal {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        return ClipPath(
          clipper: _CircularRevealClipper(animation.value),
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] clipped by a directional wipe.
  GoTransition get withWipe {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final go = GoTransition.styleOf(context);

        return ClipPath(
          clipper: _WipeClipper(
            animation.value,
            style.offset ?? go?.offset ?? const Offset(1, 0),
          ),
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a horizontal 3D flip.
  GoTransition get withHorizontalFlip {
    return _withFlip(Axis.horizontal);
  }

  /// Returns a new [GoTransition] with a vertical 3D flip.
  GoTransition get withVerticalFlip {
    return _withFlip(Axis.vertical);
  }

  GoTransition _withFlip(Axis axis) {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final go = GoTransition.styleOf(context);
        final alignment = style.alignment ?? go?.alignment ?? Alignment.center;

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final angle = (1 - animation.value) * math.pi / 2;
            final transform = Matrix4.identity()..setEntry(3, 2, 0.001);
            if (axis == Axis.horizontal) {
              transform.rotateY(angle);
            } else {
              transform.rotateX(angle);
            }

            return Transform(
              transform: transform,
              alignment: alignment,
              child: child,
            );
          },
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [CupertinoPageTransition] back-gesture support.
  GoTransition get withBackGesture {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final transition = CupertinoRouteTransitionMixin.buildPageTransitions(
          route,
          context,
          animation,
          secondaryAnimation,
          builder(route, context, animation, secondaryAnimation, child),
        );

        // _CupertinoBackGestureDetector
        return (transition as dynamic).child;
      },
    );
  }

  /// Returns a [GoTransition] that animates from left to right.
  GoTransition get toLeft {
    return withStyle(
      axis: style.axis ?? Axis.horizontal,
      axisAlignment: style.axisAlignment ?? 1.0,
      offset: style.offset ?? const Offset(1, 0),
      secondaryOffset: style.secondaryOffset ?? const Offset(-0.25, 0),
      alignment: style.alignment ?? Alignment.centerRight,
    );
  }

  /// Returns a [GoTransition] that animates from right to left.
  GoTransition get toRight {
    return withStyle(
      axis: style.axis ?? Axis.horizontal,
      axisAlignment: style.axisAlignment ?? -1.0,
      offset: style.offset ?? const Offset(-1, 0),
      secondaryOffset: style.secondaryOffset ?? const Offset(0.25, 0),
      alignment: style.alignment ?? Alignment.centerLeft,
    );
  }

  /// Returns a [GoTransition] that animates from bottom to top.
  GoTransition get toTop {
    return withStyle(
      axis: style.axis ?? Axis.vertical,
      axisAlignment: style.axisAlignment ?? 1.0,
      offset: style.offset ?? const Offset(0, 1),
      secondaryOffset: style.secondaryOffset ?? const Offset(0, -0.25),
      alignment: style.alignment ?? Alignment.bottomCenter,
    );
  }

  /// Returns a [GoTransition] that animates from top to bottom.
  GoTransition get toBottom {
    return withStyle(
      axis: style.axis ?? Axis.vertical,
      axisAlignment: style.axisAlignment ?? -1.0,
      offset: style.offset ?? const Offset(0, -1),
      secondaryOffset: style.secondaryOffset ?? const Offset(0, 0.25),
      alignment: style.alignment ?? Alignment.topCenter,
    );
  }
}

class _CircularRevealClipper extends CustomClipper<Path> {
  const _CircularRevealClipper(this.progress);

  final double progress;

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.longestSide * progress;
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(_CircularRevealClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

class _WipeClipper extends CustomClipper<Path> {
  const _WipeClipper(this.progress, this.offset);

  final double progress;
  final Offset offset;

  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;

    if (offset.dx.abs() >= offset.dy.abs()) {
      final revealWidth = width * progress;
      final left = offset.dx > 0 ? width - revealWidth : 0.0;
      return Path()..addRect(Rect.fromLTWH(left, 0, revealWidth, height));
    }

    final revealHeight = height * progress;
    final top = offset.dy > 0 ? height - revealHeight : 0.0;
    return Path()..addRect(Rect.fromLTWH(0, top, width, revealHeight));
  }

  @override
  bool shouldReclip(_WipeClipper oldClipper) {
    return oldClipper.progress != progress || oldClipper.offset != offset;
  }
}

extension GoReverseAnimationExtension on Animation<double> {
  Animation<double> get reversed => drive(Tween<double>(begin: 1, end: 0));
}

extension PreviousChildContextExtension on BuildContext {
  /// Returns the child of the previous route.
  Widget? get previousChild => GoTransition.previousChildOf(this);
}
