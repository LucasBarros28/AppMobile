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
        backgroundColor: const Color(0xFF57362B),
        automaticallyImplyLeading: false,
        title: Text(
          "Lecternus",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Config()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF57362B),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinha os itens no topo
                  children: [
                    Container(
                      width: 150,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/imagem.jpg', // Caminho da sua imagem
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 16), // Espaço entre a foto e os campos de texto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Alinha os itens à esquerda
                        children: [
                          Text(
                            'Nome do Livro:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFCDA68C), // Cor do fundo
                              hintText: "Digite algo",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20), // Espaço entre os campos
                          Text(
                            'Nome do Autor:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFCDA68C),
                              hintText: 'Digite o nome do autor',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 125,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: const Color(0xFFCDA68C),
                    onPressed: () {
                      print("Botão pressionado!");
                    },
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Texto Grande:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFCDA68C),
                hintText: 'Digite um texto grande aqui...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Largura do botão ocupa toda a tela
              child: ElevatedButton(
                onPressed: () {
                  // Ação para salvar
                  print("Salvar pressionado");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCDA68C), // Cor do botão
                  padding:
                      EdgeInsets.symmetric(vertical: 15), // Espaçamento interno
                  textStyle: TextStyle(fontSize: 16), // Estilo do texto
                ),
                child: Text(
                  'Salvar',
                  style: TextStyle(color: Colors.white), // Cor do texto para branco
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
