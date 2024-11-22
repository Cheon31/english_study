// remember.dart

import 'dart:async'; // Timer 사용을 위해 추가
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'databaseConfig.dart';
import 'word.dart';

class RememberPage extends StatefulWidget {
  final List<int> chapters; // 챕터 목록을 받습니다.

  const RememberPage({Key? key, required this.chapters}) : super(key: key);

  @override
  State<RememberPage> createState() => _RememberPageState();
}

class _RememberPageState extends State<RememberPage> {
  final DatabaseService _databaseService = DatabaseService();
  List<Word> _words = [];
  List<Word> _testWords = [];
  int _currentIndex = 0;
  final FlutterTts flutterTts = FlutterTts();

  bool _showSecondWord = false; // 의미 또는 영어 단어 표시 여부를 제어
  bool _showEnglishFirst = true; // 단어 표시 순서를 제어하는 변수
  int _round = 1; // 순환 횟수

  @override
  void initState() {
    super.initState();
    _loadWords();
    _initTts();
  }

  @override
  void dispose() {
    flutterTts.stop(); // 진행 중인 TTS가 있으면 중지
    super.dispose();
  }

  void _loadWords() async {
    List<Word> words = await _databaseService.selectWordsByChapters(widget.chapters);
    setState(() {
      _words = words;
      _filterWords();
    });
  }

  void _filterWords() {
    // memorizedStatus가 2(못 외움) 또는 0(선택되지 않음)인 단어들만 남깁니다.
    setState(() {
      _testWords = _words.where((word) => word.memorizedStatus != 1).toList();
      _currentIndex = 0;
    });
  }

  void _initTts() {
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  void _updateCurrentIndex(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
      _showSecondWord = false; // 두 번째 단어를 처음에는 숨김
    });
    _speak(_showEnglishFirst ? _testWords[_currentIndex].name : _testWords[_currentIndex].meaning);
  }

  void _nextWord() {
    if (_testWords.isEmpty) return;

    if (_currentIndex < _testWords.length - 1) {
      _updateCurrentIndex(_currentIndex + 1);
    } else {
      // 한 바퀴 순환 완료
      _round++;
      _filterWords();

      // 순환 후에도 남은 단어가 없다면 종료
      if (_testWords.isEmpty) {
        setState(() {
          _currentIndex = 0;
        });
      } else {
        _updateCurrentIndex(0);
      }
    }
  }

  void _prevWord() {
    if (_testWords.isEmpty) return;

    if (_currentIndex > 0) {
      _updateCurrentIndex(_currentIndex - 1);
    } else {
      _updateCurrentIndex(_testWords.length - 1);
    }
  }

  void _toggleWordOrder() {
    setState(() {
      _showEnglishFirst = !_showEnglishFirst; // 단어 순서 토글
      _showSecondWord = false; // 두 번째 단어를 숨김
    });
    if (_testWords.isNotEmpty) {
      _speak(_showEnglishFirst ? _testWords[_currentIndex].name : _testWords[_currentIndex].meaning);
    }
  }

  void _toggleSecondWord() {
    setState(() {
      _showSecondWord = !_showSecondWord;
    });
  }

  void _updateWordStatus(Word word, int status) {
    setState(() {
      word.memorizedStatus = status;
    });
    _nextWord();
  }

  @override
  Widget build(BuildContext context) {
    String chaptersText = widget.chapters.join(', ');
    return Scaffold(
      appBar: AppBar(
        title: Text('챕터 $chaptersText 단어 암기 - $_round 회차'),
        actions: [
          IconButton(
            icon: Icon(_showEnglishFirst ? Icons.swap_horiz : Icons.swap_horiz_outlined),
            tooltip: _showEnglishFirst ? '한글-영어 순서로 변경' : '영어-한글 순서로 변경',
            onPressed: _toggleWordOrder,
          ),
        ],
      ),
      body: Center(
        child: _testWords.isEmpty
            ? Text(
          '모든 단어를 외웠습니다!',
          style: const TextStyle(fontSize: 24),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 첫 번째 단어 표시
            TextButton(
              onPressed: _toggleSecondWord,
              child: Text(
                _showEnglishFirst ? _testWords[_currentIndex].name : _testWords[_currentIndex].meaning,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 10),
            // 두 번째 단어를 조건부로 표시
            if (_showSecondWord)
              Text(
                _showEnglishFirst ? _testWords[_currentIndex].meaning : _testWords[_currentIndex].name,
                style: const TextStyle(fontSize: 24, color: Colors.grey),
              ),
            const SizedBox(height: 20),
            // "외움", "못 외움" 버튼 추가
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateWordStatus(_testWords[_currentIndex], 1); // 외움
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(100, 50),
                  ),
                  child: const Text('외움'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _updateWordStatus(_testWords[_currentIndex], 2); // 못 외움
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(100, 50),
                  ),
                  child: const Text('못 외움'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 이전, 다음 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _testWords.length > 1 ? _prevWord : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(100, 50),
                  ),
                  child: const Text('이전'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _testWords.length > 1 ? _nextWord : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(100, 50),
                  ),
                  child: const Text('다음'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}