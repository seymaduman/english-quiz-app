import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sentence {
  final int id;
  final String cumle;
  final String anlami;

  Sentence({
    required this.id,
    required this.cumle,
    required this.anlami,
  });

  @override
  String toString() {
    return 'Sentence(id: $id, cumle: $cumle, anlami: $anlami)';
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'cumle': cumle,
      'anlami': anlami,
    };
  }

  static Sentence fromMap(Map<String, dynamic> map) {
    return Sentence(
      id: map['id'] as int,
      cumle: map['cumle'] as String,
      anlami: map['anlami'] as String,
    );
  }
}

class WordPage3 extends StatefulWidget {
  @override
  _WordPage3State createState() => _WordPage3State();
}

class _WordPage3State extends State<WordPage3> {
  Database? _database;
  String _sentence = '';

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  // Initialize the database
  Future<void> _initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'sentence.db');

    print("Veritabanı Yolu: $path");

    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute('''
          INSERT INTO sentence (id, sentence, meaning) VALUES (1, \'A blessing in disguise.\', \'Görünüşte bela olan bir nimet. (Başlangıçta kötü görünen ama sonunda iyi olan bir durum.)\');
        ''');
      },
      version: 1,
    );

    // Insert sentences if not already present
    final List<Map<String, dynamic>> result = await _database!.query('sentence');
    if (result.length < 3) {
      await insertSentences(_database!);
    }

    _loadRandomSentence();
  }

  // Insert sample sentences into the database
  Future<void> insertSentences(Database db) async {
    await db.transaction((txn) async {
      await txn.rawInsert(
        '(1, \'A blessing in disguise.\', \'Görünüşte bela olan bir nimet. (Başlangıçta kötü görünen ama sonunda iyi olan bir durum.)\'),'
            '(2, \'A dime a dozen.\', \'Çok ucuz. (Çok yaygın ve değersiz olan şeyler için kullanılır.)\'),'
            '(3, \'A piece of cake.\', \'Çocuk oyuncağı. (Çok kolay bir iş.)\')',
      );
    });
  }

  // Load a random sentence from the database
  Future<void> _loadRandomSentence() async {
    final List<Map<String, dynamic>> sentences = await _database!.rawQuery('SELECT * FROM sentence ORDER BY RANDOM() LIMIT 1');

    if (sentences.isNotEmpty) {
      setState(() {
        _sentence = sentences[0]['sentence'] + ' = ' + sentences[0]['meaning'] as String;
      });
    } else {
      setState(() {
        _sentence = "No sentence found.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        title: Text('KALIP CÜMLELER'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _sentence.isNotEmpty ? _sentence : ' ',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadRandomSentence,
              child: Text('Yeni Cümle'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                minimumSize: Size(200, 50), // Button size
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Geri dön
              },
              child: Text('Geri Dön'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red, // Text color
                minimumSize: Size(200, 50), // Button size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
