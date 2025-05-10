import 'package:flutter/material.dart';
import 'package:lecternus/main.dart';
import 'package:lecternus/SignIn.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  bool _isChecked = false;

  // Controladores para os campos de texto
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  // Máscara para formatar telefone
  final maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Função para salvar os dados do usuário
  Future<void> _registerUser() async {
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você deve aceitar os termos de uso')),
      );
      return;
    }

    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _telefoneController.text.isEmpty ||
        _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    try {
      // Salva os dados do usuário
      await saveUserProfile(
        _nomeController.text,
        _emailController.text,
        _telefoneController.text,
        _senhaController.text,
      );

      // Navega para a tela principal após o cadastro
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
              Text(
                "Nome",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFCDA68C),
                  border: OutlineInputBorder(),
                  hintText: "Nome completo",
                  hintStyle: TextStyle(color: const Color(0xFF57362B)),
                  prefixIcon: Icon(Icons.account_circle,
                      color: const Color(0xFF57362B)),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "E-mail",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFCDA68C),
                  border: OutlineInputBorder(),
                  hintText: "Digite seu e-mail",
                  hintStyle: TextStyle(color: const Color(0xFF57362B)),
                  prefixIcon: Icon(Icons.email, color: const Color(0xFF57362B)),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Telefone",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _telefoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [maskFormatter],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFCDA68C),
                  border: OutlineInputBorder(),
                  hintText: "(00) 00000-0000",
                  hintStyle: TextStyle(color: const Color(0xFF57362B)),
                  prefixIcon: Icon(Icons.phone, color: const Color(0xFF57362B)),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Senha",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isChecked ? _registerUser : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCDA68C),
                      foregroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para salvar os dados do perfil (já existente no seu código)
  Future<void> saveUserProfile(
      String nome, String email, String telefone, String senha) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', nome);
    await prefs.setString('email', email);
    await prefs.setString('telefone', telefone);
    await prefs.setString('senha', senha);
  }
}
