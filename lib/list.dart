// list.dart

import 'package:flutter/material.dart';
import 'databaseConfig.dart';
import 'word.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  late Future<List<Word>> _wordList;

  @override
  void initState() {
    super.initState();
    _loadWordList();
  }

  // 챕터 99인 단어만 조회하도록 수정
  void _loadWordList() {
    setState(() {
      _wordList = _databaseService.selectWords(chapter: 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('단어장 목록'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nameController.clear();
          _meaningController.clear();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => addWordDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Word>>(
          future: _wordList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text("어떠한 영어단어 정보가 없습니다."));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Word word = snapshot.data![index];
                    return wordBox(
                      word.id!,
                      word.name,
                      word.meaning,
                      word.isPreloaded,
                    );
                  },
                );
              }
            } else if (snapshot.hasError) {
              return const Center(child: Text("에러가 발생했습니다."));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  // 챕터 정보가 필요 없으므로 제거하고, isPreloaded만 받도록 수정
  Widget wordBox(int id, String name, String meaning, bool isPreloaded) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // isPreloaded에 따라 아이콘 변경
            Icon(
              isPreloaded ? Icons.star : Icons.book,
              color: isPreloaded ? Colors.orange : Colors.teal,
            ),
            const SizedBox(width: 10),
            // 단어 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    meaning,
                    style: const TextStyle(fontSize: 16),
                  ),
                  // 챕터 정보 표시 제거
                  // Text(
                  //   '챕터 $chapter',
                  //   style: const TextStyle(fontSize: 14, color: Colors.grey),
                  // ),
                ],
              ),
            ),
            // 수정 및 삭제 버튼
            if (!isPreloaded) // 기본 단어는 수정 및 삭제 불가
              Row(
                children: [
                  updateButton(id),
                  const SizedBox(width: 10),
                  deleteButton(id),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget updateButton(int id) {
    return ElevatedButton(
      onPressed: () {
        Future<Word> word = _databaseService.selectWord(id);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => updateWordDialog(word),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      child: const Icon(Icons.edit),
    );
  }

  Widget deleteButton(int id) {
    return ElevatedButton(
      onPressed: () => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => deleteWordDialog(id),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
      ),
      child: const Icon(Icons.delete),
    );
  }

  Widget addWordDialog() {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "단어 추가",
            style: TextStyle(color: Colors.black), // 글자 색상을 검정으로 설정
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 단어 이름 입력
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "단어를 입력하세요.",
                hintStyle: TextStyle(color: Colors.black), // 힌트 텍스트 색상도 검정으로 설정
              ),
              style: const TextStyle(color: Colors.black), // 입력 텍스트 색상 검정으로 설정
            ),
            const SizedBox(height: 15),
            // 단어 의미 입력
            TextField(
              controller: _meaningController,
              decoration: const InputDecoration(
                hintText: "뜻을 입력하세요.",
                hintStyle: TextStyle(color: Colors.black), // 힌트 텍스트 색상도 검정으로 설정
              ),
              style: const TextStyle(color: Colors.black), // 입력 텍스트 색상 검정으로 설정
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text.trim();
                String meaning = _meaningController.text.trim();

                if (name.isEmpty || meaning.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('단어와 뜻을 모두 입력해주세요.')),
                  );
                  return;
                }

                // 챕터를 자동으로 설정 (99)
                int chapter = 99;

                _databaseService.insertWord(
                  Word(
                    name: name,
                    meaning: meaning,
                    chapter: chapter,
                    isPreloaded: false, // 사용자 추가 단어임을 명시
                  ),
                ).then((result) {
                  if (result) {
                    Navigator.of(context).pop();
                    _loadWordList();
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
              child: const Text("생성"),
            ),
          ],
        ),
      ),
    );
  }

  Widget updateWordDialog(Future<Word> wordFuture) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "단어 수정",
            style: TextStyle(color: Colors.black), // 텍스트 색상 설정
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: FutureBuilder<Word>(
        future: wordFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Word word = snapshot.data!;
            if (word.isPreloaded) {
              return const Text("기본 탑제된 단어는 수정할 수 없습니다.");
            }

            _nameController.text = word.name;
            _meaningController.text = word.meaning;

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: "단어를 입력하세요."),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _meaningController,
                    decoration: const InputDecoration(hintText: "뜻을 입력하세요."),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      String updatedName = _nameController.text.trim();
                      String updatedMeaning = _meaningController.text.trim();

                      if (updatedName.isEmpty || updatedMeaning.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('단어와 뜻을 모두 입력해주세요.')),
                        );
                        return;
                      }

                      _databaseService.updateWord(
                        Word(
                          id: word.id,
                          name: updatedName,
                          meaning: updatedMeaning,
                          chapter: word.chapter,
                          isPreloaded: word.isPreloaded,
                        ),
                      ).then((result) {
                        if (result) {
                          Navigator.of(context).pop();
                          _loadWordList();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('단어가 수정되었습니다.')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('단어 수정에 실패했습니다.')),
                          );
                        }
                      });
                    },
                    child: const Text("수정"),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("에러가 발생했습니다."));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget deleteWordDialog(int id) {
    return AlertDialog(
      title: const Text("이 단어를 삭제하시겠습니까?"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              _databaseService.deleteWord(id).then((result) {
                if (result) {
                  Navigator.of(context).pop();
                  _loadWordList();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('단어가 삭제되었습니다.')),
                  );
                } else {
                  print("delete error");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('단어 삭제에 실패했습니다.')),
                  );
                }
              });
            },
            child: const Text("삭제"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("취소"),
          ),
        ],
      ),
    );
  }
}