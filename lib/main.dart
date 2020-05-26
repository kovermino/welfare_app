import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:welfare_app/Screen/dashboard_screen.dart';
import 'package:welfare_app/Screen/userinfo_screen.dart';
import 'package:welfare_app/constants.dart';

void main() => runApp(WelfareHome());

class WelfareHome extends StatefulWidget {
  @override
  _WelfareHomeState createState() => _WelfareHomeState();
}

class _WelfareHomeState extends State<WelfareHome> {
  SharedPreferences _prefs;
  String userName;
  String email;
  String joinedDate;

  _loadUserInfo() async {
    _prefs = await SharedPreferences.getInstance();
    userName = _prefs.getString(kUserName);
    email = _prefs.getString(kEmail);
    joinedDate = _prefs.getString(kJoinedDate);
  }

  @override
  Widget build(BuildContext context) {
    _loadUserInfo();
    print(userName);
    Widget homeScreen;
    if (userName == null) {
      homeScreen = UserInfoScreen();
    } else {
      homeScreen = DashboardScreen();
    }
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
        accentColor: Colors.blueAccent,
      ),
      home: homeScreen,
    );
  }
}
