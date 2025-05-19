import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class SlideUpPanel extends StatefulWidget {
  final Widget panelContent;
  final Widget bodyContent;
  final double minHeight;
  final double maxHeight;
  final bool isDraggable;
  final bool showDragHandle;
  final Color backgroundColor;
  final double borderRadius;
  final BoxShadow? boxShadow;
  final bool parallaxEnabled;
  final double parallaxOffset;
  final VoidCallback? onPanelOpened;
  final VoidCallback? onPanelClosed;
  final bool initiallyExpanded;
  final bool snapToPositions;
  final List<double>? snapPositions;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool backdropEnabled;
  final Color backdropColor;
  final double backdropOpacity;
  final VoidCallback? onBackdropTap;

  const SlideUpPanel({
    Key? key,
    required this.panelContent,
    required this.bodyContent,
    this.minHeight = 100.0,
    this.maxHeight = 500.0,
    this.isDraggable = true,
    this.showDragHandle = true,
    this.backgroundColor = Colors.white,
    this.borderRadius = 16.0,
    this.boxShadow,
    this.parallaxEnabled = false,
    this.parallaxOffset = 0.1,
    this.onPanelOpened,
    this.onPanelClosed,
    this.initiallyExpanded = false,
    this.snapToPositions = false,
    this.snapPositions,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.backdropEnabled = false,
    this.backdropColor = Colors.black,
    this.backdropOpacity = 0.5,
    this.onBackdropTap,
  }) : super(key: key);

  @override
  State<SlideUpPanel> createState() => _SlideUpPanelState();
}

class _SlideUpPanelState extends State<SlideUpPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<double> _backdropAnimation;

  double _currentHeight = 0.0;
  double _dragStartPosition = 0.0;
  double _dragStartHeight = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.initiallyExpanded ? widget.maxHeight : widget.minHeight;

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: widget.initiallyExpanded ? 1.0 : 0.0,
    );

    _heightAnimation = Tween<double>(
      begin: widget.minHeight,
      end: widget.maxHeight,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ),
    );

    _backdropAnimation = Tween<double>(
      begin: 0.0,
      end: widget.backdropOpacity,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ),
    );

    _heightAnimation.addListener(() {
      setState(() {
        if (!_isDragging) {
          _currentHeight = _heightAnimation.value;
        }
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onPanelOpened != null) {
        widget.onPanelOpened!();
      } else if (status == AnimationStatus.dismissed && widget.onPanelClosed != null) {
        widget.onPanelClosed!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (!widget.isDraggable) return;

    setState(() {
      _isDragging = true;
      _dragStartPosition = details.globalPosition.dy;
      _dragStartHeight = _currentHeight;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.isDraggable || !_isDragging) return;

    final dragDistance = _dragStartPosition - details.globalPosition.dy;
    final newHeight = (_dragStartHeight + dragDistance).clamp(
      widget.minHeight,
      widget.maxHeight,
    );

    setState(() {
      _currentHeight = newHeight;
      _controller.value = (_currentHeight - widget.minHeight) /
          (widget.maxHeight - widget.minHeight);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.isDraggable || !_isDragging) return;

    setState(() {
      _isDragging = false;
    });

    final velocity = details.primaryVelocity ?? 0.0;
    final isMovingUp = velocity < 0;

    if (widget.snapToPositions && widget.snapPositions != null && widget.snapPositions!.isNotEmpty) {
      _snapToClosestPosition(isMovingUp, velocity.abs());
    } else {
      if (isMovingUp && velocity.abs() > 500) {
        _animateToMaxHeight();
      } else if (!isMovingUp && velocity.abs() > 500) {
        _animateToMinHeight();
      } else {
        final isExpanded = _currentHeight > (widget.minHeight + widget.maxHeight) / 2;
        if (isExpanded) {
          _animateToMaxHeight();
        } else {
          _animateToMinHeight();
        }
      }
    }
  }

  void _snapToClosestPosition(bool isMovingUp, double velocity) {
    final positions = [...widget.snapPositions!, widget.minHeight, widget.maxHeight];
    positions.sort();

    double targetPosition;
    if (velocity > 500) {
      // If velocity is high, move in the direction of the swipe
      targetPosition = isMovingUp ? widget.maxHeight : widget.minHeight;
    } else {
      // Find the closest position
      double minDistance = double.infinity;
      targetPosition = _currentHeight;

      for (final position in positions) {
        final distance = (_currentHeight - position).abs();
        if (distance < minDistance) {
          minDistance = distance;
          targetPosition = position;
        }
      }
    }

    _animateToHeight(targetPosition);
  }

  void _animateToMaxHeight() {
    _controller.animateTo(1.0);
  }

  void _animateToMinHeight() {
    _controller.animateTo(0.0);
  }

  void _animateToHeight(double height) {
    final value = (height - widget.minHeight) / (widget.maxHeight - widget.minHeight);
    _controller.animateTo(value.clamp(0.0, 1.0));
  }

  void _handleBackdropTap() {
    if (widget.onBackdropTap != null) {
      widget.onBackdropTap!();
    } else {
      _animateToMinHeight();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final parallaxOffset = widget.parallaxEnabled
        ? (widget.maxHeight - _currentHeight) * widget.parallaxOffset
        : 0.0;

    return Stack(
      children: [
        // Body content with parallax effect
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Transform.translate(
            offset: Offset(0, -parallaxOffset),
            child: widget.bodyContent,
          ),
        ),

        // Backdrop
        if (widget.backdropEnabled)
          Positioned.fill(
            child: GestureDetector(
              onTap: _handleBackdropTap,
              child: IgnorePointer(
                ignoring: _controller.value == 0,
                child: AnimatedOpacity(
                  opacity: _backdropAnimation.value,
                  duration: widget.animationDuration,
                  child: Container(
                    color: widget.backdropColor.withOpacity(_backdropAnimation.value),
                  ),
                ),
              ),
            ),
          ),

        // Panel
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onVerticalDragStart: _handleDragStart,
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: Container(
              height: _currentHeight,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.borderRadius.r),
                  topRight: Radius.circular(widget.borderRadius.r),
                ),
                boxShadow: [
                  widget.boxShadow ??
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                ],
              ),
              child: Column(
                children: [
                  if (widget.showDragHandle) ...[
                    SizedBox(height: 8.h),
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                  Expanded(
                    child: widget.panelContent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
