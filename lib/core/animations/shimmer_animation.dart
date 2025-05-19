import 'package:flutter/material.dart';

/// A widget that applies a shimmer animation to its child.
///
/// This widget can be used to create loading effects.
class ShimmerAnimation extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// The duration of the animation.
  final Duration duration;

  /// The base color of the shimmer effect.
  final Color baseColor;

  /// The highlight color of the shimmer effect.
  final Color highlightColor;

  /// The direction of the shimmer effect.
  final ShimmerDirection direction;

  /// Whether the animation should repeat.
  final bool repeat;

  const ShimmerAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.direction = ShimmerDirection.leftToRight,
    this.repeat = true,
  }) : super(key: key);

  @override
  State<ShimmerAnimation> createState() => _ShimmerAnimationState();
}

/// The direction of the shimmer effect.
enum ShimmerDirection {
  /// Left to right shimmer effect.
  leftToRight,

  /// Right to left shimmer effect.
  rightToLeft,

  /// Top to bottom shimmer effect.
  topToBottom,

  /// Bottom to top shimmer effect.
  bottomToTop,
}

class _ShimmerAnimationState extends State<ShimmerAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );

    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
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
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: _getGradientBegin(),
              end: _getGradientEnd(),
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }

  Alignment _getGradientBegin() {
    switch (widget.direction) {
      case ShimmerDirection.leftToRight:
        return Alignment(_animation.value - 1, 0);
      case ShimmerDirection.rightToLeft:
        return Alignment(1 - _animation.value, 0);
      case ShimmerDirection.topToBottom:
        return Alignment(0, _animation.value - 1);
      case ShimmerDirection.bottomToTop:
        return Alignment(0, 1 - _animation.value);
    }
  }

  Alignment _getGradientEnd() {
    switch (widget.direction) {
      case ShimmerDirection.leftToRight:
        return Alignment(_animation.value, 0);
      case ShimmerDirection.rightToLeft:
        return Alignment(2 - _animation.value, 0);
      case ShimmerDirection.topToBottom:
        return Alignment(0, _animation.value);
      case ShimmerDirection.bottomToTop:
        return Alignment(0, 2 - _animation.value);
    }
  }
}
