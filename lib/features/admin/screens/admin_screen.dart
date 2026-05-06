import 'package:flutter/material.dart';
import 'admin_login_screen.dart';
import 'admin_dashboard_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return AdminLoginScreen(
        onLoginSuccess: () {
          setState(() {
            _isAuthenticated = true;
          });
        },
      );
    }
    return AdminDashboardScreen(
      onLogout: () {
        setState(() {
          _isAuthenticated = false;
        });
      },
    );
  }
}
