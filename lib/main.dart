// main.dart

import 'package:flutter/material.dart';
import 'Test_chapter_selection_page.dart';
import 'list.dart'; // 기존 리스트 페이지
import 'chapter_list_page.dart'; // 기존 스터디용 챕터 선택 페이지
import 'word_chapter_selection_page.dart'; // 새로 생성할 단어용 챕터 선택 페이지
import 'package:google_fonts/google_fonts.dart'; // Google Fonts 사용

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // 커스텀 테마 정의
  ThemeData _buildTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: Colors.teal,
      colorScheme: base.colorScheme.copyWith(
        secondary: Colors.orangeAccent, // accentColor 대체
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal, // primary → backgroundColor
          foregroundColor: Colors.white, // onPrimary → foregroundColor
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // 버튼 모서리 둥글게
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textTheme: GoogleFonts.notoSansTextTheme(base.textTheme).copyWith(
        headlineSmall: const TextStyle( // headline6 → headlineSmall
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyMedium: const TextStyle( // bodyText2 → bodyMedium
          fontSize: 16,
          color: Colors.black87,
        ),
        labelLarge: const TextStyle( // button → labelLarge
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 앱의 첫 화면을 MainPage로 설정하고 커스텀 테마 적용
    return MaterialApp(
      title: '영단어 암기 앱',
      theme: _buildTheme(),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          secondary: Colors.orangeAccent,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textTheme: GoogleFonts.notoSansTextTheme(ThemeData.dark().textTheme).copyWith(
          headlineSmall: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
          labelLarge: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      themeMode: ThemeMode.system, // 시스템 테마에 따라 자동 전환
      home: const MainPage(title: '영어 단어장'),
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
    );
  }
}

class MainPage extends StatelessWidget {
  final String title;

  const MainPage({Key? key, required this.title}) : super(key: key);

  // 버튼 아이콘을 위한 데이터 리스트
  final List<_MainButtonData> buttonData = const [
    _MainButtonData(title: '스터디', icon: Icons.school),
    _MainButtonData(title: '리스트', icon: Icons.list),
    _MainButtonData(title: '테스트', icon: Icons.quiz),
    _MainButtonData(title: '단어', icon: Icons.book),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 그라데이션 배경 적용
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.lightGreenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 커스텀 AppBar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$title 메인 화면',
                      style: Theme.of(context).textTheme.headlineSmall, // 수정된 텍스트 스타일
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      color: Colors.white,
                      onPressed: () {
                        // 설정 페이지로 이동 (필요 시 구현)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('설정 페이지는 아직 구현되지 않았습니다.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.builder(
                    itemCount: buttonData.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2열 그리드
                      mainAxisSpacing: 20, // 세로 간격
                      crossAxisSpacing: 20, // 가로 간격
                      childAspectRatio: 1.0, // 정사각형 비율
                    ),
                    itemBuilder: (context, index) {
                      final button = buttonData[index];
                      return ElevatedButton(
                        onPressed: () {
                          switch (button.title) {
                            case '스터디':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChapterListPage(),
                                ),
                              );
                              break;
                            case '리스트':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                              break;
                            case '테스트':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TestChapterSelectionPage(),
                                ),
                              );
                              break;
                            case '단어':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WordChapterSelectionPage(),
                                ),
                              );
                              break;
                            default:
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('페이지가 존재하지 않습니다.')),
                              );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.8), // backgroundColor
                          foregroundColor: Colors.teal, // foregroundColor
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16), // 버튼 모서리 둥글게
                          ),
                          elevation: 5,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              button.icon,
                              size: 50,
                              color: Colors.teal,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              button.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // 하단 텍스트 또는 기타 위젯 추가 가능
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '© 2024 5조 .',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 버튼 데이터를 위한 클래스
class _MainButtonData {
  final String title;
  final IconData icon;

  const _MainButtonData({required this.title, required this.icon});
}