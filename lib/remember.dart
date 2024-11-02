// remember.dart

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'databaseConfig.dart';
import 'word.dart';

class RememberPage extends StatefulWidget {
  final List<int> chapters; // 변경: 챕터 목록을 받습니다.

  const RememberPage({Key? key, required this.chapters}) : super(key: key);

  @override
  State<RememberPage> createState() => _RememberPageState();
}

class _RememberPageState extends State<RememberPage> {
  final DatabaseService _databaseService = DatabaseService();
  late Future<List<Word>> _wordList;
  int _currentIndex = 0;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _loadWords();
    _initTts();
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

  void _nextWord(List<Word> words) {
    setState(() {
      if (_currentIndex < words.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
    });
    _speak(words[_currentIndex].name);
  }

  void _prevWord(List<Word> words) {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      } else {
        _currentIndex = words.length - 1;
      }
    });
    _speak(words[_currentIndex].name);
  }

  @override
  Widget build(BuildContext context) {
    String chaptersText = widget.chapters.join(', ');
    return Scaffold(
      appBar: AppBar(
        title: Text('챕터 $chaptersText 단어 암기'),
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
                Word currentWord = words[_currentIndex];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentWord.name,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentWord.meaning,
                      style:
                      const TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: words.length > 1
                              ? () => _prevWord(words)
                              : null,
                          child: const Text('이전'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: words.length > 1
                              ? () => _nextWord(words)
                              : null,
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