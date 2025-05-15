// SignUp.dart
import 'package:flutter/material.dart';
import 'package:lecternus/main.dart';
import 'package:lecternus/SignIn.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lecternus/database_helper.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  bool _isChecked = false;

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  final maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Future<void> _registerUser() async {
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você deve aceitar os termos de uso')),
      );
      return;
    }

    if (_nomeController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _telefoneController.text.isEmpty ||
        _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    try {
      final db = await DatabaseHelper().db;

      final existingEmail = await db.query(
        'User',
        where: 'email = ?',
        whereArgs: [_emailController.text],
      );

      if (existingEmail.isNotEmpty) {
        throw Exception('E-mail já cadastrado.');
      }

      final existingTag = await db.query(
        'Profile',
        where: 'tag = ?',
        whereArgs: [_usernameController.text.toLowerCase()],
      );

      if (existingTag.isNotEmpty) {
        throw Exception('Username já está em uso. Escolha outro.');
      }

      final idUser = await db.insert('User', {
        'name': _nomeController.text,
        'email': _emailController.text,
        'password': _senhaController.text,
      });

      await db.insert('Profile', {
        'id_user': idUser,
        'tag': _usernameController.text.toLowerCase(),
        'bio': 'Sem descrição',
        'count_reviews': 0,
        'count_followers': 0,
        'count_following': 0,
        'pfp_path': '',
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nome', _nomeController.text);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('senha', _senhaController.text);
      await prefs.setInt('id_user', idUser);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(initialIndex: 0)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar dados: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF57362B),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(
                "Já sou usuário",
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF57362B),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Nome completo"),
              _buildTextField(_nomeController, "Nome completo", Icons.account_circle),
              SizedBox(height: 16),
              _buildLabel("Username (@tag)"),
              _buildTextField(_usernameController, "Escolha seu username", Icons.alternate_email),
              SizedBox(height: 16),
              _buildLabel("E-mail"),
              _buildTextField(_emailController, "Digite seu e-mail", Icons.email),
              SizedBox(height: 16),
              _buildLabel("Telefone"),
              TextField(
                controller: _telefoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [maskFormatter],
                decoration: _inputDecoration("(00) 00000-0000", Icons.phone),
              ),
              SizedBox(height: 16),
              _buildLabel("Senha"),
              TextField(
                controller: _senhaController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFCDA68C),
                  border: OutlineInputBorder(),
                  hintText: "Digite sua senha",
                  hintStyle: TextStyle(color: const Color(0xFF57362B)),
                  prefixIcon: Icon(Icons.lock, color: const Color(0xFF57362B)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF57362B),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildCheckbox(),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _isChecked ? _registerUser : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCDA68C),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Registrar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    );
  }

  TextField _buildTextField(
      TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: _inputDecoration(hint, icon),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Color(0xFFCDA68C),
      border: OutlineInputBorder(),
      hintText: hint,
      hintStyle: TextStyle(color: const Color(0xFF57362B)),
      prefixIcon: Icon(icon, color: const Color(0xFF57362B)),
    );
  }

  Widget _buildCheckbox() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
            });
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _isChecked ? Colors.green : Colors.grey,
                width: 2,
              ),
            ),
            child: _isChecked
                ? Icon(Icons.check, size: 16, color: Colors.green)
                : null,
          ),
        ),
        SizedBox(width: 8),
        Text(
          "Concordo com os termos de uso",
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ],
    );
  }
}
