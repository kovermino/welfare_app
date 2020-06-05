import 'package:welfare_app/Util/vacation_manager.dart';
import 'package:welfare_app/constants.dart';
import 'package:intl/intl.dart';
import 'userinfo_screen.dart';
import 'vacation_screen.dart';
import 'expense_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  VacationManager manager = new VacationManager(DateFormat('yyyy').format(DateTime.now()));
  String title = 'Milliman Welfare Home (' + DateFormat('yyyy').format(DateTime.now()) + ')';
  String availableText = "사용가능 휴가 없음";

  @override
  void initState() {
    super.initState();
    _dataLoad();
  }

  void _dataLoad() async {
    int totalAvailable = await manager.getTotalAvailable();
    double available = await manager.getAvailable();
    setState(() {
      availableText = '사용가능 : ' + available.toString() + ' / ' + totalAvailable.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              color: kActiveCardColour,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.airplanemode_active,
                      color: kVacationColour,
                    ),
                    title: Text(
                      'My Vacations',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    subtitle: Text(
                      availableText,
                      style: TextStyle(
                          fontSize: 15.0
                      ),
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        color: Colors.green[800],
                        child: const Text('Detail'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VacationRecordsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              color: kActiveCardColour,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(
                      Icons.attach_money,
                      color: kExpenseColour,
                    ),
                    title: Text(
                      'My Expense',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    subtitle: Text(
                      'Use 450,000 (available in May)',
                      style: TextStyle(
                          fontSize: 15.0
                      ),
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        color: Colors.green[800],
                        child: const Text('Detail'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ExpenseRecordsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserInfoScreen()),
          );
        },
        child: Icon(Icons.settings),
        backgroundColor: Colors.white,
      ),
    );
  }
}
