// test_page.dart

import 'package:flutter/material.dart';
import 'databaseConfig.dart';
import 'word.dart';
import 'test_result_page.dart'; // 테스트 결과 페이지 (다음 단계에서 생성)


class TestPage extends StatefulWidget {
  final List<int> chapters;

  const TestPage({Key? key, required this.chapters}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final DatabaseService _databaseService = DatabaseService();
  late List<Word> _words =[];
  late List<Word> _testWords =[]; // 테스트할 단어 리스트
  int _currentIndex = 0;
  Map<Word, bool> _results = {}; // 단어별 정답 여부 저장
  bool isloading =true;

  @override
  void initState() {
    super.initState();
    _loadWords();
    isloading =false;
  }

  void _loadWords() async {
    List<Word> words = await _databaseService.selectWordsByChapters(widget.chapters);
    setState(() {
      _words = words;
      _testWords = List.from(_words);
      _testWords.shuffle(); // 단어들을 섞습니다.
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_testWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('단어 테스트'),
        ),
        body: const Center(
          child: Text('선택한 챕터에 단어가 없습니다.'),
        ),
      );
    }

    if (_currentIndex >= _testWords.length) {
      // 테스트 완료 시 결과 페이지로 이동
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TestResultPage(results: _results),
          ),
        );
      });
      return Scaffold(
        appBar: AppBar(
          title: const Text('단어 테스트'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Word currentWord = _testWords[_currentIndex];
    List<String> options = _generateOptions(currentWord);

    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 테스트'),
      ),
      body: isloading             //데이터가 다 안받아졌으면 로딩동그라미가 돈다
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              currentWord.name,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3,
                children: options.map((option) {
                  return ElevatedButton(
                    onPressed: () async {
                      bool isCorrect = option == currentWord.meaning;
                      _results[currentWord] = isCorrect;
                      if (isCorrect) {
                        // 정답일 경우 remember 카운터 증가
                        currentWord.remember += 1;
                        await _databaseService.updateWord(currentWord);
                      }
                      setState(() {
                        _currentIndex++;
                      });
                    },
                    child: Text(option),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _generateOptions(Word correctWord) {
    List<String> options = [];
    options.add(correctWord.meaning);

    List<Word> tempWords = List.from(_words);
    tempWords.removeWhere((word) => word.meaning == correctWord.meaning);
    tempWords.shuffle();

    for (int i = 0; i < 3 && i < tempWords.length; i++) {
      options.add(tempWords[i].meaning);
    }

    options.shuffle();
    return options;
  }
}