import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL,
        type TEXT NOT NULL,
        note TEXT
      )
    ''');
    
    // Seed initial data matching requirements
    await db.insert('transactions', {
      'title': 'Ăn trưa',
      'amount': 50000.0,
      'date': '03/09/2024',
      'category': 'Ăn uống',
      'type': 'expense',
      'note': 'Ăn trưa'
    });
    await db.insert('transactions', {
      'title': 'Xăng xe',
      'amount': 100000.0,
      'date': '03/09/2024',
      'category': 'Di chuyển',
      'type': 'expense',
      'note': 'Đổ xăng'
    });
    await db.insert('transactions', {
      'title': 'Lương tháng 9',
      'amount': 8000000.0,
      'date': '01/09/2024',
      'category': 'Thu nhập',
      'type': 'income',
      'note': 'Lương tháng'
    });
    await db.insert('transactions', {
      'title': 'Mua sắm',
      'amount': 300000.0,
      'date': '31/08/2024',
      'category': 'Mua sắm',
      'type': 'expense',
      'note': 'Quần áo'
    });
    await db.insert('transactions', {
      'title': 'Học phí',
      'amount': 500000.0,
      'date': '30/08/2024',
      'category': 'Giáo dục',
      'type': 'expense',
      'note': 'Học phí khóa học'
    });
  }

  // Create
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await instance.database;
    return await db.insert('transactions', transaction.toMap());
  }

  // Read All
  Future<List<TransactionModel>> getTransactions() async {
    final db = await instance.database;
    const orderBy = 'id DESC';
    final result = await db.query('transactions', orderBy: orderBy);
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  // Update
  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await instance.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // Delete
  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Summary calculations
  Future<Map<String, double>> getSummary() async {
    final transactions = await getTransactions();
    double totalIncome = 0.0;
    double totalExpense = 0.0;

    for (var tx in transactions) {
      if (tx.type == 'income') {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;
      }
    }

    double totalBalance = totalIncome - totalExpense;
    return {
      'balance': totalBalance,
      'income': totalIncome,
      'expense': totalExpense,
    };
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
