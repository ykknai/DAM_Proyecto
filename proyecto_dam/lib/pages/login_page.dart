import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto_dam/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String msgError = '';

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF000814), Color(0xFF001530), Color(0xFF003566)],
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  MdiIcons.calendarMonthOutline,
                  color: Colors.amber,
                  size: 80,
                ),
                SizedBox(height: 15),
                Text(
                  'Bienvenido a Eventify',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Gestiona y visualiza tus eventos fácilmente',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),

                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final user = await _authService.signInWithGoogle();

                      if (!mounted) return;

                      if (user != null) {
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        setState(
                          () => msgError = "Error al iniciar sesión con Google",
                        );
                      }
                    } catch (e) {
                      setState(() => msgError = "Error inesperado: $e");
                    }
                  },
                  icon: Icon(FontAwesomeIcons.google, color: Colors.white),
                  label: Text(
                    'Iniciar sesión con Google',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),

                SizedBox(height: 20),

                if (msgError.isNotEmpty)
                  Text(msgError, style: TextStyle(color: Colors.redAccent)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
