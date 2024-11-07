// word_chapter_page.dart
// 메인 메뉴에서 '단어' 누르면 이 페이지로 옴.
// 각 chapter 누르면 안에 있는 단어가 좌르륵 열림

import 'package:flutter/material.dart';

class WordChapterPage extends StatelessWidget {
  const WordChapterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 챕터 선택'),
      ),
      body: ListView.builder(
        itemCount: 10, // 총 10개의 챕터
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text('챕터 ${index + 1}'),
            children: [
              // 단어 목록을 표시합니다. (현재는 예시로 "단어 1", "단어 2" 등 표시)
              ListTile(
                title: Text('단어 1'),
                onTap: () {
                  // 단어를 선택했을 때의 동작 (추후 구현 예정)
                },
              ),
              ListTile(
                title: Text('단어 2'),
                onTap: () {
                  // 단어를 선택했을 때의 동작 (추후 구현 예정)
                },
              ),
              // 추가 단어를 나열할 수 있습니다.
            ],
          );
        },
      ),
    );
  }
}
