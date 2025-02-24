import 'package:flutter/material.dart';
import 'package:truck_tracker/config/preferences.dart';
import 'package:truck_tracker/screens/receptionist_screen.dart';
import 'package:truck_tracker/screens/admin_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _usernameController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    final username = _usernameController.text;
    final id = _idController.text;
    final password = _passwordController.text;

    final userCreds = Preferences.userCredentials[username];

    if (userCreds != null &&
        userCreds['id'] == id &&
        userCreds['password'] == password) {
      if (username == 'receptionist') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ReceptionistScreen()),
        );
      } else if (username == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            Preferences.backgroundImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Overlay color
          Container(
            color: Color(Preferences.overlayColor),
          ),
          // Login content
          Center(
            child: Container(
              width: Preferences.loginCardWidth,
              padding: const EdgeInsets.all(Preferences.loginCardPadding),
              decoration: BoxDecoration(
                color: Color(Preferences.backgroundGreen),
                borderRadius: BorderRadius.circular(Preferences.borderRadius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: Preferences.headerFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: Preferences.inputSpacing),
                  TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      hintText: 'ID Number',
                      prefixIcon: Icon(Icons.badge),
                    ),
                  ),
                  const SizedBox(height: Preferences.inputSpacing),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('LOG IN'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}