import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "creator_crm.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  static Future<void> _createTables(Database db, int version) async {

    await db.execute('''
    CREATE TABLE creators(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      platform TEXT,
      niche TEXT,
      followers INTEGER,
      engagement_rate TEXT,
      phone TEXT,
      email TEXT,
      address TEXT,
      location TEXT,
      rating REAL,
      is_favorite INTEGER,
      is_blacklisted INTEGER,
      created_at TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE outreach(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      creator_id INTEGER,
      status TEXT,
      first_message_date TEXT,
      last_followup_date TEXT,
      next_followup_date TEXT,
      communication_channel TEXT,
      followup_count INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE deals(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      creator_id INTEGER,
      collaboration_type TEXT,
      asked_price REAL,
      final_price REAL,
      deliverables TEXT,
      status TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE product_tracking(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      creator_id INTEGER,
      product_name TEXT,
      status TEXT,
      courier TEXT,
      tracking_number TEXT,
      dispatch_date TEXT,
      delivery_date TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE content(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      creator_id INTEGER,
      content_received INTEGER,
      content_approved INTEGER,
      posting_date TEXT,
      content_link TEXT,
      ad_permission INTEGER,
    )
    ''');

    await db.execute('''
    CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      creator_id INTEGER,
      note TEXT,
      created_at TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE payments(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      creator_id INTEGER,
      amount REAL,
      status TEXT,
      payment_date TEXT,
      payment_method TEXT,
      invoice_number TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE reminders(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      creator_id INTEGER,
      title TEXT,
      description TEXT,
      reminder_date TEXT,
      completed INTEGER
    )
    ''');

  }

}