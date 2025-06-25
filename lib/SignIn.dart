import 'package:flutter/material.dart';
import 'package:lecternus/main.dart';
import 'package:lecternus/SignUp.dart';
import 'package:lecternus/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _obscureText = true;
  TextEditingController _loginController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final login = _loginController.text.trim();
    final senha = _senhaController.text.trim();

    if (login.isEmpty || senha.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha todos os campos';
        _isLoading = false;
      });
      return;
    }

    final db = await DatabaseHelper().db;

    final result = await db.query(
      'User',
      where: '(email = ? OR name = ?) AND password = ?',
      whereArgs: [login, login, senha],
    );

    if (result.isNotEmpty) {
      final user = result.first;
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('nome', user['name'] as String);
      await prefs.setString('email', user['email'] as String);
      await prefs.setInt('id_user', user['id_user'] as int); // ✅ fix crucial

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(initialIndex: 0)),
      );
    } else {
      setState(() {
        _errorMessage = 'E-mail/Nome de usuário ou senha incorretos';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF57362B),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 125, left: 16, right: 16, bottom: 16),
          child: Column(
            children: [
              _buildLogo(),
              SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              _buildLabel("E-mail/Nome de usuário"),
              _buildInput(_loginController, Icons.email, "Digite seu e-mail ou nome de usuário"),
              SizedBox(height: 5),
              _buildLabel("Senha"),
              _buildPasswordInput(),
              SizedBox(height: 15),
              _buildLoginButton(),
              _buildSignUpRedirect(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            'assets/images/logoTeste.png',
            width: 200.0,
            height: 200.0,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Lecternus",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, IconData icon, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFCDA68C),
        border: OutlineInputBorder(),
        hintText: hint,
        hintStyle: TextStyle(color: const Color(0xFF57362B)),
        prefixIcon: Icon(icon, color: const Color(0xFF57362B)),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return TextField(
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
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _loginUser,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCDA68C),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              "Entrar",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
    );
  }

  Widget _buildSignUpRedirect() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUp()),
        );
      },
      child: Text(
        "Ainda não tem uma conta? Cadastre-se",
        style: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
