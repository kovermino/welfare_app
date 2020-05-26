import 'package:welfare_app/constants.dart';

import 'userinfo_screen.dart';
import 'vacation_screen.dart';
import 'expense_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milliman Welfare Home'),
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
                  const ListTile(
                    leading: Icon(
                      Icons.airplanemode_active,
                      color: Colors.cyanAccent,
                    ),
                    title: Text(
                      'My Vacations',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    subtitle: Text(
                      '12 left (3 use of total 15)',
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
                      color: Colors.yellow,
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
        backgroundColor: Colors.blue,
      ),
    );
  }
}
