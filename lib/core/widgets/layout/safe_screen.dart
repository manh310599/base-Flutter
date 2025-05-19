import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class SafeScreen extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? drawerScrimColor;
  final bool safeTop;
  final bool safeBottom;
  final bool safeLeft;
  final bool safeRight;

  const SafeScreen({
    Key? key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor = AppColors.background,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.drawerScrimColor,
    this.safeTop = true,
    this.safeBottom = true,
    this.safeLeft = true,
    this.safeRight = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        top: safeTop,
        bottom: safeBottom,
        left: safeLeft,
        right: safeRight,
        child: Padding(
          padding: padding,
          child: body,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      persistentFooterButtons: persistentFooterButtons,
      drawer: drawer,
      endDrawer: endDrawer,
      drawerScrimColor: drawerScrimColor,
    );
  }
}

class ScrollableScreen extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? drawerScrimColor;
  final bool safeTop;
  final bool safeBottom;
  final bool safeLeft;
  final bool safeRight;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final bool primary;
  final bool reverse;
  final EdgeInsetsGeometry? contentPadding;
  final bool enablePullToRefresh;
  final Future<void> Function()? onRefresh;

  const ScrollableScreen({
    Key? key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor = AppColors.background,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.drawerScrimColor,
    this.safeTop = true,
    this.safeBottom = true,
    this.safeLeft = true,
    this.safeRight = true,
    this.scrollController,
    this.physics,
    this.primary = true,
    this.reverse = false,
    this.contentPadding,
    this.enablePullToRefresh = false,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollableContent = SingleChildScrollView(
      controller: scrollController,
      physics: physics,
      primary: primary,
      padding: contentPadding,
      child: child,
    );

    final body = enablePullToRefresh && onRefresh != null
        ? RefreshIndicator(
            onRefresh: onRefresh!,
            color: AppColors.primary,
            child: scrollableContent,
          )
        : scrollableContent;

    return SafeScreen(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      padding: padding,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      persistentFooterButtons: persistentFooterButtons,
      drawer: drawer,
      endDrawer: endDrawer,
      drawerScrimColor: drawerScrimColor,
      safeTop: safeTop,
      safeBottom: safeBottom,
      safeLeft: safeLeft,
      safeRight: safeRight,
      body: body,
    );
  }
}
