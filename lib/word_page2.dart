import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class WordPage2 extends StatefulWidget {
  const WordPage2({Key? key}) : super(key: key);

  @override
  _WordPage2State createState() => _WordPage2State();
}

class _WordPage2State extends State<WordPage2> {
  late Database database;
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _initDatabase(); // Veritabanı başlatma fonksiyonunu çağır
  }

  Future<void> _initDatabase() async {
    try {
      database = await openDatabase(
        p.join(await getDatabasesPath(), 'veri.db'), // Veritabanı dosya yolunu oluştur
        version: 1,
        onCreate: (db, version) {
          // Tablonun oluşturulması
          return db.execute(
            "CREATE TABLE veri(id INTEGER PRIMARY KEY, sorular TEXT, dogruCevap TEXT, secenekler TEXT)",
          );
        },
      );
      await _loadQuestions(); // Soruları yüklemek için çağır
    } catch (e) {
      print('Database initialization error: $e'); // Hata mesajını yazdır
    }
  }

  Future<void> _loadQuestions() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query('veri');
      setState(() {
        questions = maps;
      });
    } catch (e) {
      print('Error loading questions: $e'); // Hata mesajını yazdır
    }
  }

  void _answerQuestion(String selectedAnswer) {
    if (selectedAnswer == questions[currentQuestionIndex]['dogruCevap']) {
      score++;
    }

    setState(() {
      currentQuestionIndex++;
    });

    if (currentQuestionIndex >= questions.length) {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed'),
        content: Text('Your score is $score out of ${questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('KELİME TESTİNE HAZIR MISIN?'),
        ),
        /*
        body: const Center(
          child: CircularProgressIndicator(),
        ),

         */
      );
    }

    Map<String, String> options = Map.fromIterable(
      questions[currentQuestionIndex]['secenekler'].split(','),
      key: (e) => e.split(':')[0],
      value: (e) => e.split(':')[1],
    );

    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        title: const Text('KELİME TESTİNE HAZIR MISIN?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              questions[currentQuestionIndex]['sorular'],
              style: const TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 20.0),
            ...options.entries.map((option) {
              return ElevatedButton(
                onPressed: () => _answerQuestion(option.key),
                child: Text(option.value),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
