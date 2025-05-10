import 'dart:ui';
import 'package:lecternus/Review.dart';
import 'package:lecternus/Profile.dart';
import 'package:lecternus/criarReview.dart';
import 'package:flutter/material.dart';
import 'package:lecternus/Config.dart';
import 'package:lecternus/Sobre.dart';
import 'package:lecternus/bottom_nav_bar.dart';
import 'package:lecternus/Review.dart';
import 'package:lecternus/ReviewModel.dart';
import 'package:lecternus/ReviewSoucer.dart';
import 'package:lecternus/main.dart';

class Criarreview extends StatefulWidget {
  @override
  _CriarReviewState createState() => _CriarReviewState();
}

class _CriarReviewState extends State<Criarreview> {
  int _selectedIndex = 2;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _resenhaController = TextEditingController();
  final TextEditingController _nomeLivroController = TextEditingController();
  final TextEditingController _nomeAutorController = TextEditingController();

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
            icon: Icon(Icons.settings, color: Colors.white),
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
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            height: 200,
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
                                  'Nome do Livro:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFCDA68C),
                                    hintText: "Digite o nome do livro",
                                    hintStyle: TextStyle(
                                        color: const Color(0xFF57362B)),
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: _nomeLivroController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira o nome do livro';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Nome do Autor:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFCDA68C),
                                    hintText: 'Digite o nome do autor',
                                    hintStyle: TextStyle(
                                        color: const Color(0xFF57362B)),
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: _nomeAutorController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira o nome do autor';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: -10,
                        left: 120,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: const Color(0xFFCDA68C),
                          onPressed: () {
                            // Adicionar funcionalidade para selecionar imagem
                            print("Selecionar imagem do livro");
                          },
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Resenha:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextFormField(
                    maxLines: 13,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFCDA68C),
                      hintText: 'Digite sua resenha aqui...',
                      hintStyle: TextStyle(color: const Color(0xFF57362B)),
                      border: OutlineInputBorder(),
                    ),
                    controller: _resenhaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, escreva sua resenha';
                      }
                      if (value.length < 50) {
                        return 'A resenha deve ter pelo menos 50 caracteres';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _salvarReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCDA68C),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 20),
                      ),
                      child: Text(
                        'Salvar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _salvarReview() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Criar o modelo da review
        final newReview = ReviewModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: 'current_user_id', // Substituir pelo ID do usuário logado
          userName: 'Nome do Usuário', // Obter do perfil do usuário
          userImage: 'assets/images/profile.webp', // Imagem do usuário
          bookTitle: _nomeLivroController.text,
          reviewText: _resenhaController.text,
          date: DateTime.now(),
        );

        // Adicionar ao ReviewSource
        await ReviewSource.addReview(newReview);

        // Mostrar mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Resenha publicada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Limpar os campos
        _nomeLivroController.clear();
        _nomeAutorController.clear();
        _resenhaController.clear();

        // Opcional: Navegar de volta para a tela inicial
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(initialIndex: 0)),
        );
      } catch (e) {
        // Mostrar mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao publicar resenha: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _resenhaController.dispose();
    _nomeLivroController.dispose();
    _nomeAutorController.dispose();
    super.dispose();
  }
}
