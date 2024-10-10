// 해당 부분으로 데이터를 생성 하였다.



class Word {
  final int id;           // 단어의 고유 식별자를 저장하는 변수
  final String name;       // 단어의 이름을 저장하는 변수
  final String meaning;    // 단어의 의미를 저장하는 변수

  // 생성자: id, name, meaning을 받아 Word 객체를 초기화함
  Word({required this.id, required this.name, required this.meaning});

  // 객체의 id, name, meaning을 Map 형태로 반환하는 함수
  Map<String, dynamic> toMap() { // to map 은 호출하는 개념이다.
    return {'id': id, 'name': name, 'meaning': meaning};  // Map으로 반환
  }
}