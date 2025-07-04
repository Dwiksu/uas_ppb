import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uas_ril/src/auth/login_screen.dart';
import 'package:uas_ril/src/auth/register_screen.dart';
import 'package:uas_ril/src/screens/movie/movie.dart';
import 'package:uas_ril/src/providers/auth_provider.dart';
// Import file baru
import 'package:uas_ril/src/screens/main_screen.dart';
import 'package:uas_ril/src/screens/user/user_screen.dart';
import 'package:uas_ril/src/screens/watchlist/watchlist_screen.dart';

// Gunakan GlobalKey untuk router utama
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home', // Lokasi awal setelah login
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final goingToLoginOrRegister =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // Jika belum login dan tidak sedang menuju halaman login/register, alihkan ke login
      if (!authNotifier.isLoggedIn && !goingToLoginOrRegister) {
        return '/login';
      }

      // Jika sudah login dan mencoba ke halaman login/register, alihkan ke home
      if (authNotifier.isLoggedIn && goingToLoginOrRegister) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Rute untuk login dan register berada di luar ShellRoute
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignupScreen(),
      ),

      // Gunakan StatefulShellRoute untuk halaman dengan BottomNavBar
      StatefulShellRoute.indexedStack(
        // Ubah bagian builder ini
        builder: (context, state, navigationShell) {
          // 'navigationShell' sekarang bertindak sebagai 'child'
          return ScaffoldWithBottomNavBar(child: navigationShell);
        },
        branches: [
          // Branch 0: Halaman Movie
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder:
                    (context, state) =>
                        const NoTransitionPage(child: HomePage()),
              ),
            ],
          ),
          // Branch 1: Halaman Watchlist
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/watchlist',
                pageBuilder:
                    (context, state) =>
                        const NoTransitionPage(child: WatchlistScreen()),
              ),
            ],
          ),
          // Branch 2: Halaman User
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/user',
                pageBuilder:
                    (context, state) =>
                        const NoTransitionPage(child: UserScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});