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
            isPreloaded INTEGER DEFAULT 0,
            memorizedStatus INTEGER DEFAULT 0,
            remember INTEGER DEFAULT 0
          )
          ''',
        );

        // 기본 단어 삽입
        await _insertPreloadedWords(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // memorizedStatus 컬럼 추가
          await db.execute('ALTER TABLE words ADD COLUMN memorizedStatus INTEGER DEFAULT 0');
        }
        if (oldVersion < 4) {
          // remember 컬럼 추가
          await db.execute('ALTER TABLE words ADD COLUMN remember INTEGER DEFAULT 0');
        }
        // 추가적인 버전 업그레이드 로직을 여기에 작성
      },
      version: 4, // 데이터베이스 버전을 4로 올림
    );
  }

  // 기본 단어를 삽입하는 메서드
  Future<void> _insertPreloadedWords(Database db) async {
    List<Word> preloadedWords = [
      // Chapter 1: Everyday Objects
      Word(name: 'apple', meaning: '사과', chapter: 1, isPreloaded: true),
      Word(name: 'book', meaning: '책', chapter: 1, isPreloaded: true),
      Word(name: 'chair', meaning: '의자', chapter: 1, isPreloaded: true),
      Word(name: 'desk', meaning: '책상', chapter: 1, isPreloaded: true),
      Word(name: 'pen', meaning: '펜', chapter: 1, isPreloaded: true),
      Word(name: 'table', meaning: '탁자', chapter: 1, isPreloaded: true),
      Word(name: 'window', meaning: '창문', chapter: 1, isPreloaded: true),
      Word(name: 'door', meaning: '문', chapter: 1, isPreloaded: true),
      Word(name: 'lamp', meaning: '램프', chapter: 1, isPreloaded: true),
      Word(name: 'clock', meaning: '시계', chapter: 1, isPreloaded: true),

      // Chapter 2: Animals
      Word(name: 'cat', meaning: '고양이', chapter: 2, isPreloaded: true),
      Word(name: 'dog', meaning: '개', chapter: 2, isPreloaded: true),
      Word(name: 'lion', meaning: '사자', chapter: 2, isPreloaded: true),
      Word(name: 'elephant', meaning: '코끼리', chapter: 2, isPreloaded: true),
      Word(name: 'tiger', meaning: '호랑이', chapter: 2, isPreloaded: true),
      Word(name: 'horse', meaning: '말', chapter: 2, isPreloaded: true),
      Word(name: 'cow', meaning: '소', chapter: 2, isPreloaded: true),
      Word(name: 'monkey', meaning: '원숭이', chapter: 2, isPreloaded: true),
      Word(name: 'giraffe', meaning: '기린', chapter: 2, isPreloaded: true),
      Word(name: 'zebra', meaning: '얼룩말', chapter: 2, isPreloaded: true),

      // Chapter 3: Fruits and Vegetables
      Word(name: 'banana', meaning: '바나나', chapter: 3, isPreloaded: true),
      Word(name: 'carrot', meaning: '당근', chapter: 3, isPreloaded: true),
      Word(name: 'broccoli', meaning: '브로콜리', chapter: 3, isPreloaded: true),
      Word(name: 'tomato', meaning: '토마토', chapter: 3, isPreloaded: true),
      Word(name: 'cucumber', meaning: '오이', chapter: 3, isPreloaded: true),
      Word(name: 'strawberry', meaning: '딸기', chapter: 3, isPreloaded: true),
      Word(name: 'potato', meaning: '감자', chapter: 3, isPreloaded: true),
      Word(name: 'onion', meaning: '양파', chapter: 3, isPreloaded: true),
      Word(name: 'lettuce', meaning: '상추', chapter: 3, isPreloaded: true),
      Word(name: 'grape', meaning: '포도', chapter: 3, isPreloaded: true),

      // Chapter 4: Transportation
      Word(name: 'car', meaning: '자동차', chapter: 4, isPreloaded: true),
      Word(name: 'bicycle', meaning: '자전거', chapter: 4, isPreloaded: true),
      Word(name: 'motorcycle', meaning: '오토바이', chapter: 4, isPreloaded: true),
      Word(name: 'truck', meaning: '트럭', chapter: 4, isPreloaded: true),
      Word(name: 'bus', meaning: '버스', chapter: 4, isPreloaded: true),
      Word(name: 'airplane', meaning: '비행기', chapter: 4, isPreloaded: true),
      Word(name: 'boat', meaning: '보트', chapter: 4, isPreloaded: true),
      Word(name: 'train', meaning: '기차', chapter: 4, isPreloaded: true),
      Word(name: 'helicopter', meaning: '헬리콥터', chapter: 4, isPreloaded: true),
      Word(name: 'scooter', meaning: '스쿠터', chapter: 4, isPreloaded: true),

      // Chapter 5: Accessories
      Word(name: 'watch', meaning: '시계', chapter: 5, isPreloaded: true),
      Word(name: 'bag', meaning: '가방', chapter: 5, isPreloaded: true),
      Word(name: 'glasses', meaning: '안경', chapter: 5, isPreloaded: true),
      Word(name: 'shoe', meaning: '신발', chapter: 5, isPreloaded: true),
      Word(name: 'hat', meaning: '모자', chapter: 5, isPreloaded: true),
      Word(name: 'umbrella', meaning: '우산', chapter: 5, isPreloaded: true),
      Word(name: 'wallet', meaning: '지갑', chapter: 5, isPreloaded: true),
      Word(name: 'key', meaning: '열쇠', chapter: 5, isPreloaded: true),
      Word(name: 'computer', meaning: '컴퓨터', chapter: 5, isPreloaded: true),
      Word(name: 'phone', meaning: '전화기', chapter: 5, isPreloaded: true),
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

    // remember > 0인 단어는 필터링하고 remember 카운터를 -1 감소시킵니다.
    List<Word> filteredWords = [];
    for (var row in data) {
      Word word = Word.fromMap(row);
      if (word.remember > 0) {
        word.remember -= 1;
        await updateWord(word);
      } else {
        filteredWords.add(word);
      }
    }

    return filteredWords;
  }
}