import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  tablet,
  desktop,
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  // Breakpoints
  final double mobileBreakpoint;
  final double tabletBreakpoint;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.mobileBreakpoint = 600,
    this.tabletBreakpoint = 1200,
  }) : super(key: key);

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 600) {
      return DeviceType.mobile;
    } else if (width < 1200) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < mobileBreakpoint) {
          return mobile;
        } else if (constraints.maxWidth < tabletBreakpoint) {
          return tablet ?? mobile;
        } else {
          return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}

class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  T get(BuildContext context) {
    final deviceType = ResponsiveLayout.getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveLayout.getDeviceType(context);
    return builder(context, deviceType);
  }
}

class ResponsiveConstraints extends StatelessWidget {
  final Widget child;
  final double? maxWidthMobile;
  final double? maxWidthTablet;
  final double? maxWidthDesktop;
  final double? minWidthMobile;
  final double? minWidthTablet;
  final double? minWidthDesktop;
  final BoxConstraints? additionalConstraints;
  final AlignmentGeometry alignment;

  const ResponsiveConstraints({
    Key? key,
    required this.child,
    this.maxWidthMobile,
    this.maxWidthTablet,
    this.maxWidthDesktop,
    this.minWidthMobile,
    this.minWidthTablet,
    this.minWidthDesktop,
    this.additionalConstraints,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveLayout.getDeviceType(context);
    
    double? maxWidth;
    double? minWidth;
    
    switch (deviceType) {
      case DeviceType.mobile:
        maxWidth = maxWidthMobile;
        minWidth = minWidthMobile;
        break;
      case DeviceType.tablet:
        maxWidth = maxWidthTablet ?? maxWidthMobile;
        minWidth = minWidthTablet ?? minWidthMobile;
        break;
      case DeviceType.desktop:
        maxWidth = maxWidthDesktop ?? maxWidthTablet ?? maxWidthMobile;
        minWidth = minWidthDesktop ?? minWidthTablet ?? minWidthMobile;
        break;
    }
    
    return Center(
      child: ConstrainedBox(
        constraints: additionalConstraints?.copyWith(
          maxWidth: maxWidth,
          minWidth: minWidth,
        ) ?? BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
          minWidth: minWidth ?? 0.0,
        ),
        child: child,
      ),
    );
  }
}
