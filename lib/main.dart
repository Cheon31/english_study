// main.dart

import 'package:flutter/material.dart';
import 'Test_chapter_selection_page.dart';
import 'mylist.dart'; // 기존 리스트 페이지
import 'chapter_list_page.dart'; // 기존 스터디용 챕터 선택 페이지
import 'word_chapter_selection_page.dart'; // 새로 생성할 단어용 챕터 선택 페이지
import 'package:google_fonts/google_fonts.dart'; // Google Fonts 사용
import 'word_chapter_list_page.dart'; // 새로 생성한 페이지 import

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
        secondary: Colors.orangeAccent,
      ),
      scaffoldBackgroundColor: Colors.white,
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
      textTheme: GoogleFonts.notoSansTextTheme(base.textTheme).copyWith(
        headlineSmall: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyMedium: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        labelLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      themeMode: ThemeMode.system,
      home: const MainPage(title: '영어 단어장'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatelessWidget {
  final String title;

  const MainPage({Key? key, required this.title}) : super(key: key);

  // 버튼 아이콘을 위한 데이터 리스트
  final List<_MainButtonData> buttonData = const [
    _MainButtonData(title: '스터디', icon: Icons.school),
    _MainButtonData(title: '단어들', icon: Icons.library_books), // "리스트"와 "단어"를 합친 버튼
    _MainButtonData(title: '테스트', icon: Icons.quiz),
    _MainButtonData(title: '단어 목록들', icon: Icons.library_books), // 기존 "단어 목록들" 버튼
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$title 메인 화면',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      color: Colors.white,
                      onPressed: () {
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
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1.0,
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
                            case '단어들':
                            // 변경된 부분: 다이얼로그 대신 바로 HomePage로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(), // "사용자가 저장한 단어 출력" 페이지로 직접 이동
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
                            case '단어 목록들': // 기존 "단어 목록들" 버튼의 동작 정의
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WordChapterListPage(),
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
                          backgroundColor: Colors.white.withOpacity(0.8),
                          foregroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
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

class _MainButtonData {
  final String title;
  final IconData icon;

  const _MainButtonData({required this.title, required this.icon});
}