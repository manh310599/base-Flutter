import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:base_project2/core/auth/auth_manager.dart';
import 'package:base_project2/core/navigation/app_router.dart';

/// Route guard for protecting routes that require authentication.
@singleton
class RouteGuard {
  final AuthManager _authManager;

  RouteGuard(this._authManager);

  /// List of routes that don't require authentication.
  final List<String> _publicRoutes = [
    AppRoutes.splash,
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.forgotPassword,
    AppRoutes.resetPassword,
    AppRoutes.verifyOtp,
  ];

  /// List of routes that require authentication.
  final List<String> _protectedRoutes = [
    AppRoutes.home,
    AppRoutes.accounts,
    AppRoutes.transactions,
    AppRoutes.transactionDetail,
    AppRoutes.transfer,
    AppRoutes.profile,
    AppRoutes.settings,
    AppRoutes.notifications,
    AppRoutes.help,
    AppRoutes.pinSetup,
    AppRoutes.biometricSetup,
  ];

  /// Guards routes based on authentication status.
  String? guard(BuildContext context, GoRouterState state) {
    final String location = state.uri.path;
    final bool isAuthenticated = _authManager.isAuthenticated;
    final bool isPublicRoute = _isPublicRoute(location);
    final bool isProtectedRoute = _isProtectedRoute(location);

    // Handle splash screen
    if (location == AppRoutes.splash) {
      if (_authManager.currentStatus == AuthStatus.initial) {
        // Still initializing, stay on splash
        return null;
      } else if (isAuthenticated) {
        // Authenticated, go to home
        return AppRoutes.home;
      } else {
        // Not authenticated, go to login
        return AppRoutes.login;
      }
    }

    // Handle public routes
    if (isPublicRoute) {
      if (isAuthenticated) {
        // User is authenticated but trying to access public route
        return AppRoutes.home;
      }
      // User is not authenticated and accessing public route
      return null;
    }

    // Handle protected routes
    if (isProtectedRoute) {
      if (!isAuthenticated) {
        // User is not authenticated but trying to access protected route
        return AppRoutes.login;
      }
      // User is authenticated and accessing protected route
      return null;
    }

    // Route not found
    return AppRoutes.home;
  }

  /// Returns true if the route is public.
  bool _isPublicRoute(String location) {
    return _publicRoutes.any((route) => location.startsWith(route));
  }

  /// Returns true if the route is protected.
  bool _isProtectedRoute(String location) {
    return _protectedRoutes.any((route) => location.startsWith(route));
  }
}
