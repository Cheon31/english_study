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
  late Future<List<Word>> _wordList;
  int _currentIndex = 0;
  final FlutterTts flutterTts = FlutterTts();

  bool _showSecondWord = false; // 의미 또는 영어 단어 표시 여부를 제어
  Timer? _meaningTimer; // 의미 표시 지연을 위한 타이머
  bool _showEnglishFirst = true; // 단어 표시 순서를 제어하는 변수

  @override
  void initState() {
    super.initState();
    _loadWords();
    _initTts();
  }

  @override
  void dispose() {
    _meaningTimer?.cancel(); // 활성화된 타이머가 있으면 취소
    flutterTts.stop(); // 진행 중인 TTS가 있으면 중지
    super.dispose();
  }

  void _loadWords() {
    setState(() {
      _wordList = _databaseService.selectWordsByChapters(widget.chapters);
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

  void _showSecondWordWithDelay() {
    // 기존 타이머가 있으면 취소
    _meaningTimer?.cancel();
  }

  void _updateCurrentIndex(int newIndex, List<Word> words) {
    setState(() {
      _currentIndex = newIndex;
      _showSecondWord = false; // 두 번째 단어를 처음에는 숨김
    });
    _showSecondWordWithDelay(); // 두 번째 단어 표시 타이머 시작
    _speak(_showEnglishFirst ? words[_currentIndex].name : words[_currentIndex].meaning);
  }

  void _nextWord(List<Word> words) {
    if (words.isEmpty) return;
    int newIndex = (_currentIndex < words.length - 1) ? _currentIndex + 1 : 0;
    _updateCurrentIndex(newIndex, words);
  }

  void _prevWord(List<Word> words) {
    if (words.isEmpty) return;
    int newIndex = (_currentIndex > 0) ? _currentIndex - 1 : words.length - 1;
    _updateCurrentIndex(newIndex, words);
  }

  void _toggleWordOrder() {
    setState(() {
      _showEnglishFirst = !_showEnglishFirst; // 단어 순서 토글
      _showSecondWord = false; // 두 번째 단어를 숨김
    });
    // 현재 단어의 순서를 변경하므로 타이머를 재설정
    if (_wordList is Future<List<Word>>) {
      _wordList.then((words) {
        if (words.isNotEmpty) {
          _meaningTimer?.cancel();
          _showSecondWordWithDelay();
          _speak(_showEnglishFirst ? words[_currentIndex].name : words[_currentIndex].meaning);
        }
      });
    }
  }

  void whenWordButton(){
    setState(() {
      if(_showSecondWord){
        _showSecondWord = false;
      }else{
        _showSecondWord = true;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    String chaptersText = widget.chapters.join(', ');
    return Scaffold(
      appBar: AppBar(
        title: Text('챕터 $chaptersText 단어 암기'),
        actions: [
          IconButton(
            icon: Icon(_showEnglishFirst ? Icons.swap_horiz : Icons.swap_horiz_outlined),
            tooltip: _showEnglishFirst ? '한글-영어 순서로 변경' : '영어-한글 순서로 변경',
            onPressed: _toggleWordOrder,
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Word>>(
          future: _wordList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Word> words = snapshot.data!;
              if (words.isEmpty) {
                return const Text('선택한 챕터에 단어가 없습니다.');
              } else {
                // _currentIndex가 단어 목록 범위를 벗어나지 않도록 확인
                if (_currentIndex >= words.length) {
                  _currentIndex = 0;
                }
                Word currentWord = words[_currentIndex];

                // 새로운 단어가 로드될 때 의미 표시 타이머 시작
                // 이는 위젯이 처음 빌드될 때도 동작
                if (!_showSecondWord) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showSecondWordWithDelay();
                    _speak(_showEnglishFirst ? currentWord.name : currentWord.meaning);
                  });
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 첫 번째 단어 표시
                    TextButton(onPressed: (){
                      whenWordButton();
                    },
                      child: Text(
                      _showEnglishFirst ? currentWord.name : currentWord.meaning,
                      style: const TextStyle(fontSize: 32),
                    ),
                    ),

                    const SizedBox(height: 10),
                    // 두 번째 단어를 조건부로 표시
                    if (_showSecondWord)
                      Text(
                        _showEnglishFirst ? currentWord.meaning : currentWord.name,
                        style: const TextStyle(fontSize: 24, color: Colors.grey),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: words.length > 1 ? () => _prevWord(words) : null,
                          child: const Text('이전'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: words.length > 1 ? () => _nextWord(words) : null,
                          child: const Text('다음'),
                        ),
                      ],
                    ),
                  ],
                );
              }
            } else if (snapshot.hasError) {
              return const Text('에러가 발생했습니다.');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}