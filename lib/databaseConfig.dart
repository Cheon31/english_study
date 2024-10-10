import 'package:path/path.dart';
import 'package:androidstduid/word.dart';  // 단어들 관리하는 객체
import 'package:sqflite/sqflite.dart'; // 데이터 베이스 관리하는 data 패키지 이다.


class DatabaseService {  // 싱글톤 패턴이라는 것을 만들어서 사용한다 뭔지는 모르겠다.
  static final DatabaseService _database = DatabaseService._internal();
  late Future<Database> database;

  factory DatabaseService() => _database;

  DatabaseService._internal() {
    databaseConfig();
  }

  Future<bool> databaseConfig() async { // 데이터 베이스를 설정 및 초기화 하는 부분이다.
    try {
      database = openDatabase(  //
        join(await getDatabasesPath(), 'word_database.db'),// 데이터 베이스 설정을 가져와 지정한 파일명으로 연결시킨다
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE words(id INTEGER PRIMARY KEY, name TEXT, meaning TEXT)',
          );
        },
        version: 1,  // 데이터 베이스 버전이지만 사용자가 직접 수정 가능핟.
      );
      return true;
    } catch (err) {
      print(err.toString());  // 데이터 베이스 에러시 출력 되는 부분이다.
      return false;  // 실패시 false 부분을 담당하단
    }
  }
// await 와 async 기능이 있다.
  // 1번 경우는 비동기 작업이 완료될떄 까지 기다린다.
  Future<bool> insertWord(Word word) async {  // 단어를 넣는 부분
    final Database db = await database;  // 데이터 베이스를 가져오는 역활을 한다.
    // await 경우는 백그라운드에서 데이터 베이스 황목을 가져오는것을 기다려 준다.
    try { // 예외가 발생할수 있는 코드를 실행한다. 여기서는
      db.insert( // 1. 삽입할 테이블 이름 , 2. WOrd객체를 MAP  형태로 변환한다. .3
      // 3, 에러가 발생하면 기본 데이터 베이스를 뒤집어 쓴다.
        'words',
        word.toMap(),  // 해당 과정은 word의 타입을 데이터 베이스에 맞는 형식으로 변환
        //시켜준다. 그냥은 사용 못한다. ( 키 : 값) 형식으로 사용해야 한다.
        conflictAlgorithm: ConflictAlgorithm.replace,  // 데이터 베이스에서
        // 보정해주는 데이터 손실 방지 명령어이다.
      );
      return true;
    } catch (err) {  // try 부분에서 에러가 발생할경우 실패 를 반환한다.
      // 또는 잘못된 황목이라고 출력할수도 있겠금 되어있다.
      return false;
    }
  }

  Future<List<Word>> selectWords() async {
    final Database db = await database;
    final List<Map<String, dynamic>> data = await db.query('words');

    return List.generate(data.length, (i) {
      return Word(
        id: data[i]['id'],
        name: data[i]['name'],
        meaning: data[i]['meaning'],
      );
    });
  }

  Future<Word> selectWord(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> data =
    await db.query('words', where: "id = ?", whereArgs: [id]);
    return Word(
        id: data[0]['id'], name: data[0]['name'], meaning: data[0]['meaning']);
  }

  Future<bool> updateWord(Word word) async {
    final Database db = await database;
    try {
      db.update(
        'words',
        word.toMap(),
        where: "id = ?",
        whereArgs: [word.id],
      );
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> deleteWord(int id) async {
    final Database db = await database;
    try {
      db.delete(
        'words',
        where: "id = ?",
        whereArgs: [id],
      );
      return true;
    } catch (err) {
      return false;
    }
  }
}