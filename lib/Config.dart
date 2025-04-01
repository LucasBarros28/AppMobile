import 'SignIn.dart';
import 'package:flutter/material.dart';
import 'Sobre.dart';

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
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6D3701),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
            color: Colors.black,),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
      ),
      backgroundColor: const Color(0xFF6D3701),
      body: Container(
        child: ListView(
          children: [
            // Configurações de tela
            InkWell(
              onTap: () => print('Wi-Fi Configurado'),
              child: ListTile(
                leading: const Icon(
                  Icons.smartphone,
                  color: Colors.black,
                ),
                title: const Text(
                  'Configurações de tela',
                  style: TextStyle(color: Colors.black),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ),
            ),

            // Switch de notificações
            SwitchListTile(
              inactiveTrackColor: const Color(0xFFAC842D),
              inactiveThumbColor: Colors.black,
              activeColor: const Color(0xFFAC842D),
              title: Row(
                children: const [
                  Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Notificações",
                    style: TextStyle(
                      color: Colors.black,
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
                  color: Colors.black,
                ),
                title: const Text(
                  'Segurança',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
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
                  color: Colors.black,
                ),
                title: const Text(
                  'Sobre o App',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
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
