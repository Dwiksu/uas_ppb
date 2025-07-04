import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({Key? key, required this.child})
    : super(key: key);

  final Widget child;

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/watchlist')) return 1;
    if (location.startsWith('/user')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/watchlist');
        break;
      case 2:
        context.go('/user');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hapus properti bottomNavigationBar dari Scaffold
      // body sekarang menggunakan Stack
      body: Stack(
        children: [
          // Layer 1: Konten utama (halaman yang aktif)
          // Konten ini akan mengisi seluruh layar
          widget.child,

          // Layer 2: Floating Bottom Navigation Bar
          // Diposisikan di bagian bawah layar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildFloatingNavBar(context),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membuat nav bar tidak berubah, hanya posisinya yang kita atur
  Widget _buildFloatingNavBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(
          0.9,
        ), // Warna dengan sedikit transparansi
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
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
        currentIndex: _getSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: const Color.fromARGB(130, 104, 58, 183),
        elevation: 0,
      ),
    );
  }
}
