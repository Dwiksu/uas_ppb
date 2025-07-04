import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uas_ril/src/auth/login_screen.dart';
import 'package:uas_ril/src/auth/register_screen.dart';
import 'package:uas_ril/src/screens/movie/movie.dart';
import 'package:uas_ril/src/providers/auth_provider.dart';
// Import file baru
import 'package:uas_ril/src/screens/shell_screen.dart';
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
        builder: (context, state, navigationShell) {
          // Widget kerangka utama dengan BottomNavBar
          return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
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

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:uas_ril/src/auth/login_screen.dart';
// import 'package:uas_ril/src/auth/register_screen.dart';
// import 'package:uas_ril/src/screens/movie/movie.dart';
// import 'package:uas_ril/src/providers/auth_provider.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// final appRouter = Provider<GoRouter>((ref) {
//   final authNotifier = ref.watch(authNotifierProvider);

//   return GoRouter(
//     initialLocation: '/login',
//     navigatorKey: navigatorKey,
//     refreshListenable: authNotifier,
//     redirect: (context, state) {
//       final goingToLoginOrRegister =
//           state.fullPath == '/login' || state.fullPath == '/register';

//       if (!authNotifier.isLoggedIn && !goingToLoginOrRegister) {
//         return '/login';
//       }

//       if (authNotifier.isLoggedIn && goingToLoginOrRegister) {
//         return '/home';
//       }

//       return null;
//     },
//     routes: [
//       ShellRoute(
//         builder: (_, __, child) => child,
//         routes: [
//           GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
//           GoRoute(path: '/register', builder: (_, __) => SignupScreen()),
//           GoRoute(path: '/home', builder: (_, __) => HomePage()),
//         ],
//       ),
//     ],
//   );

//   // return GoRouter(
//   //   initialLocation: '/register',
//   //   navigatorKey: navigatorKey,
//   //   refreshListenable: authNotifier,
//   //   redirect: (context, state) {
//   //     final goingToLoginOrRegister =
//   //         state.fullPath == '/login' || state.fullPath == '/register';

//   //     if (!authNotifier.isLoggedIn && !goingToLoginOrRegister) {
//   //       return '/login';
//   //     }

//   //     if (authNotifier.isLoggedIn && goingToLoginOrRegister) {
//   //       return '/home';
//   //     }

//   //     return null;
//   //   },
//   //   routes: [
//   //     GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
//   //     GoRoute(path: '/register', builder: (context, state) => SignupScreen()),
//   //     GoRoute(path: '/home', builder: (context, state) => HomePage()),
//   //   ],
//   // );
// });
