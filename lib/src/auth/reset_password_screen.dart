import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_ril/src/providers/auth_provider.dart';
import 'package:uas_ril/src/providers/loading_provider.dart';

class ResetPasswordScreen extends ConsumerWidget {
  final String username;
  const ResetPasswordScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atur Password Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: passwordCtrl,
                decoration: InputDecoration(
                  hintText: "Password Baru",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  prefixIcon: const Icon(Icons.password),
                ),
                obscureText: true,
                validator: (val) => (val == null || val.length < 6) ? 'Minimal 6 karakter' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: confirmCtrl,
                decoration: InputDecoration(
                  hintText: "Konfirmasi Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  prefixIcon: const Icon(Icons.password),
                ),
                obscureText: true,
                validator: (val) => val != passwordCtrl.text ? "Password tidak cocok" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: ref.watch(loadingProvider)
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          ref.read(authNotifierProvider.notifier)
                              .resetPassword(context, username, passwordCtrl.text);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                ),
                child: ref.watch(loadingProvider)
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Simpan Password",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}