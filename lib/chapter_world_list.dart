// chapter_word_list.dart

import 'package:flutter/material.dart';
import 'databaseConfig.dart';
import 'word.dart';

class ChapterWordListPage extends StatefulWidget {
  final int chapter;

  const ChapterWordListPage({Key? key, required this.chapter}) : super(key: key);

  @override
  State<ChapterWordListPage> createState() => _ChapterWordListPageState();
}

class _ChapterWordListPageState extends State<ChapterWordListPage> {
  final DatabaseService _databaseService = DatabaseService();
  late Future<List<Word>> _wordList;

  @override
  void initState() {
    super.initState();
    _loadWordList();
  }

  void _loadWordList() {
    setState(() {
      _wordList = _databaseService.selectWords(chapter: widget.chapter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('챕터 ${widget.chapter} 단어 목록'),
      ),
      body: FutureBuilder<List<Word>>(
        future: _wordList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Word> words = snapshot.data!;
            if (words.isEmpty) {
              return const Center(child: Text('이 챕터에 단어가 없습니다.'));
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