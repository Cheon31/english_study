// test_chapter_selection_page.dart

import 'package:flutter/material.dart';
import 'test_page.dart'; // 테스트 진행 페이지

class TestChapterSelectionPage extends StatefulWidget {
  const TestChapterSelectionPage({Key? key}) : super(key: key);

  @override
  _TestChapterSelectionPageState createState() =>
      _TestChapterSelectionPageState();
}

class _TestChapterSelectionPageState extends State<TestChapterSelectionPage> {
  final int totalChapters = 10; // 총 챕터 수
  List<int> _selectedChapters = []; // 선택된 챕터 목록
  String _searchQuery = ''; // 검색 쿼리

  // 챕터 목록 초기화
  late List<Map<String, dynamic>> chapters;

  @override
  void initState() {
    super.initState();
    // 챕터 1~10 생성
    chapters = List.generate(totalChapters, (index) => {
      'number': index + 1,
      'title': '챕터 ${index + 1}',
      'icon': Icons.book,
    });
    // 사용자 저장단어 추가 (챕터 99)
    chapters.add({
      'number': 99,
      'title': '사용자 저장단어',
      'icon': Icons.star,
    });
  }

  @override
  Widget build(BuildContext context) {
    // 검색된 챕터 필터링
    List<Map<String, dynamic>> filteredChapters = chapters
        .where((chapter) =>
        chapter['title'].toString().contains(_searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('테스트 - 챕터 선택'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: '도움말',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('도움말'),
                  content: const Text(
                      '원하는 챕터를 선택한 후 완료 버튼을 눌러주세요.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 검색 바 추가
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: '챕터 검색',
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredChapters.isNotEmpty
                    ? ListView.builder(
                  itemCount: filteredChapters.length,
                  itemBuilder: (context, index) {
                    var chapter = filteredChapters[index];
                    int chapterNumber = chapter['number'];
                    String chapterTitle = chapter['title'];
                    IconData chapterIcon = chapter['icon'];
                    bool isSelected =
                    _selectedChapters.contains(chapterNumber);
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(
                          chapterIcon,
                          color: isSelected
                              ? Colors.green
                              : Colors.grey.shade700,
                        ),
                        title: Text(
                          chapterTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.green
                                : Colors.grey.shade800,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null && value) {
                                _selectedChapters.add(chapterNumber);
                              } else {
                                _selectedChapters.remove(chapterNumber);
                              }
                            });
                          },
                          activeColor: Colors.green,
                        ),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedChapters.remove(chapterNumber);
                            } else {
                              _selectedChapters.add(chapterNumber);
                            }
                          });
                        },
                      ),
                    );
                  },
                )
                    : const Center(
                  child: Text(
                    '검색 결과가 없습니다.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (_selectedChapters.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TestPage(chapters: _selectedChapters),
                      ),
                    );
                  } else {
                    // 챕터를 선택하지 않았을 때 경고 메시지 표시
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('최소 하나의 챕터를 선택하세요.')),
                    );
                  }
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('선택 완료'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}