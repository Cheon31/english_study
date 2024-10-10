import 'package:androidstduid/databaseConfig.dart';
import 'package:flutter/material.dart';
import 'word.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';




class RememberPage extends StatefulWidget {  // 화면 전환 클래스 이다
  const RememberPage({Key? key}) : super(key: key);

  @override
  State<RememberPage> createState() => _RememberPageState();
}

class _RememberPageState extends State<RememberPage> {  // 두 번째 페이지 접속한다.
  final DatabaseService _databaseService = DatabaseService(); // 데이터베이스 서비스 인스턴스
  late Future<List<Word>> _wordList; // 단어 리스트를 담을 Future
  int _currentIndex = 0; // 현재 표시 중인 단어의 인덱스
  final FlutterTts flutterTts = FlutterTts(); // TTS 인스턴스 생성

  @override

  void initState() {  // 데이터베이스 초기화
    super.initState();

    // 데이터베이스에서 단어 리스트를 가져옵니다.
    _wordList = _databaseService.databaseConfig().then((_) => _databaseService.selectWords());
    _initTts();
  }// 데이터 베이스 초기화 하는 코드 이다

  void _initTts() {
    flutterTts.setLanguage("en-US"); // 언어 설정
    flutterTts.setSpeechRate(0.5); // 말하기 속도 설정 (0.0 ~ 1.0)
    flutterTts.setPitch(1.0); // 음성 톤 설정 (0.5 ~ 2.0)
  }  //  tts초기화 하는 코드 부분이다 해당 과정을 해서 이 애가 소리 내면서 말 할수 이싿.

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  } // tts 관련 설정 항목들 저장 되어 있다.


  void _nextWord(List<Word> words) {
    setState(() {
      if (_currentIndex < words.length - 1) {
        _currentIndex++;
      } else {
        // 마지막 단어인 경우 처음으로 돌아갑니다.
        _currentIndex = 0;
      }
    });
  }  // 영어단어 되우는데 버튼의 기능 활당

  void _prevWord(List<Word> words) {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      } else {
        // 첫 번째 단어인 경우 마지막으로 이동합니다.
        _currentIndex = words.length - 1;
      }
    });
  } // 영어단어 되우는데 버튼의 기능 활당한다.

  // 각종 패키지 초기화 하는 부분이 저장 되어 있다.

  // 아랫 부분은 직접적인 화면 출력을 담당하고 있다.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영어단어 외우기'),
      ),
      body: Center(
        child: FutureBuilder<List<Word>>(
          future: _wordList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Word> words = snapshot.data!;
              if (words.isEmpty) {
                return const Text('저장된 단어가 없습니다.');
              } else {
                Word currentWord = words[_currentIndex];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,  // 가운대에 위젯 배치 한다.
                  children: [
                    Text(  // 해당 부분에서 TEXT단어 출력한다.
                      currentWord.name,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 10),
                    Text(  // 해당 부분에서 뜻을 출력한다.
                      currentWord.meaning,
                      style: const TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Row(  // 밑의 버튼 부분을 ROW 형태로 출력한다.
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: words.length > 1  // 단어가 저장되어 있을때..
                              ? () {
                            _prevWord(words);
                            _speak(currentWord.name);
                          }
                              : null,
                          child: const Text('이전'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: words.length > 1 ? (){
                            _nextWord(words);
                            _speak(currentWord.name); // 단어 송출 부분이다
                          }: null,
                          child: const Text('다음'),
                        ),
                      ],
                    ),
                  ],
                );
              }
            } else if (snapshot.hasError) {
              return const Text('에러 발생 코드 다시 짜기');
            } else {
              return const CircularProgressIndicator();  // 데이터 로딩 중인 경우 동그라이 인디케이터 나타내는 부분이다
            }
          },
        ),
      ),
    );
  }  // 2. 영어 단어 출력 하는 부분 포함 되어 있다.
}
