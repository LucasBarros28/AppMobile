import 'package:sqflite_common/sqlite_api.dart';
import 'package:lecternus/database_helper.dart';
import 'package:lecternus/SignIn.dart';

Future<void> resetDatabase() async {
  final db = await DatabaseHelper().db;

  // Apagar os dados existentes nas tabelas
  await db.delete('Comment');
  await db.delete('Review');
  await db.delete('Profile');
  await db.delete('User');

  // Inserir os dados de usuários, perfis, reviews e comentários
  final List<String> inserts = [

    // USERS
    "INSERT INTO User (password, email, name) VALUES ('_*g4V#Hh+T', 'ana.araújo@outlook.com', 'Ana Sophia Araújo');",
    "INSERT INTO User (password, email, name) VALUES ('@5LLt^9YrE', 'bryan.nascimento@outlook.com', 'Bryan Nascimento');",
    "INSERT INTO User (password, email, name) VALUES ('X040WvZTc', 'sr..moraes@gmail.com', 'Sr. João Lucas Moraes');",
    "INSERT INTO User (password, email, name) VALUES ('h#4JVEE_Oh', 'julia.ramos@outlook.com', 'Julia Ramos');",
    "INSERT INTO User (password, email, name) VALUES ('i89+Yffx_i', 'alana.correia@gmail.com', 'Alana Correia');",
    "INSERT INTO User (password, email, name) VALUES ('rn0%Dw&l*i', 'noah.martins@gmail.com', 'Noah Martins');",
    "INSERT INTO User (password, email, name) VALUES ('68@OVde%*#', 'milena.moura@outlook.com', 'Milena Moura');",
    "INSERT INTO User (password, email, name) VALUES ('a3ID%aZd&l', 'elisa.ribeiro@outlook.com', 'Elisa Ribeiro');",
    "INSERT INTO User (password, email, name) VALUES ('uo0N8HAc!7', 'maria.castro@gmail.com', 'Maria Clara Castro');",
    "INSERT INTO User (password, email, name) VALUES ('^1Wb5Bq6(2', 'luana.santos@outlook.com', 'Luana Santos');",

    // PERFIS
    "INSERT INTO Profile (id_user, tag, bio) VALUES (1, 'ana_488', 'Amante de livros, café e dias chuvosos.');",
    "INSERT INTO Profile (id_user, tag, bio) VALUES (2, 'bryan_755', 'Vivendo uma página de cada vez.');",
    "INSERT INTO Profile (id_user, tag, bio) VALUES (3, 'sr._801', 'Entre letras e histórias, encontro meu refúgio.');",
    "INSERT INTO Profile (id_user, tag, bio) VALUES (4, 'julia_963', 'Apaixonado por romances e mistérios.');",
    "INSERT INTO Profile (id_user, tag, bio) VALUES (5, 'alana_334', 'Escrevendo minha própria história.');",
    "INSERT INTO Profile (id_user, tag, bio) VALUES (6, 'noah_924', 'Críticas sinceras, sem spoiler!');",
    "INSERT INTO Profile (id_user, tag, bio) VALUES (7, 'milena_510', 'Sempre com um livro na mochila.');",
    "INSERT INTO Profile (id_user, tag, bio) VALUES (8, 'elisa_167', 'Literatura é liberdade.');",
    "INSERT INTO Profile (id_user, tag, bio) VALUES (9, 'maria_680', 'Explorando mundos com palavras.');",
    "INSERT INTO Profile (id_user, tag, bio) VALUES (10, 'luana_317', 'Resenhando com amor e sinceridade.');",

    // REVIEWS
    "INSERT INTO Review (id_profile, title_review, title_book, author_review, author_book, content) VALUES (8, 'O direito de ganhar mais rapidamente', 'O direito de avançar mais rapidamente', 'Elisa Ribeiro', 'Clara Santos', 'Uma leitura envolvente do início ao fim. Recomendo para quem gosta de suspense.');",
    "INSERT INTO Review (id_profile, title_review, title_book, author_review, author_book, content) VALUES (7, 'A liberdade de realizar seus sonhos com toda a tranquilidade', 'O conforto de inovar mais rapidamente', 'Milena Moura', 'Vinicius Vieira', 'O autor desenvolve bem os personagens e o enredo prende muito.');",
    "INSERT INTO Review (id_profile, title_review, title_book, author_review, author_book, content) VALUES (8, 'A liberdade de inovar mais facilmente', 'A possibilidade de atingir seus objetivos em estado puro', 'Elisa Ribeiro', 'Carlos Eduardo Cardoso', 'Um dos melhores livros que li esse ano. Final surpreendente!');",
    "INSERT INTO Review (id_profile, title_review, title_book, author_review, author_book, content) VALUES (3, 'A arte de realizar seus sonhos naturalmente', 'A simplicidade de evoluir mais facilmente', 'Sr. João Lucas Moraes', 'Alice da Luz', 'A escrita é fluida e os capítulos curtos tornam a leitura rápida.');",
    "INSERT INTO Review (id_profile, title_review, title_book, author_review, author_book, content) VALUES (5, 'A certeza de ganhar direto da fonte', 'A liberdade de realizar seus sonhos antes de tudo', 'Alana Correia', 'Carlos Eduardo Ferreira', 'Tema atual e necessário. Uma narrativa tocante e bem construída.');",

    // COMENTÁRIOS
    "INSERT INTO Comment (id_review, id_profile, content) VALUES (20, 7, 'Concordo plenamente com sua análise, me senti da mesma forma lendo!');",
    "INSERT INTO Comment (id_review, id_profile, content) VALUES (7, 9, 'Achei interessante como você interpretou o final, não tinha pensado nisso.');",
    "INSERT INTO Comment (id_review, id_profile, content) VALUES (7, 5, 'Também adorei esse livro! A escrita da autora é cativante.');",
    "INSERT INTO Comment (id_review, id_profile, content) VALUES (13, 6, 'Li recentemente e compartilho da mesma opinião. Ótima resenha!');",
    "INSERT INTO Comment (id_review, id_profile, content) VALUES (15, 9, 'Gosto quando as resenhas apontam os pontos negativos com equilíbrio. Parabéns!');"
  ];

  // Executar os inserts no banco de dados
  for (final sql in inserts) {
    await db.execute(sql);
  }
}
