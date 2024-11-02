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
  final TextEditingController _chapterController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  late Future<List<Word>> _wordList;

  @override
  void initState() {
    super.initState();
    _loadWordList();
  }

  void _loadWordList() {
    setState(() {
      _wordList = _databaseService.selectWords();
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
          _chapterController.clear();
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
                      word.chapter,
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

  Widget wordBox(int id, String name, String meaning, int chapter) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: Text("$id"),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text(name),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text(meaning),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text('챕터 $chapter'),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              updateButton(id),
              const SizedBox(width: 10),
              deleteButton(id),
            ],
          ),
        ),
      ],
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
          const Text("단어 추가"),
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
            TextField(
              controller: _chapterController,
              decoration: const InputDecoration(hintText: "챕터를 입력하세요."),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                _databaseService
                    .insertWord(
                  Word(
                    name: _nameController.text,
                    meaning: _meaningController.text,
                    chapter: int.parse(_chapterController.text),
                  ),
                )
                    .then((result) {
                  if (result) {
                    Navigator.of(context).pop();
                    _loadWordList();
                  } else {
                    print("insert error");
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

  Widget updateWordDialog(Future<Word> word) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("단어 수정"),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: FutureBuilder<Word>(
        future: word,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _nameController.text = snapshot.data!.name;
            _meaningController.text = snapshot.data!.meaning;
            _chapterController.text = snapshot.data!.chapter.toString();
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
                  TextField(
                    controller: _chapterController,
                    decoration: const InputDecoration(hintText: "챕터를 입력하세요."),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      _databaseService
                          .updateWord(
                        Word(
                          id: snapshot.data!.id,
                          name: _nameController.text,
                          meaning: _meaningController.text,
                          chapter: int.parse(_chapterController.text),
                        ),
                      )
                          .then((result) {
                        if (result) {
                          Navigator.of(context).pop();
                          _loadWordList();
                        } else {
                          print("update error");
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
                } else {
                  print("delete error");
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