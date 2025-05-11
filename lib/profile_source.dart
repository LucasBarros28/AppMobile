import 'package:shared_preferences/shared_preferences.dart';

// Função para salvar os dados do perfil
Future<void> saveUserProfile(
    String nome, String email, String telefone, String senha) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Salvar dados do perfil no SharedPreferences, incluindo a senha
  await prefs.setString('nome', nome);
  await prefs.setString('email', email);
  await prefs.setString('telefone', telefone);
  await prefs.setString('senha', senha); // Aqui a senha está sendo salva
}

// Função para carregar os dados do perfil
Future<Map<String, String>> loadUserProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String nome = prefs.getString('nome') ?? 'Nome não definido';
  String email = prefs.getString('email') ?? 'E-mail não definido';
  String telefone = prefs.getString('telefone') ?? 'Telefone não definido';

  return {
    'nome': nome,
    'email': email,
    'telefone': telefone,
  };
}

Future<void> deleteUserProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('nome');
  await prefs.remove('email');
  await prefs.remove('telefone');
}

Future<Map<String, String>> getUserProfile() async {
  final prefs = await SharedPreferences.getInstance();
  String? nome = prefs.getString('nome');
  String? senha = prefs.getString('senha');
  return {
    'nome': nome ?? '',
    'senha': senha ?? '',
  };
}
