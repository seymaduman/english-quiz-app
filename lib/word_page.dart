import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Word {
  final int id;
  final int categoryId;
  final String ENG;
  final String TR;
  final String level;

  Word({
    required this.id,
    required this.categoryId,
    required this.ENG,
    required this.TR,
    required this.level,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'ENG': ENG,
      'TR': TR,
      'level': level,
    };
  }
}

Future<Database> openDatabaseConnection() async {
  return openDatabase(
    join(await getDatabasesPath(), 'words.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE words(id INTEGER PRIMARY KEY, categoryId INTEGER, ENG TEXT, TR TEXT, level TEXT)',
      );
    },
    version: 1,
  );
}

Future<void> insertWords(Database db) async {
  await db.transaction((txn) async {
    await txn.rawInsert(
      'INSERT INTO words (id, categoryId, ENG, TR, level) VALUES (1, 1, \'apple\', \'elma\', \'A1\'),'
          '(2, 1, \'banana\', \'muz\', \'A1\'),'
          '(3, 1, \'cherry\', \'kiraz\', \'A2\'),'
          '(4, 2, \'dog\', \'köpek\', \'A1\'),'
          '(5, 2, \'cat\', \'kedi\', \'A1\'),'
          '(6, 2, \'elephant\', \'fil\', \'A2\'),'
          '(7, 3, \'table\', \'masa\', \'A1\'),'
          '(8, 3, \'chair\', \'sandalyе\', \'A1\'),'
          '(9, 3, \'lamp\', \'lamba\', \'A2\'),'
          '(10, 4, \'book\', \'kitap\', \'A1\'),'
          '(11, 4, \'pen\', \'kalem\', \'A1\'),'
          '(12, 4, \'notebook\', \'defter\', \'A2\'),'
          '(13, 5, \'car\', \'araba\', \'A1\'),'
          '(14, 5, \'bus\', \'otobüs\', \'A1\'),'
          '(15, 5, \'bicycle\', \'bisiklet\', \'A2\'),'
          '(16, 6, \'shirt\', \'gömlek\', \'A1\'),'
          '(17, 6, \'pants\', \'pantolon\', \'A1\'),'
          '(18, 6, \'jacket\', \'ceket\', \'A2\'),'
          '(19, 7, \'phone\', \'telefon\', \'A1\'),'
          '(20, 7, \'computer\', \'bilgisayar\', \'A1\');',
    );
  });
}



Future<Word?> getRandomWord(Database db, String level) async {
  final List<Map<String, dynamic>> result = await db.query(
    'words',
    where: 'level = ?',
    whereArgs: [level],
    orderBy: 'RANDOM()',
    limit: 1,
  );

  if (result.isNotEmpty) {
    return Word(
      id: result[0]['id'] as int,
      categoryId: result[0]['categoryId'] as int,
      ENG: result[0]['ENG'] as String,
      TR: result[0]['TR'] as String,
      level: result[0]['level'] as String,
    );
  }
  return null;
}

class WordPage extends StatefulWidget {
  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  String? currentWordENG;
  String? currentWordTR;

  Future<void> _updateWord(String level) async {
    final db = await openDatabaseConnection();

    // Insert words if not already present
    final List<Map<String, dynamic>> result = await db.query('words');
    if (result.isEmpty) {
      await insertWords(db);
    }

    final word = await getRandomWord(db, level);
    setState(() {
      currentWordENG = word?.ENG;
      currentWordTR = word?.TR;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        title: Text('SEVİYELERE GÖRE KELİMELER'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${currentWordENG ?? 'N/A'} = ${currentWordTR ?? 'N/A'}',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
          SizedBox(
            width: 350,
            height: 70, // Set the width for the button
            child: ElevatedButton(
              onPressed: () => _updateWord('A2'),
              child: Text('A1 SEVİYE'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 350,
            height: 70,          child: ElevatedButton(
              onPressed: () => _updateWord('A2'),
              child: Text('A2 SEVİYE'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
            ),
          ),
              SizedBox(height: 20),
              SizedBox(
                width: 350,
                height: 70,             child: ElevatedButton(
                  onPressed: () => _updateWord('A2'),
                  child: Text('B1 SEVİYE'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 350,
                height: 70,
                child: ElevatedButton(
                  onPressed: () => _updateWord('A2'),
                  child: Text('B2 SEVİYE'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 350,
                height: 70,             child: ElevatedButton(
                  onPressed: () => _updateWord('A2'),
                  child: Text('C1 SEVİYE'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 350,
                height: 70,               child: ElevatedButton(
                  onPressed: () => _updateWord('A2'),
                  child: Text('C2 SEVİYE'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
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
