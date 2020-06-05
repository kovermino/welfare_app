import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:welfare_app/Screen/dashboard_screen.dart';
import 'package:welfare_app/Util/vacation_calaulator.dart';
import 'package:welfare_app/constants.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  SharedPreferences _prefs;
  String userName = '';
  String email = '';
  String joinedDate = '';
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String currentYear = DateFormat('yyyy').format(DateTime.now());
  int available = 0;
  bool autoCalc = true;

  var userNameEditController = TextEditingController();
  var emailEditController = TextEditingController();
  var joinedDateEditController = TextEditingController();
  var availableVacationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    _prefs = await SharedPreferences.getInstance();
    userName = _prefs.getString(kUserName);
    email = _prefs.getString(kEmail);
    joinedDate = _prefs.getString(kJoinedDate);
    userNameEditController.text = userName;
    emailEditController.text = email;
    joinedDateEditController.text = joinedDate == null ? "" : joinedDate ;

    setState(() {
      autoCalc = _prefs.getBool(kAutoCalc);
    });

    available = _prefs.getInt(currentYear);
    if (available == null || available == -1) {
      availableVacationController.text = VacationCalculator.calculateCurrentAvailableFromJoinedDate(joinedDate, currentDate).toString();
    } else {
      availableVacationController.text = available.toString();
    }

  }

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      if (order != null) {
        joinedDateEditController.text = DateFormat('yyyy-MM-dd').format(order);
        joinedDate = DateFormat('yyyy-MM-dd').format(order);
        autoCalc = true;
        availableVacationController.text = VacationCalculator.calculateCurrentAvailableFromJoinedDate(joinedDate, currentDate).toString();
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

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not in stock'),
          content: const Text('This item is no longer available'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'User info',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    TextFormField(
                      controller: userNameEditController,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Name *'
                      ),
                      onChanged: (text) {
                        userName = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Name is empty';
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      controller: emailEditController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.mail),
                          labelText: 'Email *'
                      ),
                      onChanged: (text) {
                        email = text;
                      },
                      validator: (text) {
                        return text.contains('@') ? null : 'Email must contains @ character';
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: joinedDateEditController,
                      onTap: () {
                        callDatePicker();
                      },
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                          icon: Icon(Icons.date_range),
                          labelText: 'Joined Date *'
                      ),
                      onChanged: (text) {
                        joinedDate = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Joined date is empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: availableVacationController,
                      readOnly: autoCalc == null ? true : autoCalc,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          icon: Icon(Icons.event_available),
                          labelText: 'Available Vacation *'
                      ),
                      onChanged: (text) {
                        available = int.parse(text);
                      },
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      color: Colors.indigo,
                      child: ListTile(
                        leading: Icon(Icons.autorenew),
                        title: Text('auto calculate vacations'),
                        trailing: Checkbox(
                          activeColor: Colors.yellow,
                          checkColor: Colors.black,
                          value: autoCalc == null ? true : autoCalc,
                          onChanged: (value) {
                            setState(() {
                              autoCalc = value;
                              if(autoCalc) {
                                available = VacationCalculator.calculateCurrentAvailableFromJoinedDate(joinedDate, currentDate);
                                availableVacationController.text = available.toString();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _prefs.setBool(kAutoCalc, autoCalc);
                          _prefs.setString(kUserName, userName);
                          _prefs.setString(kEmail, email);
                          _prefs.setString(kJoinedDate, joinedDate);
                          _prefs.setInt(currentYear, available);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => DashboardScreen()),
                          );
                        }
                      },
                      color: Colors.green[900],
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child:
                        const Text('Ok', style: TextStyle(fontSize: 20)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

