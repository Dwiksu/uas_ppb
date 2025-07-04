import 'dart:async';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uas_ril/src/data/local/db_helper.dart';
import 'package:uas_ril/src/data/models/user.dart';
import 'package:uas_ril/src/providers/loading_provider.dart';
import 'package:uas_ril/src/utils/app_router.dart';

final authNotifierProvider = ChangeNotifierProvider<AuthNotifier>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends ChangeNotifier {
  bool _loggedIn = false;
  bool get isLoggedIn => _loggedIn;

  bool validateForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  Future<bool> _isUsernameAvailable(String username) async {
    final count = await DbHelper.checkUser(username);
    return count == 0;
  }

  void _showError(String message) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> submitRegister(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    String username,
    String password,
    String confirm,
  ) async {
    if (!validateForm(formKey)) return;

    ref.read(loadingProvider.notifier).state = true;
    try {
      if (!await _isUsernameAvailable(username)) {
        _showError('Username sudah digunakan');
        // Delay so snackbar shows before redirect/rebuild
        await Future.delayed(Duration(milliseconds: 100));
        return;
      }

      final hashedPassword = Crypt.sha256(password).toString();
      final user = User(username: username, password: hashedPassword);

      await DbHelper.insertUser(user);
      debugPrint('REGISTERED: $username');
      context.go('/login');
    } catch (e) {
      debugPrint('Register Error: $e');
      _showError('Terjadi kesalahan saat registrasi');
    } finally {
      await Future.delayed(
        Duration(milliseconds: 100),
      ); // Ensures snackbar shows
      ref.read(loadingProvider.notifier).state = false;
    }
  }

  Future<void> login(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    String username,
    String password,
  ) async {
    if (!validateForm(formKey)) return;

    ref.read(loadingProvider.notifier).state = true;
    try {
      final user = await DbHelper.getUserByUsername(username);
      if (user == null || !Crypt(user.password).match(password)) {
        _showError("Username atau Password salah");
        await Future.delayed(
          Duration(milliseconds: 100),
        ); // Allow snackbar to show
        return;
      }

      _loggedIn = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Login Error: $e');
      _showError('Terjadi kesalahan saat login');
    } finally {
      await Future.delayed(
        Duration(milliseconds: 100),
      ); // Snackbar grace period
      ref.read(loadingProvider.notifier).state = false;
    }
  }

  void logout() {
    _loggedIn = false;
    notifyListeners();
  }
}
