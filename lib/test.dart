// test.dart

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'chapter_world_list.dart';
import 'databaseConfig.dart';

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
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: GridView.builder(
                      itemCount: chapters.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 한 행에 3개의 버튼
                        mainAxisSpacing: 40.0, // 행 간격을 40으로 증가
                        crossAxisSpacing: 40.0, // 열 간격을 40으로 증가
                        childAspectRatio: 1.0, // 정사각형 비율로 설정
                      ),
                      itemBuilder: (context, index) {
                        int chapter = chapters[index];
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0), // 버튼 내부 패딩 조정
                            backgroundColor: Colors.blueAccent, // 'primary'를 'backgroundColor'로 변경
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0), // 버튼의 모서리를 둥글게
                            ),
                            elevation: 5.0, // 그림자 효과 추가
                          ),
                          onPressed: () {
                            // 해당 챕터의 단어 리스트 화면으로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChapterWordListPage(chapter: chapter),
                              ),
                            );
                          },
                          child: Text(
                            '챕터 $chapter',
                            style: const TextStyle(
                              fontSize: 20.0, // 텍스트 크기 조정
                              fontWeight: FontWeight.bold, // 텍스트 두께 조정
                              color: Colors.white, // 텍스트 색상 흰색으로 설정
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // 선택 완료 버튼 추가
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // SnackBar 메시지 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('이전에 맞춘 단어는 이번 턴에서는 제외 합니다'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      backgroundColor: Colors.green, // 원하는 색상으로 변경 가능
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5.0,
                    ),
                    child: const Text(
                      '선택 완료',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
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