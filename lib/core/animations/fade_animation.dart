import 'package:flutter/material.dart';

/// A widget that applies a fade animation to its child.
///
/// This widget can be used to create fade-in or fade-out animations.
class FadeAnimation extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// The duration of the animation.
  final Duration duration;

  /// The delay before starting the animation.
  final Duration delay;

  /// The initial opacity value (0.0 to 1.0).
  final double from;

  /// The final opacity value (0.0 to 1.0).
  final double to;

  /// The curve of the animation.
  final Curve curve;

  /// Whether the animation should play once or repeat.
  final bool repeat;

  /// Whether the animation should reverse after completion.
  final bool reverse;

  /// Callback when the animation completes.
  final VoidCallback? onComplete;

  const FadeAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.from = 0.0,
    this.to = 1.0,
    this.curve = Curves.easeInOut,
    this.repeat = false,
    this.reverse = false,
    this.onComplete,
  }) : super(key: key);

  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation> with SingleTickerProviderStateMixin {
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
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
