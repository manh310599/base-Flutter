import 'package:flutter/material.dart';

/// A utility class for optimizing animations
class AnimationHelper {
  /// Creates a fade transition
  static Widget createFadeTransition({
    required Animation<double> animation,
    required Widget child,
    Curve curve = Curves.easeInOut,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: curve,
      ),
      child: child,
    );
  }
  
  /// Creates a slide transition
  static Widget createSlideTransition({
    required Animation<double> animation,
    required Widget child,
    Curve curve = Curves.easeInOut,
    Offset beginOffset = const Offset(0.0, 0.2),
    Offset endOffset = Offset.zero,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: endOffset,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
      ),
      child: child,
    );
  }
  
  /// Creates a scale transition
  static Widget createScaleTransition({
    required Animation<double> animation,
    required Widget child,
    Curve curve = Curves.easeInOut,
    double beginScale = 0.8,
    double endScale = 1.0,
    Alignment alignment = Alignment.center,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: beginScale,
        end: endScale,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
      ),
      alignment: alignment,
      child: child,
    );
  }
  
  /// Creates a combined fade and slide transition
  static Widget createFadeSlideTransition({
    required Animation<double> animation,
    required Widget child,
    Curve curve = Curves.easeInOut,
    Offset beginOffset = const Offset(0.0, 0.2),
    Offset endOffset = Offset.zero,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: curve,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: endOffset,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve,
          ),
        ),
        child: child,
      ),
    );
  }
  
  /// Creates a staggered animation for a list of widgets
  static List<Widget> createStaggeredList({
    required List<Widget> children,
    required AnimationController controller,
    Curve curve = Curves.easeInOut,
    Duration staggerDuration = const Duration(milliseconds: 50),
    Offset beginOffset = const Offset(0.0, 0.1),
    Offset endOffset = Offset.zero,
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
  }) {
    return List.generate(
      children.length,
      (index) {
        final start = index * staggerDuration.inMilliseconds / 1000;
        final end = start + 0.5;
        
        final slideAnimation = Tween<Offset>(
          begin: beginOffset,
          end: endOffset,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              start.clamp(0.0, 1.0),
              end.clamp(0.0, 1.0),
              curve: curve,
            ),
          ),
        );
        
        final fadeAnimation = Tween<double>(
          begin: beginOpacity,
          end: endOpacity,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              start.clamp(0.0, 1.0),
              end.clamp(0.0, 1.0),
              curve: curve,
            ),
          ),
        );
        
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: children[index],
          ),
        );
      },
    );
  }
  
  /// Creates an optimized page route transition
  static PageRouteBuilder<T> createPageRoute<T>({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.fastOutSlowIn,
    bool fade = true,
    bool slide = true,
    Offset slideOffset = const Offset(0.2, 0.0),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        
        Widget result = child;
        
        if (slide) {
          result = SlideTransition(
            position: Tween<Offset>(
              begin: slideOffset,
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: result,
          );
        }
        
        if (fade) {
          result = FadeTransition(
            opacity: curvedAnimation,
            child: result,
          );
        }
        
        return result;
      },
    );
  }
}
