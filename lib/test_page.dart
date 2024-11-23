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
  late List<Word> _words = [];
  late List<Word> _testWords = []; // 테스트할 단어 리스트
  int _currentIndex = 0;
  Map<Word, bool> _results = {}; // 단어별 정답 여부 저장
  bool isLoading = true;

  // 피드백 표시 상태 변수
  bool showFeedback = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  // 챕터 99인 단어만 조회하도록 수정
  void _loadWords() async {
    setState(() {
      isLoading = true;
    });
    List<Word> words = await _databaseService.selectWordsByChapters(widget.chapters);
    setState(() {
      _words = words;
      _testWords = List.from(_words);
      _testWords.shuffle(); // 단어들을 섞습니다.
      _currentIndex = 0;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 테스트'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _testWords.isEmpty
                ? const Center(child: Text('선택한 챕터에 단어가 없습니다.'))
                : _currentIndex >= _testWords.length
                ? _navigateToResultPage()
                : _buildTestContent(),
          ),
          // 피드백 오버레이
          if (showFeedback) _buildFeedbackOverlay(),
        ],
      ),
    );
  }

  // 테스트 완료 시 결과 페이지로 이동
  Widget _navigateToResultPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TestResultPage(results: _results),
        ),
      );
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // 테스트 콘텐츠 빌드
  Widget _buildTestContent() {
    Word currentWord = _testWords[_currentIndex];
    List<String> options = _generateOptions(currentWord);

    return Column(
      children: [
        Text(
          currentWord.name,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2, // 2열로 설정하여 2x2 그리드 형성
            crossAxisSpacing: 20.0, // 가로 간격 설정
            mainAxisSpacing: 20.0, // 세로 간격 설정
            childAspectRatio: 3, // 버튼의 가로세로 비율
            children: options.map((option) {
              return ElevatedButton(
                onPressed: () => _handleOptionSelected(option),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  backgroundColor: Colors.blue, // 버튼의 기본 색상
                ),
                child: Text(
                  option,
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // 옵션 선택 시 처리 로직
  void _handleOptionSelected(String selectedOption) async {
    if (showFeedback) return; // 피드백 표시 중이면 무시

    Word currentWord = _testWords[_currentIndex];
    bool correct = selectedOption == currentWord.meaning;
    _results[currentWord] = correct;

    if (correct) {
      // 정답일 경우 remember 카운터 증가
      currentWord.remember += 1;
      await _databaseService.updateWord(currentWord);
    }

    setState(() {
      isCorrect = correct;
      showFeedback = true;
    });

    // 피드백 표시 후 1초 후에 다음 단어로 이동
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      showFeedback = false;
      _currentIndex++;
    });
  }

  // 피드백 오버레이 빌드
  Widget _buildFeedbackOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black54, // 반투명 검은색 배경
        child: Center(
          child: isCorrect
              ? Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 100,
            ),
          )
              : Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 100,
            ),
          ),
        ),
      ),
    );
  }

  // 옵션 생성 로직
  List<String> _generateOptions(Word correctWord) {
    List<String> options = [correctWord.meaning];

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