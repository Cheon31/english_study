import 'package:androidstduid/databaseConfig.dart';
import 'package:flutter/material.dart';
import 'list.dart';
import 'remember.dart';
import 'word.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 앱의 첫 화면을 NewHomePage로 설정
    return const MaterialApp(title: 'Flutter App', home: NewHomePage());
  }
}



class NewHomePage extends StatefulWidget {
  const NewHomePage({Key? key}) : super(key: key);

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

// 초기 구동하는 명령어 시리즈 이다(위엣 부분)

class _NewHomePageState extends State<NewHomePage> {// 앱 실행시 우선적으로 선택화면 뜬다
  @override


  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('영단어 암기 앱'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // 컬럼의 높이를 자식들의 높이에 맞춤
          children: [
            ElevatedButton(
              onPressed: () {
                // 첫 번째 버튼 눌렀을 때의 동작
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()), // 영어단어장 탭으로 이동
                );
              },
              child: const Text('데이터베이스 저장된 단어장으로 이동'),
            ),
            const SizedBox(height: 20), // 버튼 사이의 간격
            ElevatedButton(
              onPressed: () {
                // 두 번째 버튼 눌렀을 때의 동작
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RememberPage()),  // 영단어 외우는 화면 구현
                );
              },
              child: const Text('영어단어 외우는 화면으로 전환'),
            ),
          ],
        ),
      ),
    );
  }  // 앱 실행시 메인 화면 추출 부분 이다.
}




 // 1.단어장이 출력되는 부분이 포함 되어 있다.