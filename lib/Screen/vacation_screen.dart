import 'package:flutter/material.dart';
import 'package:welfare_app/Screen/mail_address_screen.dart';
import 'package:welfare_app/Util/vacation_manager.dart';
import 'package:welfare_app/VO/VacationRecord.dart';
import 'package:welfare_app/constants.dart';
import 'add_vacation_screen.dart';
import 'package:intl/intl.dart';

class VacationRecordsScreen extends StatefulWidget {
  @override
  _VacationRecordsScreenState createState() => _VacationRecordsScreenState();
}

class _VacationRecordsScreenState extends State<VacationRecordsScreen> {
  VacationManager manager = new VacationManager(DateFormat('yyyy').format(DateTime.now()));

  List<VacationRecord> records = [];
  String availableText = '사용가능 : 0';
  String recordsText = 'No record.';

  var recordTextEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataLoad();
  }

  void _dataLoad() async {
    List<VacationRecord> rows = await manager.getAllRecords();
    int totalAvailable = await manager.getTotalAvailable();
    double available = await manager.getAvailable();
    setState(() {
      records = rows;
      recordsText = rows==null ?  'No records.' : (rows.length == 0 ? 'No records.' : (rows.length==1 ? '1 record exists.' : rows.length.toString() + ' records exist.'));
      availableText = '사용가능 : ' + available.toString() + ' / ' + totalAvailable.toString();
    });
  }

  void deleteItem(String date){
    manager.deleteVacationRecord(date);
    _dataLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Vacation Records'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.email),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MailAddressScreen()),
              );
            },
          )
        ],
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
            builder: (context) => AddVacationScreen(_dataLoad),
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
              deleteItem(record.date);
            },
            child: Container(
              child: ListTile(
                leading: records[index].vacationType == kVacationTypes[0] ? Icon(Icons.star, color: Colors.yellow,) :
                (records[index].vacationType==kVacationTypes[1] ? Icon(Icons.star_half, color: Colors.purple,) :
                Icon(Icons.music_note, color: Colors.green,)),
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
                trailing:  Text('(' + records[index].vacationType + ')'),
              ),
            ),
          );
        });
  }


}
