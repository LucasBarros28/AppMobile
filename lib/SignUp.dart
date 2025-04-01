import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'Profile.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  bool _isChecked = false;
  TextEditingController _textEditingController = TextEditingController();

  // Máscara para formatar telefone
  final maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')}, // Apenas números
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(
                "Já sou usuário",
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
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
      backgroundColor: const Color(0xFF6D3701),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nome",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nome completo",
                prefixIcon: Icon(Icons.account_circle),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "E-mail",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu e-mail",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Telefone",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [maskFormatter], // Aplica a máscara
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "(00) 00000-0000",
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Senha",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite sua senha",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
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
            // Checkbox para aceitar os termos de uso
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
                Text("Concordo com os termos de uso"),
              ],
            ),
            SizedBox(height: 16),
            // Botão de cadastro, ativado apenas se os termos forem aceitos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isChecked
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Profile()),
                          );
                        }
                      : null, // Habilita o botão somente se o checkbox estiver marcado
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAC842D), // Cor do botão
                    foregroundColor: Colors.black, // Cor do texto
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Registrar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
