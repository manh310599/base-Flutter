import 'package:flutter/material.dart';

/// The direction of the slide animation.
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

/// A widget that applies a slide animation to its child.
///
/// This widget can be used to create slide-in or slide-out animations.
class SlideAnimation extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// The duration of the animation.
  final Duration duration;

  /// The delay before starting the animation.
  final Duration delay;

  /// The direction of the slide.
  final SlideDirection direction;

  /// The offset to slide from (as a fraction of the child's size).
  final double offset;

  /// The curve of the animation.
  final Curve curve;

  /// Whether the animation should play once or repeat.
  final bool repeat;

  /// Whether the animation should reverse after completion.
  final bool reverse;

  /// Callback when the animation completes.
  final VoidCallback? onComplete;

  const SlideAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.direction = SlideDirection.fromBottom,
    this.offset = 1.0,
    this.curve = Curves.easeInOut,
    this.repeat = false,
    this.reverse = false,
    this.onComplete,
  }) : super(key: key);

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<Offset>(
      begin: _getBeginOffset(),
      end: Offset.zero,
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

  Offset _getBeginOffset() {
    switch (widget.direction) {
      case SlideDirection.fromLeft:
        return Offset(-widget.offset, 0);
      case SlideDirection.fromRight:
        return Offset(widget.offset, 0);
      case SlideDirection.fromTop:
        return Offset(0, -widget.offset);
      case SlideDirection.fromBottom:
        return Offset(0, widget.offset);
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
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
