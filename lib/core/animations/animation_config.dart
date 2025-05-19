import 'package:flutter/material.dart';

/// Configuration for animations throughout the app.
class AnimationConfig {
  /// Default duration for short animations (buttons, small UI elements).
  static const Duration shortDuration = Duration(milliseconds: 150);

  /// Default duration for medium animations (page transitions, dialogs).
  static const Duration mediumDuration = Duration(milliseconds: 300);

  /// Default duration for long animations (complex transitions, onboarding).
  static const Duration longDuration = Duration(milliseconds: 500);

  /// Default curve for enter animations.
  static const Curve enterCurve = Curves.easeOut;

  /// Default curve for exit animations.
  static const Curve exitCurve = Curves.easeIn;

  /// Default curve for button animations.
  static const Curve buttonCurve = Curves.easeInOut;

  /// Default curve for page transitions.
  static const Curve pageTransitionCurve = Curves.fastOutSlowIn;

  /// Default curve for loading animations.
  static const Curve loadingCurve = Curves.linear;

  /// Default delay between staggered animations.
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Default duration for shimmer loading effect.
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  /// Default base color for shimmer effect.
  static const Color shimmerBaseColor = Color(0xFFE0E0E0);

  /// Default highlight color for shimmer effect.
  static const Color shimmerHighlightColor = Color(0xFFF5F5F5);

  /// Default duration for pulse animations.
  static const Duration pulseDuration = Duration(milliseconds: 1000);

  /// Default scale range for pulse animations.
  static const double pulseMinScale = 0.95;
  static const double pulseMaxScale = 1.05;

  /// Default duration for rotation animations.
  static const Duration rotationDuration = Duration(milliseconds: 2000);

  /// Creates a page transition animation.
  static PageRouteBuilder<T> createPageRoute<T>({
    required Widget page,
    RouteSettings? settings,
    Duration duration = mediumDuration,
    bool fadeIn = true,
    bool slideIn = true,
    SlideDirection slideDirection = SlideDirection.fromRight,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: pageTransitionCurve,
        );

        final List<Widget Function(Widget)> transitions = [];

        if (fadeIn) {
          transitions.add(
            (child) => FadeTransition(
              opacity: curvedAnimation,
              child: child,
            ),
          );
        }

        if (slideIn) {
          final Offset beginOffset = _getSlideBeginOffset(slideDirection);
          transitions.add(
            (child) => SlideTransition(
              position: Tween<Offset>(
                begin: beginOffset,
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        }

        Widget result = child;
        for (final transition in transitions.reversed) {
          result = transition(result);
        }

        return result;
      },
    );
  }

  static Offset _getSlideBeginOffset(SlideDirection direction) {
    switch (direction) {
      case SlideDirection.fromLeft:
        return const Offset(-1.0, 0.0);
      case SlideDirection.fromRight:
        return const Offset(1.0, 0.0);
      case SlideDirection.fromTop:
        return const Offset(0.0, -1.0);
      case SlideDirection.fromBottom:
        return const Offset(0.0, 1.0);
    }
  }
}

/// The direction of slide animations.
enum SlideDirection {
  /// Slide from left to right.
  fromLeft,

  /// Slide from right to left.
  fromRight,

  /// Slide from top to bottom.
  fromTop,

  /// Slide from bottom to top.
  fromBottom,
}
