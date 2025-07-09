import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_ril/src/providers/auth_provider.dart';
import 'package:uas_ril/src/providers/loading_provider.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 60.0),
              _header(context),
              const SizedBox(height: 40),
              _inputField(context, ref),
              const SizedBox(height: 20),
              _signin(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Sign Up",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Create new account"),
      ],
    );
  }

  _inputField(context, WidgetRef ref) {
    final controller = ref.watch(authNotifierProvider);

    final formKey = GlobalKey<FormState>();
    // Controller untuk TextFormField
    final usernameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

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
            validator: _usernameValidator,
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
          TextFormField(
            controller: confirmCtrl,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              filled: true,
              prefixIcon: const Icon(Icons.password),
            ),
            obscureText: true,
            validator:
                (value) =>
                    value != passwordCtrl.text ? "Passwords don't match" : null,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed:
                ref.watch(loadingProvider)
                    ? null
                    : () => controller.submitRegister(
                      context,
                      formKey,
                      usernameCtrl.text,
                      passwordCtrl.text,
                      confirmCtrl.text,
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
                      "Sign Up",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
          ),
        ],
      ),
    );
  }

  _signin(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        TextButton(
          onPressed: () => GoRouter.of(context).go('/login'),
          child: const Text(
            "Sign In",
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }

  String? _usernameValidator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Username required';
    }
    if (!RegExp(r'^[a-zA-Z0-9_.]+$').hasMatch(val)) {
      return 'Username can only contain letters, numbers, dots and underscores';
    }
    if (val.length < 3 || val.length > 20) {
      return 'Username must be between 3 and 20 characters';
    }
    return null;
  }

  String? _passwordValidator(String? val) {
    if (val == null || val.length < 6) return 'Min 6 characters';
    return null;
  }
}
