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
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE words(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            meaning TEXT,
            chapter INTEGER,
            isPreloaded INTEGER DEFAULT 0
          )
          ''',
        );

        // 기본 단어 삽입
        await _insertPreloadedWords(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // isPreloaded 컬럼 추가
          await db.execute('ALTER TABLE words ADD COLUMN isPreloaded INTEGER DEFAULT 0');

          // 기존 단어들을 기본 단어로 마킹 (필요 시)
          // 예시로, 모든 기존 단어를 기본 단어로 설정
          // 실제로는 필요한 단어만 업데이트해야 함
          // await db.update('words', {'isPreloaded': 1});
        }
        // 추가적인 버전 업그레이드 로직을 여기에 작성
      },
      version: 2, // 데이터베이스 버전을 2로 올림
    );
  }

  // 기본 단어를 삽입하는 메서드
  Future<void> _insertPreloadedWords(Database db) async {
    List<Word> preloadedWords = [
      Word(name: 'apple', meaning: 'A fruit that grows on trees.', chapter: 1, isPreloaded: true),
      Word(name: 'book', meaning: 'A written or printed work consisting of pages glued or sewn together.', chapter: 1, isPreloaded: true),
      // 필요한 기본 단어들을 추가하세요
    ];

    for (var word in preloadedWords) {
      await db.insert(
        'words',
        word.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
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
      return Word.fromMap(data[i]);
    });
  }

  Future<Word> selectWord(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> data =
    await db.query('words', where: "id = ?", whereArgs: [id]);
    return Word.fromMap(data[0]);
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
      return Word.fromMap(data[i]);
    });
  }
}