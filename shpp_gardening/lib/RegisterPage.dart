import 'package:flutter/material.dart';
import 'AccountLogic.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AccountLogic _viewModel = AccountLogic();
  
  String _selectedRole = 'Student'; // Default selection
  bool _isLoading = false;

  void _onRegisterPressed() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      // This calls the method in AccountLogic that saves the role to Firestore
      String? role = await _viewModel.registerUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _selectedRole,
      );

      if (role != null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage(userRole: role)),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            
            // ROLE DROPDOWN
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(labelText: "Register as"),
              items: ['Student', 'Teacher'].map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (val) => setState(() => _selectedRole = val!),
            ),
            
            const SizedBox(height: 24),
            _isLoading 
              ? const CircularProgressIndicator() 
              : ElevatedButton(onPressed: _onRegisterPressed, child: const Text("Register")),
          ],
        ),
      ),
    );
  }
}