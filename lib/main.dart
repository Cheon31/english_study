// main.dart

import 'package:flutter/material.dart';
import 'Test_chapter_selection_page.dart';
import 'list.dart'; // 기존 리스트 페이지
import 'chapter_list_page.dart'; // 기존 스터디용 챕터 선택 페이지
import 'word_chapter_page.dart'; // 새로운 단어 챕터 페이지

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 앱의 첫 화면을 MainPage로 설정
    return const MaterialApp(
      title: '영단어 암기 앱',
      home: MainPage(title: '영어 단어장'),
    );
  }
}

class MainPage extends StatelessWidget {
  final String title;

  const MainPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title 메인 화면'),
      ),
      body: Center(
        child: GridView.count(
          shrinkWrap: true, // GridView의 높이를 자식 요소에 맞춥니다.
          crossAxisCount: 2, // 열의 수를 2로 설정하여 2x2 그리드를 만듭니다.
          mainAxisSpacing: 20, // 행 사이의 간격
          crossAxisSpacing: 20, // 열 사이의 간격
          padding: const EdgeInsets.all(20), // 그리드의 패딩
          children: [
            SizedBox(
              width: double.infinity,
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // 모서리를 직각으로 설정
                  ),
                ),
                child: const Text('스터디'),
                onPressed: () {
                  // 스터디용 챕터 선택 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChapterListPage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // 모서리를 직각으로 설정
                  ),
                ),
                child: const Text('리스트'),
                onPressed: () {
                  // 단어 리스트 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // 모서리를 직각으로 설정
                  ),
                ),
                child: const Text('테스트'),
                onPressed: () {
                  // 테스트용 챕터 선택 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TestChapterSelectionPage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // 모서리를 직각으로 설정
                  ),
                ),
                child: const Text('단어'),
                onPressed: () {
                  // 단어 챕터 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WordChapterPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}