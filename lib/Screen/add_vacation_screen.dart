import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:welfare_app/Repository/RepositoryImpl/vacation_repository_sqlite.dart';
import 'package:welfare_app/VO/VacationRecord.dart';
import 'package:welfare_app/constants.dart';

class AddVacationScreen extends StatefulWidget {
  final Function queryVacationScreen;

  AddVacationScreen(this.queryVacationScreen);

  @override
  _AddVacationScreenState createState() => _AddVacationScreenState();
}

class _AddVacationScreenState extends State<AddVacationScreen> {
  final dbHelper = VacationRepositoryImplSqlite.instance;
  final _formKey = GlobalKey<FormState>();
  List<DateTime> selectedDates = [];
  String vacationType = kVacationTypes[0];
  String remark = '';

  var dateEditController = TextEditingController();


  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      if (order != null) {
        dateEditController.text = DateFormat('yyyy-MM-dd').format(order);
      }
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFF0A0E21),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Record vacation',
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            icon: Icon(Icons.add_alarm),
                            labelText: 'Vacation type *'
                        ),
                        hint: Text(
                          'Vacation type',
                        ),
                        items: kVacationTypes.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (text) {
                          setState(() {
                            dateEditController.text = '';
                            vacationType = text;
                          });
                        },
                        value: vacationType,
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: dateEditController,
                        readOnly: true,
                        onTap: () async {
                          if (vacationType == kVacationTypes[0]) {
                            final List<DateTime> picked = await DateRagePicker.showDatePicker(
                                context: context,
                                initialFirstDate: new DateTime.now(),
                                initialLastDate: (new DateTime.now()).add(new Duration(days: 1)),
                                firstDate: new DateTime(2015),
                                lastDate: new DateTime(2021)
                            );
                            if (picked != null) {
                              selectedDates = picked;
                              if (picked.length == 1) {
                                dateEditController.text = DateFormat('yyyy-MM-dd').format(picked[0]);
                              }

                              print(picked);
                            }
                          }else {
                            callDatePicker();
                          }
                        },
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                            icon: Icon(Icons.date_range),
                            labelText: 'Date *'
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Joined date is empty';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            icon: Icon(Icons.speaker_notes),
                            labelText: 'Remark'
                        ),
                        onChanged: (text) {
                          remark = text;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        onPressed: () {
                          dbHelper.insert(VacationRecord(dateEditController.text, vacationType, remark).toMap());
                          widget.queryVacationScreen();
                          Navigator.pop(context);
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child:
                          const Text('Save', style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
