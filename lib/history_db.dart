import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final path = join(await getDatabasesPath(), 'calculator.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE history (id INTEGER PRIMARY KEY, formula TEXT, result TEXT)',
      );
    },
  );
}

Future<void> saveHistory(String formula, String result) async {
  final db = await getDatabase();
  await db.insert('history', {'formula': formula, 'result': result});
}

Future<List<Map<String, dynamic>>> getHistory() async {
  final db = await getDatabase();
  return db.query('history', orderBy: 'id DESC');
}
