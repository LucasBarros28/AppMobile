import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    return _db ??= await initDb();
  }

  Future<Database> initDb() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await databaseFactory.getDatabasesPath();
    final path = join(dbPath, 'app_livros.db');

    print('🐴 CAMINHO DO BANCO: $path');

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User (
        id_user INTEGER PRIMARY KEY AUTOINCREMENT,
        password TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE Profile (
        id_profile INTEGER PRIMARY KEY AUTOINCREMENT,
        id_user INTEGER NOT NULL,
        tag TEXT NOT NULL UNIQUE,
        count_reviews INTEGER NOT NULL DEFAULT 0,
        count_followers INTEGER NOT NULL DEFAULT 0,
        count_following INTEGER NOT NULL DEFAULT 0,
        bio TEXT NOT NULL DEFAULT 'Sem descrição',
        pfp_path TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (id_user) REFERENCES User(id_user)
      );
    ''');

    await db.execute('''
      CREATE TABLE Review (
        id_review INTEGER PRIMARY KEY AUTOINCREMENT,
        id_profile INTEGER NOT NULL,
        likes INTEGER DEFAULT 0,
        title_review TEXT NOT NULL,
        title_book TEXT NOT NULL,
        author_review TEXT NOT NULL,
        author_book TEXT NOT NULL,
        content TEXT NOT NULL,
        image_blob BLOB,
        FOREIGN KEY (id_profile) REFERENCES Profile(id_profile)
      );
    ''');

    await db.execute('''
      CREATE TABLE Comment (
        id_comment INTEGER PRIMARY KEY AUTOINCREMENT,
        id_review INTEGER NOT NULL,
        id_profile INTEGER NOT NULL,
        parent_comment_id INTEGER,
        content TEXT NOT NULL,
        likes INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (id_review) REFERENCES Review(id_review),
        FOREIGN KEY (id_profile) REFERENCES Profile(id_profile),
        FOREIGN KEY (parent_comment_id) REFERENCES Comment(id_comment)
      );
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      final columns = await db.rawQuery("PRAGMA table_info(Review)");
      final hasLikes = columns.any((col) => col['name'] == 'likes');
      if (!hasLikes) {
        await db.execute("ALTER TABLE Review ADD COLUMN likes INTEGER DEFAULT 0");
      }
    }
  }
}
