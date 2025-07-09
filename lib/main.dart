import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/utils/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouter);
    return MaterialApp.router(
      // Menerapkan tema terang
      theme: ThemeData.light(useMaterial3: true).copyWith(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          // Atur background dan elevation
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      // Menerapkan tema gelap
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          // Atur background dan elevation
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
