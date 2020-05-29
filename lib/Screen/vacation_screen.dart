import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:welfare_app/Repository/RepositoryImpl/vacation_repository_sqlite.dart';
import 'package:welfare_app/Util/vacation_calaulator.dart';
import 'package:welfare_app/VO/VacationRecord.dart';
import 'package:welfare_app/constants.dart';
import 'add_vacation_screen.dart';
import 'package:intl/intl.dart';

class VacationRecordsScreen extends StatefulWidget {
  @override
  _VacationRecordsScreenState createState() => _VacationRecordsScreenState();
}

class _VacationRecordsScreenState extends State<VacationRecordsScreen> {
  final dbHelper = VacationRepositoryImplSqlite.instance;
  SharedPreferences _prefs;
  var recordTextEditController = TextEditingController();
  List<VacationRecord> records = [];
  String availableText = '사용가능 : 0';
  String recordsText = 'No record.';
  String currentYear = DateFormat('yyyy').format(DateTime.now());
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _dataLoad();
  }

  void _dataLoad() {
    _query();
    _loadPref();
  }

  void _loadPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Vacation Records'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            color: kActiveCardColour,
            child: ListTile(
              leading: Icon(
                Icons.airplanemode_active,
                color: kVacationColour,
              ),
              title: Text(
                availableText,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              subtitle: Text(
                recordsText,
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
          Expanded(
            child: _buildVacationList(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => AddVacationScreen(_query),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: kVacationColour,
      ),
    );
  }

  Widget _buildVacationList() {
    return ListView.builder(
        itemCount: records.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: ObjectKey(records[index]),
            onDismissed: (direction) {
              var record = records[index];
              dbHelper.delete(record.date);
              deleteItemFromListView(index);
            },
            child: Container(
              child: ListTile(
                leading: Text('(' + records[index].vacationType + ')'),
                title: Text(
                  records[index].date,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                subtitle: Text(
                  records[index].remark,
                  style: TextStyle(fontSize: 15.0),
                ),
                trailing: records[index].vacationType == kVacationTypes[0] ? Icon(Icons.star) : (records[index].vacationType==kVacationTypes[1] ? Icon(Icons.star_half) : Icon(Icons.add)),
              ),
            ),
          );
        });
  }

  void _query() async {
    final allRows = await dbHelper.queryRowsForYear('2020');
    List<VacationRecord> rows = [];
    allRows.forEach((row) => rows.add(VacationRecord.fromMap(row)));
    String joinedDate = _prefs.getString(kJoinedDate);
    int totalAvailable = _prefs.getInt(currentYear);
    double available = 0;
    double count = 0;
    for(VacationRecord record in rows) {
      count += record.deduction;
    }

    if (totalAvailable == null || totalAvailable == 0) {
      available = VacationCalculator.calculateCurrentAvailableFromJoinedDate(joinedDate, currentDate) - count;
    } else {
      available = totalAvailable - count;
    }

    setState(() {
      records = rows;
      recordsText = rows==null ?  'No records.' : (rows.length == 0 ? 'No records.' : (rows.length==1 ? '1 record exists.' : rows.length.toString() + ' records exist.'));
      availableText = '사용가능 : ' + available.toString();
    });
  }

  void deleteItemFromListView(index){
    _query();
    setState((){
      records.removeAt(index);
    });
  }
}
