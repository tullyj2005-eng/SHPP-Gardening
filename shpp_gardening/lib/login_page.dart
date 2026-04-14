import 'package:flutter/material.dart';
import 'account_logic.dart'; // Make sure your file is named account_logic.dart
import 'main.dart'; 
import 'register_page.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // FIXED: Changed this from account_logic() to AccountLogic()
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage(userRole: role)),
          (route) => false, 
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"), 
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _emailController, 
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController, 
                decoration: const InputDecoration(labelText: "Password"), 
                obscureText: true,
              ),
              const SizedBox(height: 24),
              _isLoading 
                ? const CircularProgressIndicator() 
                : Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onLoginPressed, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, 
                            foregroundColor: Colors.white
                          ),
                          child: const Text("Login"),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const RegisterPage())
                          );
                        },
                        child: const Text("Don't have an account? Register here"),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}