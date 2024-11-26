// word_chapter_list_page.dart

import 'package:flutter/material.dart';
import 'databaseConfig.dart';
import 'word.dart';

class WordChapterListPage extends StatefulWidget {
  const WordChapterListPage({Key? key}) : super(key: key);

  @override
  _WordChapterListPageState createState() => _WordChapterListPageState();
}

class _WordChapterListPageState extends State<WordChapterListPage> {
  final DatabaseService _databaseService = DatabaseService();
  final int totalChapters = 10; // 총 챕터 수
  final int userSavedChapter = 99; // 사용자 저장 단어 챕터 번호
  Map<int, Future<List<Word>>> _chapterWords = {};
  String _searchQuery = ''; // 검색 쿼리

  @override
  void initState() {
    super.initState();
    // 챕터 1~10과 사용자 저장 단어 챕터 99의 단어를 불러옵니다.
    for (int i = 1; i <= totalChapters; i++) {
      _chapterWords[i] = _databaseService.selectWords(chapter: i);
    }
    _chapterWords[userSavedChapter] =
        _databaseService.selectWords(chapter: userSavedChapter);
  }

  @override
  Widget build(BuildContext context) {
    // 검색된 챕터 리스트 필터링 (챕터 1~10)
    List<int> filteredChapters = List.generate(totalChapters, (index) => index + 1)
        .where((chapter) => '챕터 $chapter'.contains(_searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: '도움말',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('도움말'),
                  content: const Text('원하는 챕터를 확장하여 단어 목록을 확인하세요.'),
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
                child: ListView(
                  children: [
                    // 챕터 1~10 목록
                    ...filteredChapters.map((chapterNumber) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ExpansionTile(
                          leading: Icon(
                            Icons.book,
                            color: Colors.green.shade700,
                          ),
                          title: Text(
                            '챕터 $chapterNumber',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                              fontSize: 18,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: FutureBuilder<List<Word>>(
                                future: _chapterWords[chapterNumber],
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '오류 발생: ${snapshot.error}',
                                        style:
                                        TextStyle(color: Colors.red.shade700),
                                      ),
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '단어 없음',
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    );
                                  } else {
                                    List<Word> words = snapshot.data!;
                                    return Column(
                                      children: words.map((word) {
                                        return Card(
                                          color: Colors.green.shade50,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: ExpansionTile(
                                            leading: Icon(
                                              Icons.arrow_right,
                                              color: Colors.green.shade400,
                                            ),
                                            title: Text(
                                              word.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.green.shade800,
                                              ),
                                            ),
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '뜻: ${word.meaning}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                    Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                              TextButton(onPressed: () {
                                                String name = word.name;
                                                String meaning = word.meaning;
                                                int chapter =99;
                                                _databaseService.insertWord(
                                                  Word(
                                                    name: name,
                                                    meaning: meaning,
                                                    chapter: chapter,
                                                    isPreloaded: false, // 사용자 추가 단어임을 명시
                                                  ),
                                                ).then((result) {
                                                  if (result) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('단어가 추가되었습니다.')),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('단어 추가에 실패했습니다.')),
                                                    );
                                                  }
                                                });
                                              },
                                                  child: Text(
                                                    '마이리스트 추가',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                      Colors.grey.shade600,
                                                    ),
                                                  ),
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    // 사용자 저장단어 섹션 추가
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.star,
                          color: Colors.green.shade700,
                        ),
                        title: Text(
                          '사용자 저장단어',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                            fontSize: 18,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: FutureBuilder<List<Word>>(
                              future: _chapterWords[userSavedChapter],
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '오류 발생: ${snapshot.error}',
                                      style:
                                      TextStyle(color: Colors.red.shade700),
                                    ),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '단어 없음',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  );
                                } else {
                                  List<Word> words = snapshot.data!;
                                  return Column(
                                    children: words.map((word) {
                                      return Card(
                                        color: Colors.green.shade50,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: ExpansionTile(
                                          leading: Icon(
                                            Icons.arrow_right,
                                            color: Colors.green.shade400,
                                          ),
                                          title: Text(
                                            word.name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green.shade800,
                                            ),
                                          ),
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Text(
                                                '뜻: ${word.meaning}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // 플로팅 액션 버튼 제거
    );
  }
}