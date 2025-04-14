import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DBService {
  static Database? _db;

  static Future<void> initDB() async {
    if (_db != null) return;
    final path = join(await getDatabasesPath(), 'expense.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE transactions(
          id TEXT PRIMARY KEY,
          title TEXT,
          amount REAL,
          date TEXT,
          category TEXT,
          isIncome INTEGER
        )
      ''');
    });
  }

  static Future<void> insertTransaction(TransactionModel tx) async {
    await _db!.insert('transactions', tx.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<TransactionModel>> getTransactions() async {
    final List<Map<String, dynamic>> maps = await _db!.query('transactions');
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  static Future<void> deleteTransaction(String id) async {
    await _db!.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}