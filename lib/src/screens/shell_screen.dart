import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithBottomNavBar extends StatelessWidget {
  const ScaffoldWithBottomNavBar({Key? key, required this.navigationShell})
    : super(key: key);

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan menampilkan halaman yang aktif (Movie, Watchlist, atau User)
      body: navigationShell,
      // Gunakan bottomNavigationBar untuk menempatkan navigasi di bawah
      bottomNavigationBar: _buildFloatingNavBar(context),
    );
  }

  // Widget untuk membuat floating navigation bar
  Widget _buildFloatingNavBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16), // Memberi jarak dari tepi layar
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16), // Sudut yang membulat
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      // Penting untuk membuat efek "mengambang" pada corner radius
      clipBehavior: Clip.antiAlias,
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_outlined),
            activeIcon: Icon(Icons.movie),
            label: 'Movie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          // Navigasi ke branch/halaman yang sesuai saat item di-tap
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        // Sedikit style tambahan untuk tampilan yang lebih bersih
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor:
            Colors.deepPurple, // Transparan agar warna container terlihat
        elevation: 0, // Hilangkan shadow bawaan
      ),
    );
  }
}
