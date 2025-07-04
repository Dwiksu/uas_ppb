import 'package:flutter/material.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
      ),
      body: const Center(
        child: Text(
          'Halaman Watchlist',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}