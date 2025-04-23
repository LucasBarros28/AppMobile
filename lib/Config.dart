import 'package:lecternus/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:lecternus/Sobre.dart';

class Config extends StatefulWidget {
  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  bool _notificacao = false;
  TextEditingController _textEditingController =
      TextEditingController(); //instanciar o objeto para controlar o campo de texto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configurações",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF57362B),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
      ),
      backgroundColor: const Color(0xFF57362B),
      body: Container(
        child: ListView(
          children: [
            // Configurações de tela
            InkWell(
              onTap: () => print('Wi-Fi Configurado'),
              child: ListTile(
                leading: const Icon(
                  Icons.smartphone,
                  color: Colors.white,
                ),
                title: const Text(
                  'Configurações de tela',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),

            // Switch de notificações
            SwitchListTile(
              inactiveTrackColor:Colors.white, // Define a cor da trilha inativa
              inactiveThumbColor: const Color(0xFF57362B), // Cor do botão inativo
              activeColor: Colors.white, // Cor do botão ativo
              trackOutlineColor: WidgetStateProperty.resolveWith(
                (Set<WidgetState> states) {
                  if (!states.contains(WidgetState.selected)) {
                    return const Color(0xFF57362B); // Contorno branco quando inativo
                  }
                  return null; // Usa a cor padrão quando ativo
                },
              ),
              title: Row(
                children: const [
                  Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Notificações",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              value: _notificacao,
              onChanged: (bool valor) {
                setState(() {
                  _notificacao = valor;
                });
                print("Notificações: $valor");
              },
            ),

            InkWell(
              onTap: () => print('Configurações de segurança'),
              child: ListTile(
                leading: const Icon(
                  Icons.password,
                  color: Colors.white,
                ),
                title: const Text(
                  'Segurança',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),

            // Sobre o app
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sobre()),
                );
              },
              child: ListTile(
                leading: const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                title: const Text(
                  'Sobre o App',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
            // Botão de deletar conta
            InkWell(
              onTap: () {
                print("Deleta conta");
              },
              child: ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red, // Cor do ícone
                ),
                title: const Text(
                  'Deletar conta',
                  style: TextStyle(
                    color: Colors.red, // Cor do texto
                  ),
                ),
              ),
            ),
            // Botão de logout
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red, // Cor do ícone
                ),
                title: const Text(
                  'Sair',
                  style: TextStyle(
                    color: Colors.red, // Cor do texto
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
