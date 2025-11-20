import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proyecto_dam/auth/auth_wrapper.dart';
import 'package:proyecto_dam/pages/home_page.dart';
import 'package:proyecto_dam/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [Locale('es')],
      title: 'Eventify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      //home: AuthWrapper(),
      initialRoute: '/auth',

      routes: {
        '/auth': (context) => AuthWrapper(), // Tu lógica de autenticación
        '/login': (context) => LoginPage(), // Pantalla de Login
        '/home': (context) => HomePage(), // Pantalla principal
      },
    );
  }
}
