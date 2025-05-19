import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:base_project2/core/auth/auth_manager.dart';
import 'package:base_project2/core/navigation/route_guard.dart';

/// Route names for the application.
class AppRoutes {
  // Auth routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyOtp = '/verify-otp';
  static const String pinSetup = '/pin-setup';
  static const String biometricSetup = '/biometric-setup';

  // Main routes
  static const String home = '/home';
  static const String accounts = '/accounts';
  static const String transactions = '/transactions';
  static const String transactionDetail = '/transactions/:id';
  static const String transfer = '/transfer';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String help = '/help';
}

/// Router configuration for the application.
@singleton
class AppRouter {
  final AuthManager _authManager;
  final RouteGuard _routeGuard;

  AppRouter(this._authManager, this._routeGuard);

  /// Creates the router configuration.
  GoRouter get router => GoRouter(
        initialLocation: AppRoutes.splash,
        debugLogDiagnostics: true,
        refreshListenable: GoRouterRefreshStream(_authManager.authStatusStream),
        redirect: _routeGuard.guard,
        routes: _routes,
      );

  /// List of routes for the application.
  List<RouteBase> get _routes => [
        // Auth routes
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Login Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Register Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Forgot Password Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.resetPassword,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Reset Password Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.verifyOtp,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Verify OTP Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.pinSetup,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('PIN Setup Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.biometricSetup,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Biometric Setup Screen')),
          ),
        ),

        // Main routes
        ShellRoute(
          builder: (context, state, child) {
            return Scaffold(
              body: child,
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance),
                    label: 'Accounts',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.swap_horiz),
                    label: 'Transfer',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _calculateSelectedIndex(state),
                onTap: (index) => _onItemTapped(index, context),
              ),
            );
          },
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const Center(
                child: Text('Home Screen'),
              ),
            ),
            GoRoute(
              path: AppRoutes.accounts,
              builder: (context, state) => const Center(
                child: Text('Accounts Screen'),
              ),
            ),
            GoRoute(
              path: AppRoutes.transfer,
              builder: (context, state) => const Center(
                child: Text('Transfer Screen'),
              ),
            ),
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const Center(
                child: Text('Profile Screen'),
              ),
            ),
          ],
        ),

        // Other main routes
        GoRoute(
          path: AppRoutes.transactions,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Transactions Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.transactionDetail,
          builder: (context, state) => Scaffold(
            body: Center(
              child: Text('Transaction Detail: ${state.pathParameters['id']}'),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Settings Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.notifications,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Notifications Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.help,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Help Screen')),
          ),
        ),
      ];

  /// Calculates the selected index for the bottom navigation bar.
  int _calculateSelectedIndex(GoRouterState state) {
    final String location = state.uri.path;
    if (location.startsWith(AppRoutes.home)) {
      return 0;
    }
    if (location.startsWith(AppRoutes.accounts)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.transfer)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.profile)) {
      return 3;
    }
    return 0;
  }

  /// Handles tapping on a bottom navigation bar item.
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(AppRoutes.home);
        break;
      case 1:
        GoRouter.of(context).go(AppRoutes.accounts);
        break;
      case 2:
        GoRouter.of(context).go(AppRoutes.transfer);
        break;
      case 3:
        GoRouter.of(context).go(AppRoutes.profile);
        break;
    }
  }
}

/// A listenable that refreshes the router when the auth status changes.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
