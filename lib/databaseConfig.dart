// databaseConfig.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'word.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // 데이터베이스 초기화
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'word_database.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE words(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            meaning TEXT,
            chapter INTEGER
          )
          ''',
        );
      },
      version: 1, // 데이터베이스 버전 설정
    );
  }

  Future<bool> insertWord(Word word) async {
    final db = await database;
    try {
      await db.insert(
        'words',
        word.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<List<Word>> selectWords({int? chapter}) async {
    final db = await database;
    List<Map<String, dynamic>> data;
    if (chapter != null) {
      data = await db.query(
        'words',
        where: 'chapter = ?',
        whereArgs: [chapter],
      );
    } else {
      data = await db.query('words');
    }

    return List.generate(data.length, (i) {
      return Word(
        id: data[i]['id'],
        name: data[i]['name'],
        meaning: data[i]['meaning'],
        chapter: data[i]['chapter'],
      );
    });
  }

  Future<Word> selectWord(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> data =
    await db.query('words', where: "id = ?", whereArgs: [id]);
    return Word(
      id: data[0]['id'],
      name: data[0]['name'],
      meaning: data[0]['meaning'],
      chapter: data[0]['chapter'],
    );
  }

  Future<bool> updateWord(Word word) async {
    final db = await database;
    try {
      await db.update(
        'words',
        word.toMap(),
        where: "id = ?",
        whereArgs: [word.id],
      );
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<bool> deleteWord(int id) async {
    final db = await database;
    try {
      await db.delete(
        'words',
        where: "id = ?",
        whereArgs: [id],
      );
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  // 추가된 메서드: selectWordsByChapters
  Future<List<Word>> selectWordsByChapters(List<int> chapters) async {
    final db = await database;
    // SQL 인젝션을 방지하기 위해 '?' 플레이스홀더를 사용합니다.
    final placeholders = List.filled(chapters.length, '?').join(',');
    final List<Map<String, dynamic>> data = await db.rawQuery(
      'SELECT * FROM words WHERE chapter IN ($placeholders)',
      chapters,
    );

    return List.generate(data.length, (i) {
      return Word(
        id: data[i]['id'],
        name: data[i]['name'],
        meaning: data[i]['meaning'],
        chapter: data[i]['chapter'],
      );
    });
  }
}