import 'package:app_livros2/Home.dart';
import 'package:app_livros2/Profile.dart';
import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'bottom_nav_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(), // ⬅ Defina MainScreen como a tela inicial
      routes: {
        "/home": (context) => MainScreen(initialIndex: 0),
        "/pesquisa": (context) => MainScreen(initialIndex: 1),
        "/review": (context) => MainScreen(initialIndex: 2),
        "/chat": (context) => MainScreen(initialIndex: 3),
        "/perfil": (context) => MainScreen(initialIndex: 4),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({Key? key, this.initialIndex = 0})
      : super(key: key); // ⬅ Permite iniciar com qualquer aba

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // ⬅ Define o índice inicial
  }

  final List<Widget> _pages = [
    Home(), // ⬅ Use a tela Home real
    Center(child: Text('Pesquisa', style: TextStyle(fontSize: 24))),
    Center(child: Text('Review', style: TextStyle(fontSize: 24))),
    Center(child: Text('Chat', style: TextStyle(fontSize: 24))),
    Profile(), // ⬅ Use a tela Profile real
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
