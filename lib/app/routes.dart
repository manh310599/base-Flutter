import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      // final authState = context.read<AuthCubit>().state;
      // final isLoggedIn = authState is AuthAuthenticated;
      
      // If the user is not logged in and not on the login page, redirect to login
      // if (!isLoggedIn &&
      //     !state.matchedLocation.startsWith('/login') &&
      //     !state.matchedLocation.startsWith('/otp')) {
      //   return '/login';
      // }
      
      // If the user is logged in and on the login page, redirect to home
      // if (isLoggedIn &&
      //     (state.matchedLocation.startsWith('/login') ||
      //      state.matchedLocation.startsWith('/otp'))) {
      //   return '/';
      // }
      
      // No redirect needed
      return null;
    },
    routes: [
      // Auth routes
      // GoRoute(
      //   path: '/login',
      //   name: 'login',
      //   builder: (context, state) => const LoginPage(),
      // ),
      // GoRoute(
      //   path: '/otp',
      //   name: 'otp',
      //   builder: (context, state) {
      //     final phoneNumber = state.queryParameters['phoneNumber'] ?? '';
      //     return OtpVerificationPage(phoneNumber: phoneNumber);
      //   },
      // ),
      //
      // // Main app shell with bottom navigation
      // ShellRoute(
      //   navigatorKey: _shellNavigatorKey,
      //   builder: (context, state, child) {
      //     return HomePage(child: child);
      //   },
      //   routes: [
      //     // Home tab
      //     GoRoute(
      //       path: '/',
      //       name: 'home',
      //       pageBuilder: (context, state) {
      //         return const NoTransitionPage(
      //           child: HomeContent(),
      //         );
      //       },
      //       routes: [
      //         // Transaction details
      //         GoRoute(
      //           path: 'transaction/:id',
      //           name: 'transaction-details',
      //           builder: (context, state) {
      //             final id = state.pathParameters['id'] ?? '';
      //             return TransactionDetailsPage(transactionId: id);
      //           },
      //         ),
      //       ],
      //     ),
      //
      //     // Transactions tab
      //     // GoRoute(
      //     //   path: '/transactions',
      //     //   name: 'transactions',
      //     //   pageBuilder: (context, state) {
      //     //     return const NoTransitionPage(
      //     //       child: TransactionHistoryPage(),
      //     //     );
      //     //   },
      //     // ),
      //     //
      //     // // Transfer tab
      //     // GoRoute(
      //     //   path: '/transfer',
      //     //   name: 'transfer',
      //     //   pageBuilder: (context, state) {
      //     //     return const NoTransitionPage(
      //     //       child: TransferPage(),
      //     //     );
      //     //   },
      //     // ),
      //   ],
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oops! The page you are looking for does not exist.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
