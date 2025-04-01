import 'package:flutter/material.dart';
import 'Config.dart';
import 'Sobre.dart';
import 'bottom_nav_bar.dart';
import 'Home.dart';
import 'main.dart';

class Criarreview extends StatefulWidget {
  @override
  _criarReviewState createState() => _criarReviewState();
}

class _criarReviewState extends State<Criarreview> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(initialIndex: index)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Nome do App"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Config()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16), // Espaçamento ao redor do retângulo
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 150,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/imagem.jpg',
                    fit: BoxFit.cover,
                    width: 150,
                    height: 200,
                  ),
                ),
                Positioned(
                  bottom: -8, // Distância da borda inferior
                  right: 0, // Distância da borda direita
                  child: FloatingActionButton(
                    mini: true, // Deixa o botão menor
                    backgroundColor:
                        const Color.fromARGB(255, 222, 133, 8), // Cor do botão
                    onPressed: () {
                      print("Botão pressionado!");
                    },
                    child:
                        Icon(Icons.add, color: Colors.white), // Ícone do botão
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
