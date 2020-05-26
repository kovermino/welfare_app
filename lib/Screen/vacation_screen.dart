import 'package:flutter/material.dart';

class VacationRecordsScreen extends StatefulWidget {
  @override
  _VacationRecordsScreenState createState() => _VacationRecordsScreenState();
}

class _VacationRecordsScreenState extends State<VacationRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacation Records'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.add,),
        backgroundColor: Colors.cyanAccent,
      ),
    );
  }
}
