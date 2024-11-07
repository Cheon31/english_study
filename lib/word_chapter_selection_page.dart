// word_chapter_selection_page.dart

import 'package:flutter/material.dart';
import 'word_list_page.dart'; // 선택한 챕터의 단어를 표시할 페이지

class WordChapterSelectionPage extends StatefulWidget {
  const WordChapterSelectionPage({Key? key}) : super(key: key);

  @override
  _WordChapterSelectionPageState createState() => _WordChapterSelectionPageState();
}

class _WordChapterSelectionPageState extends State<WordChapterSelectionPage> {
  final int totalChapters = 10; // 총 챕터 수
  List<int> _selectedChapters = []; // 선택된 챕터 목록

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 - 챕터 선택'),
      ),
      body: ListView.builder(
        itemCount: totalChapters,
        itemBuilder: (context, index) {
          int chapterNumber = index + 1;
          return CheckboxListTile(
            title: Text('챕터 $chapterNumber'),
            value: _selectedChapters.contains(chapterNumber),
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  _selectedChapters.add(chapterNumber);
                } else {
                  _selectedChapters.remove(chapterNumber);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedChapters.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordListPage(chapters: _selectedChapters),
              ),
            );
          } else {
            // 챕터를 선택하지 않았을 때 경고 메시지 표시
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('최소 하나의 챕터를 선택하세요.')),
            );
          }
        },
        child: const Icon(Icons.check),
        tooltip: '선택 완료',
      ),
    );
  }
}