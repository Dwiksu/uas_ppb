import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_ril/src/providers/auth_provider.dart';
import 'package:uas_ril/src/providers/loading_provider.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Lupa Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Masukkan username Anda untuk verifikasi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: usernameCtrl,
                decoration: InputDecoration(
                  hintText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  prefixIcon: const Icon(Icons.person),
                ),
                validator:
                    (val) =>
                        (val == null || val.isEmpty)
                            ? 'Username tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    ref.watch(loadingProvider)
                        ? null
                        : () {
                          if (formKey.currentState!.validate()) {
                            ref
                                .read(authNotifierProvider.notifier)
                                .verifyUsernameForReset(
                                  context,
                                  usernameCtrl.text,
                                );
                          }
                        },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                ),
                child:
                    ref.watch(loadingProvider)
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Verifikasi",
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
