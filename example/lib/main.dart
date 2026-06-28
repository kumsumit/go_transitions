import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';

void main() {
  runApp(const MainApp());
}

final _transitionDemos = <TransitionDemo>[
  TransitionDemo('Slide', '/slide', GoTransitions.slide.toRight),
  TransitionDemo('Slide Fade', '/slide-fade', GoTransitions.slideFade),
  TransitionDemo('Fade', '/fade', GoTransitions.fade),
  TransitionDemo('Fade Scale', '/fade-scale', GoTransitions.fadeScale),
  TransitionDemo('Fade Through', '/fade-through', GoTransitions.fadeThrough),
  TransitionDemo('Scale', '/scale', GoTransitions.scale),
  TransitionDemo('Size', '/size', GoTransitions.size.toTop),
  TransitionDemo('Rotate', '/rotate', GoTransitions.rotate),
  TransitionDemo(
    'Shared Axis Horizontal',
    '/shared-axis-horizontal',
    GoTransitions.sharedAxisHorizontal,
  ),
  TransitionDemo(
    'Shared Axis Vertical',
    '/shared-axis-vertical',
    GoTransitions.sharedAxisVertical,
  ),
  TransitionDemo(
    'Shared Axis Scale',
    '/shared-axis-scale',
    GoTransitions.sharedAxisScale,
  ),
  TransitionDemo('Parallax', '/parallax', GoTransitions.parallax),
  TransitionDemo('Blur', '/blur', GoTransitions.blur),
  TransitionDemo(
    'Container Transform',
    '/container-transform',
    GoTransitions.containerTransform,
  ),
  TransitionDemo(
    'Circular Reveal',
    '/circular-reveal',
    GoTransitions.circularReveal,
  ),
  TransitionDemo('Wipe', '/wipe', GoTransitions.wipe),
  TransitionDemo('Curtain', '/curtain', GoTransitions.curtain),
  TransitionDemo(
    'Horizontal Flip',
    '/horizontal-flip',
    GoTransitions.horizontalFlip,
  ),
  TransitionDemo('Vertical Flip', '/vertical-flip', GoTransitions.verticalFlip),
  TransitionDemo('Material 3', '/material-3', GoTransitions.material3),
  TransitionDemo('Cupertino', '/cupertino', GoTransitions.cupertino),
  TransitionDemo('Adaptive Theme', '/adaptive', GoTransitions.adaptive),
];

final _popupDemos = <PopupDemo>[
  PopupDemo(
    'Fullscreen Dialog',
    '/fullscreen-dialog',
    GoTransitions.fullscreenDialog,
  ),
  PopupDemo(
    'Cupertino Fullscreen Dialog',
    '/cupertino-fullscreen-dialog',
    GoTransitions.cupertinoFullscreenDialog,
  ),
  PopupDemo('Dialog', '/dialog', GoTransitions.dialog),
  PopupDemo(
    'Scale Fade Dialog',
    '/scale-fade-dialog',
    GoTransitions.centerDialogScaleFade,
  ),
  PopupDemo('Bottom Sheet', '/bottom-sheet', GoTransitions.bottomSheet),
  PopupDemo(
    'Bottom Sheet Drag',
    '/bottom-sheet-drag',
    GoTransitions.bottomSheetDrag,
  ),
  PopupDemo('Side Sheet', '/side-sheet', GoTransitions.sideSheet),
  PopupDemo(
    'Cupertino Sheet',
    '/cupertino-sheet',
    GoTransitions.cupertinoSheet,
  ),
];

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    GoTransition.defaultCurve = Curves.easeInOutCubic;
    GoTransition.defaultDuration = const Duration(milliseconds: 500);

    return MaterialApp.router(
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: GoTransitions.material3,
            TargetPlatform.iOS: GoTransitions.cupertino,
            TargetPlatform.macOS: GoTransitions.macos,
          },
        ),
      ),
      routerConfig: GoRouter(
        observers: [GoTransition.observer],
        routes: [
          ShellRoute(
            observers: [GoTransition.observer],
            builder: (context, state, child) {
              return Scaffold(
                appBar: AppBar(title: Text(state.fullPath ?? 'GoTransitions')),
                body: child,
              );
            },
            routes: [
              GoRoute(
                path: '/',
                builder: (_, _) => const InitialPage(),
                routes: [
                  for (final demo in _transitionDemos)
                    GoRoute(
                      path: demo.path.substring(1),
                      builder: (_, _) => DemoPage(title: demo.title),
                      pageBuilder: demo.transition.call,
                    ),
                  for (final demo in _popupDemos)
                    GoRoute(
                      path: demo.path.substring(1),
                      builder: (_, _) => PopupPage(title: demo.title),
                      pageBuilder: demo.pageBuilder,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TransitionDemo {
  const TransitionDemo(this.title, this.path, this.transition);

  final String title;
  final String path;
  final GoTransition transition;
}

class PopupDemo {
  const PopupDemo(this.title, this.path, this.pageBuilder);

  final String title;
  final String path;
  final GoRouterPageBuilder pageBuilder;
}

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Transitions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final demo in _transitionDemos)
          ListTile(
            title: Text(demo.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(demo.path),
          ),
        const Divider(height: 32),
        Text('Popup Routes', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final demo in _popupDemos)
          ListTile(
            title: Text(demo.title),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => context.go(demo.path),
          ),
        const Divider(height: 32),
        ListTile(
          title: const Text('Navigator push with GoTransitionRoute'),
          trailing: const Icon(Icons.navigation),
          onTap: () {
            Navigator.of(context).push(
              GoTransitionRoute(
                transition: GoTransitions.parallax.withBackGesture,
                builder: (context) => const DemoPage(title: 'Navigator Push'),
              ),
            );
          },
        ),
      ],
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.deepPurple,
      child: Center(
        child: FilledButton(
          onPressed: () => context.go('/'),
          child: Text('Back from $title'),
        ),
      ),
    );
  }
}

class PopupPage extends StatelessWidget {
  const PopupPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isSheet = title.toLowerCase().contains('sheet');

    if (isSheet) {
      return BottomSheet(
        onClosing: () {},
        builder: (_) => _PopupContent(title: title),
      );
    }

    return Dialog(child: _PopupContent(title: title));
  }
}

class _PopupContent extends StatelessWidget {
  const _PopupContent({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(title)),
          FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('Back to gallery'),
          ),
        ],
      ),
    );
  }
}
