// word.dart

class Word {
  final int? id; // id를 nullable로 변경
  final String name;
  final String meaning;
  final int chapter;

  Word({
    this.id,
    required this.name,
    required this.meaning,
    required this.chapter,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // id가 있을 때만 포함
      'name': name,
      'meaning': meaning,
      'chapter': chapter,
    };
  }
}