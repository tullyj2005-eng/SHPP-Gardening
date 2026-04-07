import 'package:flutter/material.dart';
import 'AccountLogic.dart';
import 'main.dart'; // IMPORTANT: We point to HomePage in main.dart
import 'RegisterPage.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AccountLogic _viewModel = AccountLogic();
  bool _isLoading = false;

  void _onLoginPressed() async {
    setState(() => _isLoading = true);
    try {
      String? role = await _viewModel.loginUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (role != null && mounted) {
        // We navigate to HomePage (the parent) which already knows how to handle the plants
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage(userRole: role)),
          (route) => false, 
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 24),
            _isLoading 
              ? const CircularProgressIndicator() 
              : Column(
                  children: [
                    ElevatedButton(onPressed: _onLoginPressed, child: const Text("Login")),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                      },
                      child: const Text("Don't have an account? Register here"),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}