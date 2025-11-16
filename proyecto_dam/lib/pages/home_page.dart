import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto_dam/auth/auth_controller.dart';
import 'package:proyecto_dam/pages/tabs/all_events.dart';
import 'package:proyecto_dam/pages/tabs/all_categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _authController = AuthController();

  final _tabs = [TodosEventosPage(), CategoriasPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(MdiIcons.calendarMonthOutline, color: Colors.amber, size: 30),
            Text(
              ' Eventify',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF051E34),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 24, // el contorno
              backgroundColor: Colors.blue, // color del borde
              child: CircleAvatar(
                radius: 21, // el avatar interno
                backgroundImage:
                    FirebaseAuth.instance.currentUser?.photoURL != null
                    ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                    : null,
                backgroundColor: Colors.grey.shade300,
                child: FirebaseAuth.instance.currentUser?.photoURL == null
                    ? const Icon(Icons.person, color: Colors.black54)
                    : null,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              _authController.signOut(context);
            },
          ),
        ],
      ),
      body: _tabs[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: Colors.blueAccent.shade700,
        backgroundColor: const Color(0xFF051E34),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        destinations: [
          NavigationDestination(
            icon: Icon(MdiIcons.homeOutline, color: Colors.white),
            selectedIcon: Icon(MdiIcons.home, color: Colors.blue),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(MdiIcons.accountOutline, color: Colors.white),
            selectedIcon: Icon(MdiIcons.account, color: Colors.blue),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
