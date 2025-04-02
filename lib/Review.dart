import 'package:flutter/material.dart';
import 'Config.dart';
import 'bottom_nav_bar.dart';
import 'main.dart';

class Review extends StatefulWidget {
  final String reviewText;

  Review({required this.reviewText});

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  int _selectedIndex = 2;
  TextEditingController _commentController = TextEditingController();

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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D3701),
        automaticallyImplyLeading: true,
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
      body: SafeArea(
        // Envolvendo o conteúdo com SafeArea
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        'assets/images/imagem.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nome do Livro: Mar azul',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Nome do Autor: José da Silva',
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
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  widget.reviewText,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double
                    .infinity, // Faz o campo de texto ocupar toda a largura
                height: 50, // Ajuste a altura para algo semelhante ao botão
                padding: EdgeInsets.symmetric(
                    horizontal: 12), // Mantém o padding lateral
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black38),
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Escreva seu comentário aqui...',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.arrow_forward, // Ícone de seta
                        color: Colors.black87, // Cor da seta
                      ),
                      onPressed: () {
                        // Adicione aqui a lógica para o que acontecerá quando o botão for pressionado
                        print("Comentário enviado: ${_commentController.text}");
                      },
                    ),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
