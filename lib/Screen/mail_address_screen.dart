import 'package:flutter/material.dart';
import 'package:welfare_app/constants.dart';

class MailAddressScreen extends StatefulWidget {
  @override
  _MailAddressScreenState createState() => _MailAddressScreenState();
}

class _MailAddressScreenState extends State<MailAddressScreen> {
  final List<String> records = ['eunseok.kim@milliman.com', 'Soyoung.Moon@milliman.com'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emails for Vacation Notification'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Card(
              color: kActiveCardColour,
              child: TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Recipients *',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                      },
                    )
                ),
              )
            ),
            SizedBox(
              height: 20.0,
            ),
            Card(
                color: kActiveCardColour,
                child: TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.perm_identity),
                      labelText: 'CC *',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                        },
                      )
                  ),
                )
            ),
            Expanded(child: _buildExpenseList()),


          ],
        ),
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
                records[index],
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),

            ),
          );
        });
  }
}
