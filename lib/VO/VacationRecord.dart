import 'package:welfare_app/constants.dart';

class VacationRecord {
  String date;
  String vacationType;
  double deduction;
  String remark;

  VacationRecord(this.date, this.vacationType, this.remark){
    if (vacationType == kVacationTypes[0]) {
      deduction = 1;
    }else if (vacationType == kVacationTypes[1]) {
      deduction = 0.5;
    }else {
      deduction = 0;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'date' : date,
      'vacation_type': vacationType,
      'deduction' : deduction,
      'remark' : remark
    };
  }

  VacationRecord.fromMap(Map<String, dynamic> map) {
    this.date = map['date'];
    this.vacationType = map['vacation_type'];
    this.deduction = map['deduction'].toDouble();
    this.remark = map['remark'];
  }
}