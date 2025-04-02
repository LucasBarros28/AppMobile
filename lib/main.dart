import 'package:flutter/material.dart';
import 'Home.dart';
import 'Profile.dart';
import 'criarReview.dart';
import 'SignIn.dart';
import 'bottom_nav_bar.dart';
import 'criarReview.dart';

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
  const MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    Home(),
    Center(child: Text('Pesquisa//Feature futura', style: TextStyle(fontSize: 24))),
    Criarreview(),
    Center(child: Text('Chat//Feature futura', style: TextStyle(fontSize: 24))),
    Profile(),
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
