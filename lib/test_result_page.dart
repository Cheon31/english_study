// test_result_page.dart

import 'package:flutter/material.dart';
import 'word.dart';

class TestResultPage extends StatelessWidget {
  final Map<Word, bool> results;

  const TestResultPage({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int correctAnswers = results.values.where((v) => v).length;
    int totalQuestions = results.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('테스트 결과'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '정답 수: $correctAnswers / $totalQuestions',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: results.entries.map((entry) {
                  Word word = entry.key;
                  bool isCorrect = entry.value;
                  return ListTile(
                    leading: Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                    title: Text(word.name),
                    subtitle: Text('뜻: ${word.meaning}'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}