import 'package:flutter/material.dart';

/// A utility class for managing animations.
class AnimationManager {
  /// Creates a fade-in animation.
  static Animation<double> createFadeInAnimation(
    AnimationController controller, {
    Curve curve = Curves.easeInOut,
    double from = 0.0,
    double to = 1.0,
  }) {
    return Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }

  /// Creates a slide animation.
  static Animation<Offset> createSlideAnimation(
    AnimationController controller, {
    Curve curve = Curves.easeInOut,
    Offset from = const Offset(0, 1),
    Offset to = Offset.zero,
  }) {
    return Tween<Offset>(begin: from, end: to).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }

  /// Creates a scale animation.
  static Animation<double> createScaleAnimation(
    AnimationController controller, {
    Curve curve = Curves.easeInOut,
    double from = 0.0,
    double to = 1.0,
  }) {
    return Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }

  /// Creates a rotation animation.
  static Animation<double> createRotationAnimation(
    AnimationController controller, {
    Curve curve = Curves.easeInOut,
    double from = 0.0,
    double to = 1.0,
  }) {
    return Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }

  /// Creates a color animation.
  static Animation<Color?> createColorAnimation(
    AnimationController controller, {
    Curve curve = Curves.easeInOut,
    required Color from,
    required Color to,
  }) {
    return ColorTween(begin: from, end: to).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }

  /// Creates a sequence animation.
  static Animation<T> createSequenceAnimation<T>(
    AnimationController controller, {
    required List<TweenSequenceItem<T>> items,
    Curve curve = Curves.easeInOut,
  }) {
    return TweenSequence<T>(items).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }

  /// Creates a staggered animation controller.
  static AnimationController createStaggeredController({
    required TickerProvider vsync,
    required Duration duration,
    Duration? reverseDuration,
  }) {
    return AnimationController(
      vsync: vsync,
      duration: duration,
      reverseDuration: reverseDuration,
    );
  }

  /// Creates a repeating animation controller.
  static AnimationController createRepeatingController({
    required TickerProvider vsync,
    required Duration duration,
    bool reverse = false,
  }) {
    final controller = AnimationController(
      vsync: vsync,
      duration: duration,
    );
    controller.repeat(reverse: reverse);
    return controller;
  }

  /// Creates a delayed animation.
  static Future<void> delayedAnimation({
    required AnimationController controller,
    required Duration delay,
    bool forward = true,
  }) async {
    await Future.delayed(delay);
    if (controller.isAnimating) {
      controller.stop();
    }
    if (forward) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }
}
