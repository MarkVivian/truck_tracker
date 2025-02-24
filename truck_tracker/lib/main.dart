import 'package:flutter/material.dart';
import 'package:truck_tracker/screens/auth_screen.dart';
import 'package:truck_tracker/utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truck Tracker',
      theme: AppTheme.lightTheme,
      home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}