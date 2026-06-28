import 'package:flutter/material.dart';

import 'go_transition.dart';
import 'go_transition_settings.dart';
import 'modifiers.dart';
import 'transitions.dart';

mixin GoTransitions {
  static const none = GoTransition();
  static const theme = ThemeGoTransition();
  static const invisible = GoTransition(builder: _invisible);
  static const fade = FadeGoTransition();
  static const rotate = RotateGoTransition();
  static const scale = ScaleGoTransition();
  static const size = SizeGoTransition();
  static const slide = SlideGoTransition();
  static const slideFade = SlideFadeGoTransition();
  static const fadeScale = FadeScaleGoTransition();
  static const fadeThrough = FadeThroughGoTransition();
  static const sharedAxisHorizontal = SharedAxisHorizontalGoTransition();
  static const sharedAxisVertical = SharedAxisVerticalGoTransition();
  static const sharedAxisScale = SharedAxisScaleGoTransition();
  static const parallax = ParallaxGoTransition();
  static const blur = BlurGoTransition();
  static const containerTransform = ContainerTransformGoTransition();
  static const circularReveal = CircularRevealGoTransition();
  static const wipe = WipeGoTransition();
  static const curtain = CurtainGoTransition();
  static const horizontalFlip = HorizontalFlipGoTransition();
  static const verticalFlip = VerticalFlipGoTransition();
  static const fadeUpwards = FadeUpwardsGoTransition();
  static const openUpwards = OpenUpwardsGoTransition();
  static const zoom = ZoomGoTransition();
  static const cupertino = GoCupertinoPage();
  static const material = GoMaterialPage();
  static const material3 = ZoomGoTransition();
  static const macos = GoCupertinoPage();
  static const adaptive = ThemeGoTransition();

  /// Syntax-sugar for building [theme] with [fullscreenDialog] set to `true`.
  static final fullscreenDialog = GoTransitions.theme.build(
    settings: const GoTransitionSettings(fullscreenDialog: true),
  );

  /// Syntax-sugar for building [cupertino] with [fullscreenDialog] set to `true`.
  static final cupertinoFullscreenDialog = GoTransitions.cupertino.build(
    settings: const GoTransitionSettings(fullscreenDialog: true),
  );

  /// Syntax-sugar for building [RawDialogRoute] like transitions.
  static final dialog = GoTransitions.fade.buildPopup();

  /// Syntax-sugar for building scale/fade dialog transitions.
  static final centerDialogScaleFade = GoTransitions.fadeScale.buildPopup();

  /// Syntax-sugar for building [ModalBottomSheetRoute] like transitions.
  static final bottomSheet = GoTransitions.slide.toTop.buildPopup();

  /// Syntax-sugar for bottom sheet transitions with a discoverable name.
  static final bottomSheetDrag = GoTransitions.bottomSheet;

  /// Syntax-sugar for building side sheet transitions.
  static final sideSheet = GoTransitions.slide.toLeft.buildPopup();

  /// Syntax-sugar for Cupertino-style sheet transitions.
  static final cupertinoSheet = GoTransitions.slide.toTop.withFade.buildPopup();
}

Widget _invisible(
  PageRoute route,
  BuildContext context,
  Animation<double> a1,
  Animation<double> a2,
  Widget child,
) {
  return Visibility(visible: a1.value == 1.0, child: child);
}
