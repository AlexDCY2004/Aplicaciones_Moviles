import 'package:flutter/material.dart';
import 'policy_list_view.dart';
import 'policy_form_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Vistas controladas por el BottomNavigationBar
  final List<Widget> _views = [
    const PolicyListView(),
    const PolicyFormView(), // Formulario de registro directo
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Pólizas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_moderator),
            label: 'Nueva Póliza',
          ),
        ],
      ),
    );
  }
}