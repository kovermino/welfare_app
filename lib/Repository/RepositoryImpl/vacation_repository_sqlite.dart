import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class VacationRepositoryImplSqlite {

  static final _databaseName = "Welfare.db";
  static final _databaseVersion = 1;

  static final table = 'VacationRecords';

  static final columnDate = 'date';
  static final columnVacationType = 'vacation_type';
  static final columnDeduction = 'deduction';
  static final columnRemark = 'remark';

  // make this a singleton class
  VacationRepositoryImplSqlite._privateConstructor();
  static final VacationRepositoryImplSqlite instance = VacationRepositoryImplSqlite._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $table ( $columnDate TEXT PRIMARY KEY, $columnVacationType TEXT NOT NULL, $columnDeduction NUM NOT NULL, $columnRemark TEXT)");
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRowsForYear(String year) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE date like \'$year%\' ORDER BY date DESC');
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<double> querySumDeduction(String year) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> sumDeduction = await db.rawQuery('SELECT SUM(deduction) as total_deduction FROM $table WHERE date like \'$year%\'');
    if (sumDeduction.length == 0) {
      return 0;
    }else {
      Map<String, dynamic> result = sumDeduction[0];
      return result['total_deduction'].toDouble();
    }
  }

  Future<int> queryRowCountByYear(String year) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE date like \'$year%\''));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String date = row[columnDate];
    return await db.update(table, row, where: '$columnDate = ?', whereArgs: [date]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String date) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnDate = ?', whereArgs: [date]);
  }

}