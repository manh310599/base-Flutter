import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A widget that applies a rotation animation to its child.
///
/// This widget can be used to create rotation animations.
class RotationAnimation extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// The duration of the animation.
  final Duration duration;

  /// The delay before starting the animation.
  final Duration delay;

  /// The initial rotation angle in radians.
  final double from;

  /// The final rotation angle in radians.
  final double to;

  /// The curve of the animation.
  final Curve curve;

  /// Whether the animation should play once or repeat.
  final bool repeat;

  /// Whether the animation should reverse after completion.
  final bool reverse;

  /// The alignment of the rotation.
  final Alignment alignment;

  /// Callback when the animation completes.
  final VoidCallback? onComplete;

  const RotationAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.delay = Duration.zero,
    this.from = 0.0,
    this.to = 2 * math.pi, // Full rotation
    this.curve = Curves.easeInOut,
    this.repeat = false,
    this.reverse = false,
    this.alignment = Alignment.center,
    this.onComplete,
  }) : super(key: key);

  /// Creates a continuously rotating animation.
  factory RotationAnimation.continuous({
    required Widget child,
    Duration duration = const Duration(milliseconds: 2000),
    Curve curve = Curves.linear,
    Alignment alignment = Alignment.center,
  }) {
    return RotationAnimation(
      child: child,
      duration: duration,
      from: 0.0,
      to: 2 * math.pi,
      curve: curve,
      repeat: true,
      alignment: alignment,
    );
  }

  @override
  State<RotationAnimation> createState() => _RotationAnimationState();
}

class _RotationAnimationState extends State<RotationAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: widget.from,
      end: widget.to,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    if (widget.delay == Duration.zero) {
      _startAnimation();
    } else {
      Future.delayed(widget.delay, _startAnimation);
    }
  }

  void _startAnimation() {
    if (widget.repeat) {
      if (widget.reverse) {
        _controller.repeat(reverse: true);
      } else {
        _controller.repeat();
      }
    } else {
      _controller.forward().then((_) {
        if (widget.onComplete != null) {
          widget.onComplete!();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          alignment: widget.alignment,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
