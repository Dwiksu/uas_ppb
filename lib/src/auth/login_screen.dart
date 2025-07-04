import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_ril/src/providers/auth_provider.dart';
import 'package:uas_ril/src/providers/loading_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(context),
            _inputField(context, ref),
            _forgotPassword(context),
            _signup(context),
          ],
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Movie App",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login"),
      ],
    );
  }

  _inputField(context, WidgetRef ref) {
    final controller = ref.watch(authNotifierProvider);

    final formKey = GlobalKey<FormState>();
    // Controller untuk TextFormField
    final usernameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            validator: _requiredValidator,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordCtrl,
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              filled: true,
              prefixIcon: const Icon(Icons.password),
            ),
            obscureText: true,
            validator: _passwordValidator,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed:
                ref.watch(loadingProvider)
                    ? null
                    : () => controller.login(
                      context,
                      formKey,
                      usernameCtrl.text,
                      passwordCtrl.text,
                    ),
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.deepPurple,
            ),
            child:
                ref.watch(loadingProvider)
                    ? const CircularProgressIndicator()
                    : const Text(
                      "Login",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
          ),
        ],
      ),
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.deepPurple),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
          onPressed: () => GoRouter.of(context).go('/register'),
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }

  String? _requiredValidator(String? val) =>
      (val == null || val.isEmpty) ? 'Required' : null;

  String? _passwordValidator(String? val) {
    if (val == null || val.length < 6) return 'Min 6 characters';
    return null;
  }
}
