// test.dart

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseConfig.dart';
import 'chapter_world_list.dart';

class TestPageContent extends StatefulWidget {
  const TestPageContent({Key? key}) : super(key: key);

  @override
  State<TestPageContent> createState() => _TestPageContentState();
}

class _TestPageContentState extends State<TestPageContent> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('챕터 선택'),
      ),
      body: FutureBuilder<List<int>>(
        future: _getChapters(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<int> chapters = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: chapters.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 행에 2개의 버튼
                mainAxisSpacing: 20.0, // 행 간격
                crossAxisSpacing: 20.0, // 열 간격
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) {
                int chapter = chapters[index];
                return ElevatedButton(
                  onPressed: () {
                    // 해당 챕터의 단어 리스트 화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChapterWordListPage(chapter: chapter),
                      ),
                    );
                  },
                  child: Text('챕터 $chapter'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('에러가 발생했습니다.'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<int>> _getChapters() async {
    final Database db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT DISTINCT chapter FROM words ORDER BY chapter',
    );
    return result.map((e) => e['chapter'] as int).toList();
  }
}