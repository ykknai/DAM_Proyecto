import 'package:flutter/material.dart';
import 'package:proyecto_dam/auth/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<void> signOut(BuildContext context) async {
    try {
      await _authService.signOut();

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cerrar sesión: $e')));
    }
  }
}
