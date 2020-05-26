import 'package:flutter/material.dart';
import 'package:welfare_app/VO/ExpenseRecord.dart';
import 'package:welfare_app/constants.dart';

class ExpenseRecordsScreen extends StatefulWidget {
  @override
  _ExpenseRecordsScreenState createState() => _ExpenseRecordsScreenState();
}

class _ExpenseRecordsScreenState extends State<ExpenseRecordsScreen> {
  final List<ExpenseRecord> records = [new ExpenseRecord('2020-04-24', 200000, 'english'), new ExpenseRecord('2020-04-24', 200000, 'english'), new ExpenseRecord('2020-04-24', 200000, 'english')];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Records'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              color: kActiveCardColour,
              child: ListTile(
                leading: Icon(
                    Icons.attach_money,
                  color: Colors.yellow,
                ),
                title: Text(
                  'Total used: 450,000',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                subtitle: Text(
                  '4 records exists',
                  style: TextStyle(
                      fontSize: 15.0
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildExpenseList(),
            )
          ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }

  Widget _buildExpenseList() {
   return ListView.builder(
     itemCount: records.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index){
          return Container(
            child: ListTile(
              title: Text(
                records[index].date,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              subtitle: Text(
                records[index].remark,
                style: TextStyle(
                    fontSize: 15.0
                ),
              ),
            ),
          );
        });
  }
}
