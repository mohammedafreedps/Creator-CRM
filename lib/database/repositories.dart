import 'package:creator_tracker/database/base_repository.dart';

import 'db_tables.dart';

class Repositories {

  static final outreach = BaseRepository(DbTables.outreach);
  static final deals = BaseRepository(DbTables.deals);
  static final content = BaseRepository(DbTables.content);
  static final notes = BaseRepository(DbTables.notes);
  static final payments = BaseRepository(DbTables.payments);
  static final products = BaseRepository(DbTables.productTracking);
  static final reminders = BaseRepository(DbTables.reminders);

}