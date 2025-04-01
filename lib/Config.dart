import 'package:app_livros2/SignIn.dart';
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
        title: Text("Configurações"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            // Configurações de tela
            InkWell(
              onTap: () => print('Wi-Fi Configurado'),
              child: ListTile(
                leading: const Icon(Icons.smartphone),
                title: const Text('Configurações de tela'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),

            // Switch de notificações
            SwitchListTile(
              activeColor: const Color(0xFF6D3701),
              title: Row(
                children: const [
                  Icon(Icons.notifications), // Ícone de notificação
                  SizedBox(width: 10), // Espaço entre o ícone e o texto
                  Text("Notificações"), // Texto ao lado do ícone
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

            // Configurações de segurança
            InkWell(
              onTap: () => print('Configurações de segurança'),
              child: ListTile(
                leading: const Icon(Icons.password),
                title: const Text('Segurança'),
                trailing: const Icon(Icons.arrow_forward_ios),
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
                leading: const Icon(Icons.info),
                title: const Text('Sobre o App'),
                trailing: const Icon(Icons.arrow_forward_ios),
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
              onTap:  () {
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
