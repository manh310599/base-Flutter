import 'package:flutter/material.dart';

/// A widget that applies a staggered animation to a list of children.
///
/// This widget can be used to create staggered animations for lists.
class StaggeredAnimation extends StatefulWidget {
  /// The children widgets to animate.
  final List<Widget> children;

  /// The duration of each child's animation.
  final Duration duration;

  /// The delay between each child's animation.
  final Duration staggerDuration;

  /// The initial delay before starting the first animation.
  final Duration initialDelay;

  /// The offset to slide from (as a fraction of the child's size).
  final double offset;

  /// The direction of the slide.
  final Axis direction;

  /// The curve of the animation.
  final Curve curve;

  /// The main axis alignment of the children.
  final MainAxisAlignment mainAxisAlignment;

  /// The cross axis alignment of the children.
  final CrossAxisAlignment crossAxisAlignment;

  /// Whether to animate the children when they are first built.
  final bool animateOnInit;

  const StaggeredAnimation({
    Key? key,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
    this.staggerDuration = const Duration(milliseconds: 50),
    this.initialDelay = Duration.zero,
    this.offset = 1.0,
    this.direction = Axis.vertical,
    this.curve = Curves.easeOut,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.animateOnInit = true,
  }) : super(key: key);

  @override
  State<StaggeredAnimation> createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends State<StaggeredAnimation> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    if (widget.animateOnInit) {
      _startAnimations();
    }
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        vsync: this,
        duration: widget.duration,
      ),
    );

    _animations = List.generate(
      widget.children.length,
      (index) => CurvedAnimation(
        parent: _controllers[index],
        curve: widget.curve,
      ),
    );

    _slideAnimations = List.generate(
      widget.children.length,
      (index) => Tween<Offset>(
        begin: _getBeginOffset(),
        end: Offset.zero,
      ).animate(_animations[index]),
    );
  }

  Offset _getBeginOffset() {
    if (widget.direction == Axis.vertical) {
      return Offset(0, widget.offset);
    } else {
      return Offset(widget.offset, 0);
    }
  }

  void _startAnimations() {
    Future.delayed(widget.initialDelay, () {
      for (int i = 0; i < _controllers.length; i++) {
        Future.delayed(widget.staggerDuration * i, () {
          if (mounted && _controllers.length > i) {
            _controllers[i].forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.direction == Axis.vertical
        ? Column(
            mainAxisAlignment: widget.mainAxisAlignment,
            crossAxisAlignment: widget.crossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: _buildAnimatedChildren(),
          )
        : Row(
            mainAxisAlignment: widget.mainAxisAlignment,
            crossAxisAlignment: widget.crossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: _buildAnimatedChildren(),
          );
  }

  List<Widget> _buildAnimatedChildren() {
    return List.generate(
      widget.children.length,
      (index) => FadeTransition(
        opacity: _animations[index],
        child: SlideTransition(
          position: _slideAnimations[index],
          child: widget.children[index],
        ),
      ),
    );
  }
}
