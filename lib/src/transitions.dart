import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'go_transition.dart';
import 'go_transition_settings.dart';
import 'go_transition_style.dart';
import 'go_transitions.dart';
import 'modifiers.dart';
import 'transition_mixin.dart';

class ThemeGoTransition extends GoTransition {
  const ThemeGoTransition();

  @override
  PageRouteTransitionsBuilder get builder {
    return (route, context, animation, secondaryAnimation, child) {
      final pageTransitionsTheme = Theme.of(context).pageTransitionsTheme;

      assert(
        !pageTransitionsTheme.builders.containsValue(GoTransitions.theme),
        '\n\nYou should not set GoTransitions.theme in pageTransitionsTheme, '
        'as it will cause an infinite loop.',
      );

      return pageTransitionsTheme.buildTransitions(
        route,
        context,
        animation,
        secondaryAnimation,
        child,
      );
    };
  }

  @override
  Route createRoute(BuildContext context) {
    final platform = Theme.of(context).platform;
    final pageTransitionsTheme = Theme.of(context).pageTransitionsTheme;
    final builder = pageTransitionsTheme.builders[platform];

    if (builder is GoTransition) {
      return builder.createRoute(context);
    }

    return super.createRoute(context);
  }
}

extension on GoTransition {
  GoTransition get none => const GoTransition();
}

class FadeGoTransition extends GoTransition {
  const FadeGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.withFade.builder;
}

class RotateGoTransition extends GoTransition {
  const RotateGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.withRotation.builder;
}

class ScaleGoTransition extends GoTransition {
  const ScaleGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.withScale.builder;
}

class SizeGoTransition extends GoTransition {
  const SizeGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.withSize.builder;
}

class SlideGoTransition extends GoTransition {
  const SlideGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.withSlide.builder;
}

class SlideFadeGoTransition extends GoTransition {
  const SlideFadeGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      none.toRight.withSlide.withFade.builder;
}

class FadeScaleGoTransition extends GoTransition {
  const FadeScaleGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none
      .withStyle(beginScale: 0.92, endScale: 1.0)
      .withScale
      .withFade
      .builder;
}

class FadeThroughGoTransition extends GoTransition {
  const FadeThroughGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.withFadeThrough.builder;
}

class SharedAxisHorizontalGoTransition extends GoTransition {
  const SharedAxisHorizontalGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.toRight
      .withStyle(beginScale: 0.98, endScale: 1.0)
      .withSecondarySlide
      .withSlide
      .withFade
      .builder;
}

class SharedAxisVerticalGoTransition extends GoTransition {
  const SharedAxisVerticalGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.toTop
      .withStyle(beginScale: 0.98, endScale: 1.0)
      .withSecondarySlide
      .withSlide
      .withFade
      .builder;
}

class SharedAxisScaleGoTransition extends GoTransition {
  const SharedAxisScaleGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none
      .withStyle(beginScale: 0.85, endScale: 1.0)
      .withScale
      .withFadeThrough
      .builder;
}

class ParallaxGoTransition extends GoTransition {
  const ParallaxGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      none.toRight.withSecondarySlide.withSlide.withFade.builder;
}

class BlurGoTransition extends GoTransition {
  const BlurGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      none.withStyle(blur: 16).withBlur.withFade.builder;
}

class ContainerTransformGoTransition extends GoTransition {
  const ContainerTransformGoTransition();
  @override
  PageRouteTransitionsBuilder get builder {
    return (route, context, animation, secondaryAnimation, child) {
      final curvedChild = none
          .withStyle(beginScale: 0.92, endScale: 1.0)
          .withScale
          .withFade
          .builder(route, context, animation, secondaryAnimation, child);

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(28 * (1 - animation.value)),
            child: child,
          );
        },
        child: curvedChild,
      );
    };
  }
}

class CircularRevealGoTransition extends GoTransition {
  const CircularRevealGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.withCircularReveal.builder;
}

class WipeGoTransition extends GoTransition {
  const WipeGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.toRight.withWipe.builder;
}

class CurtainGoTransition extends GoTransition {
  const CurtainGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      none.toTop.withSize.withFade.builder;
}

class HorizontalFlipGoTransition extends GoTransition {
  const HorizontalFlipGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      none.withHorizontalFlip.withFade.builder;
}

class VerticalFlipGoTransition extends GoTransition {
  const VerticalFlipGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      none.withVerticalFlip.withFade.builder;
}

class FadeUpwardsGoTransition extends GoTransition {
  const FadeUpwardsGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      const FadeUpwardsPageTransitionsBuilder().buildTransitions;
}

class OpenUpwardsGoTransition extends GoTransition {
  const OpenUpwardsGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      const OpenUpwardsPageTransitionsBuilder().buildTransitions;
}

class ZoomGoTransition extends GoTransition {
  const ZoomGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      const ZoomPageTransitionsBuilder().buildTransitions;
}

@immutable
class GoCupertinoPage extends GoTransition implements CupertinoPage {
  const GoCupertinoPage({
    this.title,
    super.builder = CupertinoRouteTransitionMixin.buildPageTransitions<dynamic>,
    super.style,
    super.settings,
    super.child,
  });

  @override
  final String? title;

  @override
  GoCupertinoPage copyWith({
    String? title,
    PageRouteTransitionsBuilder? builder,
    GoTransitionStyle? style,
    GoTransitionSettings? settings,
    Widget? child,
  }) {
    return GoCupertinoPage(
      title: title ?? this.title,
      builder: builder ?? this.builder,
      style: style ?? this.style,
      settings: settings ?? this.settings,
      child: child ?? this.child,
    );
  }

  @override
  Route createRoute(BuildContext context) {
    return GoCupertinoPageRoute(this);
  }
}

class GoCupertinoPageRoute extends CupertinoPageRoute
    with GoPageRoute, TransitionMixin {
  GoCupertinoPageRoute(GoCupertinoPage page)
    : super(settings: page, builder: (_) => page.child);
}

class GoMaterialPage extends GoTransition implements MaterialPage {
  const GoMaterialPage({
    super.builder = _builder,
    super.style,
    super.settings,
    super.child,
  });

  /// [MaterialPageRoute.buildTransitions] builder.
  static Widget _builder(
    PageRoute route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Theme.of(context).pageTransitionsTheme.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }

  @override
  GoMaterialPage copyWith({
    PageRouteTransitionsBuilder? builder,
    GoTransitionStyle? style,
    GoTransitionSettings? settings,
    Widget? child,
  }) {
    return GoMaterialPage(
      builder: builder ?? this.builder,
      style: style ?? this.style,
      settings: settings ?? this.settings,
      child: child ?? this.child,
    );
  }

  @override
  Route createRoute(BuildContext context) {
    return GoMaterialPageRoute(this);
  }
}

class GoMaterialPageRoute extends MaterialPageRoute
    with GoPageRoute, TransitionMixin {
  GoMaterialPageRoute(GoMaterialPage page)
    : super(settings: page, builder: (_) => page.child);
}
