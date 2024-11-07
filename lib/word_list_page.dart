// word_list_page.dart

import 'package:flutter/material.dart';
import 'word.dart'; // Word 모델 클래스
import 'databaseConfig.dart'; // DatabaseService 클래스

class WordListPage extends StatefulWidget {
  final List<int> chapters;

  const WordListPage({Key? key, required this.chapters}) : super(key: key);

  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  final DatabaseService _databaseService = DatabaseService();
  late Future<List<Word>> _wordList;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  void _loadWords() {
    setState(() {
      _wordList = _databaseService.selectWordsByChapters(widget.chapters);
    });
  }

  @override
  Widget build(BuildContext context) {
    String chaptersText = widget.chapters.join(', ');
    return Scaffold(
      appBar: AppBar(
        title: Text('선택한 챕터: $chaptersText'),
      ),
      body: FutureBuilder<List<Word>>(
        future: _wordList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Word> words = snapshot.data!;
            if (words.isEmpty) {
              return const Center(child: Text('선택한 챕터에 단어가 없습니다.'));
            } else {
              return ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  Word word = words[index];
                  return ListTile(
                    title: Text(word.name),
                    subtitle: Text(word.meaning),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return const Center(child: Text('에러가 발생했습니다.'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}