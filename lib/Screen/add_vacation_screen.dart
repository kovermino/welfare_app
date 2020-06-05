import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:welfare_app/Util/vacation_manager.dart';
import 'package:welfare_app/VO/VacationRecord.dart';
import 'package:welfare_app/constants.dart';

class AddVacationScreen extends StatefulWidget {
  final Function queryVacationScreen;

  AddVacationScreen(this.queryVacationScreen);

  @override
  _AddVacationScreenState createState() => _AddVacationScreenState();
}

class _AddVacationScreenState extends State<AddVacationScreen> {
  VacationManager manager = VacationManager(DateFormat('yyyy').format(DateTime.now()));
  SharedPreferences _pref;
  final _formKey = GlobalKey<FormState>();
  List<DateTime> selectedDates = [];
  String vacationType = kVacationTypes[0];
  String remark = '';

  var dateEditController = TextEditingController();


  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      if (order != null) {
        if(order.weekday != 6 && order.weekday != 7) {
          selectedDates = [];
          selectedDates.add(order);
          dateEditController.text = DateFormat('yyyy-MM-dd').format(order);
        }
      }
    });
  }

  void sendEmail() async {
    _pref = await SharedPreferences.getInstance();
    String name = _pref.getString(kUserName);
    final Email email = Email(
      body: '안녕하세요, ' + name + '입니다.\n' + dateEditController.text + ' ' + vacationType + ' 사용합니다.\n업무에 참고 부탁드리겠습니다. \n감사합니다',
      subject:  vacationType + ' 사용 - [' + dateEditController.text + ']',
      recipients: ['eunseok.kim@milliman.com;Soyoung.Moon@milliman.com'],
      // cc: ['cc@example.com'],
      // bcc: ['bcc@example.com'],
      // attachmentPaths: ['/path/to/attachment.zip'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
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
                color: kActiveCardColour,
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
                          if (vacationType == kVacationTypes[0] || vacationType == kVacationTypes[2]) {
                            final List<DateTime> picked = await DateRagePicker.showDatePicker(
                                context: context,
                                initialFirstDate: new DateTime.now(),
                                initialLastDate: (new DateTime.now()).add(new Duration(days: 1)),
                                firstDate: new DateTime(2015),
                                lastDate: new DateTime(2021),
                            );
                            if (picked != null) {
                              selectedDates = [];
                              DateTime currentDate = picked[0];
                              while(currentDate.isBefore(picked[picked.length-1])) {
                                if (currentDate.weekday != 6 && currentDate.weekday != 7) {
                                  selectedDates.add(currentDate);
                                }
                                currentDate = currentDate.add(new Duration(days: 1));
                              }

                              if (currentDate.weekday != 6 && currentDate.weekday != 7) {
                                selectedDates.add(currentDate);
                              }
                              currentDate = currentDate.add(new Duration(days: 1));

                              if (picked.length == 1) {
                                dateEditController.text = DateFormat('yyyy-MM-dd').format(picked[0]);
                              } else {
                                dateEditController.text = DateFormat('yyyy-MM-dd').format(picked[0]) + ' ~ ' + DateFormat('yyyy-MM-dd').format(picked[picked.length-1]) + ' (' + selectedDates.length.toString() + '일)';
                              }
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
                          List<VacationRecord> records = [];
                          for(DateTime date in selectedDates) {
                            records.add(VacationRecord(DateFormat('yyyy-MM-dd').format(date), vacationType, remark));
                          }
                          manager.insertVacationRecords(records);
                          widget.queryVacationScreen();
                          sendEmail();
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
