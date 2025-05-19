import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_project2/core/base/base_cubit.dart';
import 'package:base_project2/core/base/base_state.dart';
import 'package:base_project2/core/widgets/layout/app_app_bar.dart';
import 'package:base_project2/core/widgets/loading/app_loading.dart';
import 'package:base_project2/core/widgets/utility/app_snackbar.dart';
import 'package:base_project2/core/widgets/utility/error_handler.dart';
import 'package:base_project2/core/widgets/layout/network_aware_widget.dart';

/// Base page class for all pages in the application.
abstract class BasePage<C extends BaseCubit<T>, T> extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);
}

/// Base page state class for all page states in the application.
abstract class BasePageState<P extends BasePage<C, T>, C extends BaseCubit<T>, T>
    extends State<P> {
  /// The cubit for this page.
  C get cubit => context.read<C>();

  /// The title of the page.
  String get title => '';

  /// Whether to show the app bar.
  bool get showAppBar => true;

  /// Whether to show the back button.
  bool get showBackButton => true;

  /// Whether to center the title.
  bool get centerTitle => true;

  /// Whether to show the loading indicator when loading.
  bool get showLoading => true;

  /// Whether to show the error message when an error occurs.
  bool get showError => true;

  /// Whether to check for network connectivity.
  bool get checkConnectivity => true;

  /// Whether to use a safe area.
  bool get useSafeArea => true;

  /// Whether to resize to avoid the bottom inset.
  bool get resizeToAvoidBottomInset => true;

  /// The background color of the page.
  Color get backgroundColor => Colors.white;

  /// The actions to show in the app bar.
  List<Widget>? get actions => null;

  /// The leading widget to show in the app bar.
  Widget? get leading => null;

  /// The floating action button to show.
  Widget? get floatingActionButton => null;

  /// The bottom navigation bar to show.
  Widget? get bottomNavigationBar => null;

  /// The drawer to show.
  Widget? get drawer => null;

  /// The end drawer to show.
  Widget? get endDrawer => null;

  /// The bottom sheet to show.
  Widget? get bottomSheet => null;

  /// The persistent footer buttons to show.
  List<Widget>? get persistentFooterButtons => null;

  /// Builds the body of the page.
  Widget buildBody(BuildContext context);

  /// Builds the loading widget.
  Widget buildLoading() => const AppLoading();

  /// Builds the error widget.
  Widget buildError(String error) => ErrorHandler(
        error: error,
        onRetry: onRetry,
      );

  /// Called when the retry button is pressed.
  void onRetry() {}

  /// Called when the state changes.
  void onStateChanged(BaseState<T> state) {
    if (state.hasError && showError) {
      AppSnackbar.showError(context, message: state.error!);
    }
  }

  /// Builds the app bar.
  PreferredSizeWidget? buildAppBar() {
    if (!showAppBar) return null;
    return AppAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      automaticallyImplyLeading: showBackButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, BaseState<T>>(
      listener: (context, state) => onStateChanged(state),
      child: Scaffold(
        appBar: buildAppBar(),
        body: _buildContent(),
        backgroundColor: backgroundColor,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        drawer: drawer,
        endDrawer: endDrawer,
        bottomSheet: bottomSheet,
        persistentFooterButtons: persistentFooterButtons,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }

  Widget _buildContent() {
    Widget content = BlocBuilder<C, BaseState<T>>(
      builder: (context, state) {
        if (state.loading && showLoading) {
          return buildLoading();
        } else if (state.hasError && showError) {
          return buildError(state.error!);
        } else {
          return buildBody(context);
        }
      },
    );

    // if (checkConnectivity) {
    //   content = NetworkAwareWidget(child: content);
    // }

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return content;
  }
}
