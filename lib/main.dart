import 'package:flutter/material.dart';
import 'package:lecternus/Home.dart';
import 'package:lecternus/Profile.dart';
import 'package:lecternus/criarReview.dart';
import 'package:lecternus/SignIn.dart';
import 'package:lecternus/pesquisar.dart';
import 'package:lecternus/bottom_nav_bar.dart';


// Banco de dados
import 'package:lecternus/database_helper.dart';
import 'package:lecternus/reset_db_full_final.dart'; // import do reset

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await resetDatabase(); // apenas para desenvolvimento!
    await DatabaseHelper().db;
    runApp(MyApp());
  } catch (e) {
    print('Erro ao iniciar o banco de dados: $e');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Erro ao iniciar o banco: $e'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignIn(),
      routes: {
        "/home": (context) => MainScreen(initialIndex: 0),
        "/pesquisa": (context) => MainScreen(initialIndex: 1),
        "/review": (context) => MainScreen(initialIndex: 2),
        "/perfil": (context) => MainScreen(initialIndex: 3),
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
    Pesquisar(),
    CriarReview(),
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
