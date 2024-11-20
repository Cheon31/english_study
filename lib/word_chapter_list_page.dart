import 'package:flutter/material.dart';
import 'databaseConfig.dart';
import 'word.dart';

class WordChapterListPage extends StatefulWidget {
  const WordChapterListPage({Key? key}) : super(key: key);

  @override
  _WordChapterListPageState createState() => _WordChapterListPageState();
}

class _WordChapterListPageState extends State<WordChapterListPage> {
  final DatabaseService _databaseService = DatabaseService();
  Map<int, Future<List<Word>>> _chapterWords = {};

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 10; i++) {
      _chapterWords[i] = _databaseService.selectWords(chapter: i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 목록'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          int chapterNumber = index + 1;
          return ExpansionTile(
            title: Text('챕터 $chapterNumber'),
            children: [
              FutureBuilder<List<Word>>(
                future: _chapterWords[chapterNumber],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('오류 발생');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('단어 없음');
                  } else {
                    List<Word> words = snapshot.data!;
                    return Column(
                      children: words.map((word) {
                        return ExpansionTile(
                          title: Text(word.name),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('뜻: ${word.meaning}'),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}