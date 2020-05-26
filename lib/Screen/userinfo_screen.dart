import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:welfare_app/Screen/dashboard_screen.dart';
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

  var userNameEditController = TextEditingController();
  var emailEditController = TextEditingController();
  var joinedDateEditController = TextEditingController();

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
    joinedDateEditController.text = joinedDate;
  }

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      if (order != null) {
        joinedDateEditController.text = DateFormat('yyyy-MM-dd').format(order);
        joinedDate = DateFormat('yyyy-MM-dd').format(order);
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
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
                SizedBox(
                  height: 30.0,
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
                SizedBox(
                  height: 30.0,
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
                SizedBox(
                  height: 50.0,
                ),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _prefs.setString(kUserName, userName);
                      _prefs.setString(kEmail, email);
                      _prefs.setString(kJoinedDate, joinedDate);
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
                    const Text('Save', style: TextStyle(fontSize: 20)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
