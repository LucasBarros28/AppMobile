import 'package:flutter/material.dart';
import 'Config.dart';
import 'Sobre.dart';
import 'bottom_nav_bar.dart';
import 'Home.dart';
import 'main.dart';

class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
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
        backgroundColor: const Color(0xFF6D3701),
        automaticallyImplyLeading: false,
        title: Text(
          "Lecternus",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
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
      backgroundColor: const Color(0xFF6D3701),
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
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 20), // Espaço entre os campos
                          Text(
                            'Nome do Autor:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Texto Grande:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFAC842D),
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
                child: Text(
                  'Salvar',
                  style: TextStyle(
                      color: Colors.white), // Cor do texto para branco
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAC842D), // Cor do botão
                  padding:
                      EdgeInsets.symmetric(vertical: 15), // Espaçamento interno
                  textStyle: TextStyle(fontSize: 16), // Estilo do texto
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
