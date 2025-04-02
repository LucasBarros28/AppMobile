import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Sobre extends StatefulWidget {
  @override
  _SobreState createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  final List<Map<String, String>> githubLinks = [
    {'name': 'Alex Marques', 'url': 'https://github.com/AlexMarques03'},
    {'name': 'Charles Meira', 'url': 'https://github.com/CharlesMeira'},
    {'name': 'Lucas Barros', 'url': 'https://github.com/LucasBarros28'},
    {'name': 'Rafael Barbosa', 'url': 'https://github.com/rafahcbarbosa'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sobre o App",
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
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF57362B),
      body: Stack(
        children: [
          ListView(
            children: [
              ListTile(
                title: const Text(
                  'Versão',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Versão"),
                        content: Text("1.0.0"),
                      );
                    },
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Sobre sua conta',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => print('Sobre sua conta'),
              ),
              ListTile(
                title: const Text(
                  'Política de Privacidade',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => print('Política de privacidade'),
              ),
              ListTile(
                title: const Text(
                  'Termos de Uso',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => print('Termos de Uso'),
              ),
              ListTile(
                title: const Text(
                  'Políticas de Terceiros',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => print('Políticas de Terceiros'),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'App Criado por Charles, Rafael, Alex e Lucas.\n'
                    'Alunos do curso de Engenharia da Computação da\n'
                    'Pontifícia Universidade Católica de Minas Gerais.\n'
                    'Todos os direitos reservados aos Criadores do App.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: githubLinks.map((link) {
                      return Row(
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.github,
                                    color: Colors.white),
                                onPressed: () async {
                                  final url = link['url']!;
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  }
                                },
                              ),
                              Text(
                                link['name']!,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
