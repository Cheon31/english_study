// word.dart

class Word {
  final int? id; // id를 nullable로 변경
  final String name;
  final String meaning;
  final int chapter;
  final bool isPreloaded; // 새 필드 추가
  int memorizedStatus; // 0: 기본값, 1: 외움, 2: 못 외움
  int remember; // 0 이상: 맞춘 횟수

  Word({
    this.id,
    required this.name,
    required this.meaning,
    required this.chapter,
    this.isPreloaded = false, // 기본값 설정
    this.memorizedStatus = 0, // 기본값 설정
    this.remember = 0, // 기본값 설정
  });

  // 데이터베이스에 저장할 맵으로 변환
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // id가 있을 때만 포함
      'name': name,
      'meaning': meaning,
      'chapter': chapter,
      'isPreloaded': isPreloaded ? 1 : 0, // Boolean을 Integer로 변환
      'memorizedStatus': memorizedStatus, // 추가된 부분
      'remember': remember, // 추가된 부분
    };
  }

  // 데이터베이스에서 객체로 변환
  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],
      name: map['name'],
      meaning: map['meaning'],
      chapter: map['chapter'],
      isPreloaded: map['isPreloaded'] == 1, // Integer를 Boolean으로 변환
      memorizedStatus: map['memorizedStatus'] ?? 0, // 추가된 부분
      remember: map['remember'] ?? 0, // 추가된 부분
    );
  }
}