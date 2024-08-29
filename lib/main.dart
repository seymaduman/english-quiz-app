import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'word_page.dart'; // İlk sayfa
import 'word_page2.dart'; // İkinci sayfa
import 'word_page3.dart'; // Üçüncü sayfa

Database? database; // Global olarak tanımla

Future<void> copyDatabase() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'words.db');

  // Veritabanı dosyasının var olup olmadığını kontrol et
  final file = File(path);
  // Veritabanı dosyasını assets'dan kopyala
  final byteData = await rootBundle.load('assets/database/words.db');
  final bytes = byteData.buffer.asUint8List();
  await file.writeAsBytes(bytes);
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await copyDatabase(); // Veritabanı dosyasını kopyala
  database = await openDatabase(
    join(await getDatabasesPath(), 'words.db'),
    version: 1,
  );
  runApp(MyApp());
}


// Word sınıfı
class Word {
  final int id;
  final int categoryId;
  final String ENG;
  final String TR;
  final String level;

  const Word({
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

  @override
  String toString() {
    return 'Word{id: $id, categoryId: $categoryId, ENG: $ENG, TR: $TR, level: $level}';
  }
}
class Question {
  final int id;
  final String sorular;
  final String dogruCevap;
  final Map<String, String> secenekler;

  Question({
    required this.id,
    required this.sorular,
    required this.dogruCevap,
    required this.secenekler,
  });

  @override
  String toString() {
    return 'Question(id: $id, sorular: $sorular, dogruCevap: $dogruCevap, secenekler: $secenekler)';
  }
}
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
    return 'Question(id: $id, cümle: $cumle, anlamı: $anlami)';
  }

  // Map'ten Question nesnesi oluşturmak için fromMap fonksiyonu
  static Sentence fromMap(Map<String, dynamic> map) {
    return Sentence(
      id: map['id'] as int,
      cumle: map['cumle'] as String,
      anlami: map['anlami'] as String,
    );
  }
}

// Kelime ekleme fonksiyonu
Future<void> wordInsert(Word word) async {
  final db = await database;
  if (db != null) {
    await db.insert(
      'words',
      word.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ENGLISH LEARNING APP', // Uygulama başlığı
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tema rengi
      ),
      home: MyHomePage(), // Ana sayfa
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen, // Arka plan rengi
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              padding: EdgeInsets.all(30.0),
              width: 400.0,
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/images/dosya.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'ENGLISH LEARNING APP',
              style: TextStyle(
                fontFamily: 'Platypi',
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 350,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WordPage()),
                  );
                },
                child: Text('SEVİYELERE GÖRE KELİMELER'),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 350,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WordPage2()),
                  );
                },
                child: Text('KELİME TESTİNE HAZIR MISIN?'),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 350,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WordPage3()),
                  );
                },
                child: Text('KALIP CÜMLELER'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


