import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lecternus/database_helper.dart';
import 'package:lecternus/main.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:lecternus/SignIn.dart';


class CriarReview extends StatefulWidget {
  @override
  _CriarReviewState createState() => _CriarReviewState();
}

class _CriarReviewState extends State<CriarReview> {
  final _formKey = GlobalKey<FormState>();
  final _resenhaController = TextEditingController();
  final _nomeLivroController = TextEditingController();
  final _nomeAutorController = TextEditingController();

  Future<void> _salvarReview() async {
    if (_formKey.currentState!.validate()) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final idUser = prefs.getInt('id_user');
        final nome = prefs.getString('nome') ?? '';

        if (idUser == null) throw Exception('Usuário não autenticado.');

        final db = await DatabaseHelper().db;

        final profileResult = await db.query(
          'Profile',
          where: 'id_user = ?',
          whereArgs: [idUser],
        );

        if (profileResult.isEmpty) throw Exception('Perfil não localizado.');

        final profileId = profileResult.first['id_profile'];

        await db.insert('Review', {
          'id_profile': profileId,
          'title_review': _resenhaController.text.substring(0, 20),
          'title_book': _nomeLivroController.text,
          'author_review': nome,
          'author_book': _nomeAutorController.text,
          'content': _resenhaController.text,
          'image_path': 'assets/images/imagem.jpg',
        });

        
        // Atualiza contador de reviews
        final reviewCountResult = await db.rawQuery(
          
          'SELECT COUNT(*) as total FROM Review WHERE id_profile = ?',
          [profileId],
          );

        final reviewCount = reviewCountResult.first['total'] as int;

        await db.update(
          'Profile',
          {'count_reviews': reviewCount},
          where: 'id_profile = ?',
          whereArgs: [profileId],
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Resenha publicada com sucesso!'),
          backgroundColor: Colors.green,
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(initialIndex: 0)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro: ${e.toString()}'),
          backgroundColor: Colors.red,
        ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF57362B),
      appBar: AppBar(
        title: Text('Criar Review'),
        backgroundColor: const Color(0xFF57362B),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen(initialIndex: 0)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Nome do Livro', _nomeLivroController),
              SizedBox(height: 12),
              _buildTextField('Autor do Livro', _nomeAutorController),
              SizedBox(height: 12),
              _buildTextArea('Escreva sua resenha', _resenhaController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCDA68C),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Publicar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      validator: (value) =>
          value == null || value.isEmpty ? 'Campo obrigatório' : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFCDA68C),
        labelStyle: TextStyle(color: const Color(0xFF57362B)),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTextArea(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      maxLines: 8,
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        if (value.length < 50) return 'Mínimo de 50 caracteres';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFCDA68C),
        labelStyle: TextStyle(color: const Color(0xFF57362B)),
        border: OutlineInputBorder(),
      ),
    );
  }
}