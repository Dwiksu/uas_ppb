import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uas_ril/src/auth/login_screen.dart';
import 'package:uas_ril/src/auth/register_screen.dart';
import 'package:uas_ril/src/screens/movie/movie.dart';
import 'package:uas_ril/src/providers/auth_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final appRouter = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    navigatorKey: navigatorKey,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final goingToLoginOrRegister =
          state.fullPath == '/login' || state.fullPath == '/register';

      if (!authNotifier.isLoggedIn && !goingToLoginOrRegister) {
        return '/login';
      }

      if (authNotifier.isLoggedIn && goingToLoginOrRegister) {
        return '/home';
      }

      return null;
    },
    routes: [
      ShellRoute(
        builder: (_, __, child) => child,
        routes: [
          GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
          GoRoute(path: '/register', builder: (_, __) => SignupScreen()),
          GoRoute(path: '/home', builder: (_, __) => HomePage()),
        ],
      ),
    ],
  );

  // return GoRouter(
  //   initialLocation: '/register',
  //   navigatorKey: navigatorKey,
  //   refreshListenable: authNotifier,
  //   redirect: (context, state) {
  //     final goingToLoginOrRegister =
  //         state.fullPath == '/login' || state.fullPath == '/register';

  //     if (!authNotifier.isLoggedIn && !goingToLoginOrRegister) {
  //       return '/login';
  //     }

  //     if (authNotifier.isLoggedIn && goingToLoginOrRegister) {
  //       return '/home';
  //     }

  //     return null;
  //   },
  //   routes: [
  //     GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
  //     GoRoute(path: '/register', builder: (context, state) => SignupScreen()),
  //     GoRoute(path: '/home', builder: (context, state) => HomePage()),
  //   ],
  // );
});
