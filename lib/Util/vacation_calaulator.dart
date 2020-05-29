import 'package:intl/intl.dart';

class VacationCalculator {

  static final int baseAvailable = 15;
  static final int theSecondHalfBaseAvailable = 12;

  static int calculateCurrentAvailableFromJoinedDate(String joinedDate, String currentDate) {
    var dateComponents = joinedDate.split("-");
    int year = int.parse(dateComponents[0]);
    int month = int.parse(dateComponents[1]);
    int day = int.parse(dateComponents[2]);
    bool theFirstHalf = month < 7;

    var currentDateComponents = currentDate.split('-'); // DateFormat('yyyy-MM-dd').format(DateTime.now()).split('-');
    int currentYear = int.parse(currentDateComponents[0]);
    int currentMonth = int.parse(currentDateComponents[1]);

    if (currentYear - year <= 0) {
      if (joinedAtFirstDayOfMonth(month, day)) {
        return currentMonth - month;
      }else {
        int available = currentMonth - month - 1 > 0 ? currentMonth - month - 1 : 0;
        return available;
      }
    } else {
      if (theFirstHalf) {
        if (currentYear - year == 1) {
          return baseAvailable;
        } else {
          double calc = (currentYear - year - 1) / 2;
          int added = calc.toInt() > 0 ? calc.toInt() : 0;
          return baseAvailable + added.toInt();
        }
      } else {
        if (currentYear - year == 1) {
          return theSecondHalfBaseAvailable;
        } else if (currentYear - year == 2) {
          return baseAvailable;
        }else {
          double calc = (currentYear - year - 2) / 2;
          int added = calc.toInt() > 0 ? calc.toInt() : 0;
          return baseAvailable + added;
        }
      }
    }
  }

  static bool joinedAtFirstDayOfMonth(int month, int day){
    if(month == 3 || month == 5) {
      return day==1 || day == 2;
    } else {
      return day == 1;
    }
  }
}