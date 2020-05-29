import 'package:welfare_app/VO/VacationRecord.dart';

abstract class VacationRepository {

  void insertVacationRecord(VacationRecord record);
  List<VacationRecord> getAllVacationRecords();
  void updateVacationRecord(VacationRecord record);
  void deleteVacationRecord(String date);
  
}