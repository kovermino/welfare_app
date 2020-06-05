import 'package:shared_preferences/shared_preferences.dart';
import 'package:welfare_app/Repository/RepositoryImpl/vacation_repository_sqlite.dart';
import 'package:welfare_app/Util/vacation_calaulator.dart';
import 'package:welfare_app/VO/VacationRecord.dart';
import 'package:welfare_app/constants.dart';
import 'package:intl/intl.dart';

class VacationManager {

  final dbHelper = VacationRepositoryImplSqlite.instance;
  SharedPreferences _prefs;
  String year;

  VacationManager(this.year);

  Future<List<VacationRecord>> getAllRecords() async {
    _prefs = await SharedPreferences.getInstance();
    final allRows = await dbHelper.queryRowsForYear(year);
    List<VacationRecord> rows = [];
    allRows.forEach((row) => rows.add(VacationRecord.fromMap(row)));
    return rows;
  }

  void deleteVacationRecord(String date) {
    dbHelper.delete(date);
  }

  Future<double> getAvailable() async {
    _prefs = await SharedPreferences.getInstance();
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String joinedDate = _prefs.getString(kJoinedDate);
    int totalAvailable = _prefs.getInt(year);
    double available = 0;
    double deduction = await dbHelper.querySumDeduction(year);

    if (totalAvailable == null || totalAvailable == -1) {
      available = VacationCalculator.calculateCurrentAvailableFromJoinedDate(joinedDate, currentDate) - deduction;
    } else {
      available = totalAvailable - deduction;
    }

    return available;
  }

  Future<int> getTotalAvailable() async {
    _prefs = await SharedPreferences.getInstance();
    int totalAvailable = _prefs.getInt(year);
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String joinedDate = _prefs.getString(kJoinedDate);
    if (totalAvailable == null || totalAvailable == -1) {
      return VacationCalculator.calculateCurrentAvailableFromJoinedDate(joinedDate, currentDate);
    } else {
      return totalAvailable;
    }
  }

  void insertVacationRecords(List<VacationRecord> records) {
    for(VacationRecord record in records) {
      dbHelper.insert(record.toMap());
    }
  }



}