import 'package:flutter_test/flutter_test.dart';
import 'package:welfare_app/Repository/RepositoryImpl/vacation_repository_sqlite.dart';
import 'package:welfare_app/constants.dart';

void main() async {
  final VacationRepositoryImplSqlite repo = VacationRepositoryImplSqlite.instance;

  group('Vacation Repository for SQLite', () {

    test('insert vacation records', () async {
        // row to insert
        Map<String, dynamic> row = {
          VacationRepositoryImplSqlite.columnDate : '2020-05-01',
          VacationRepositoryImplSqlite.columnVacationType  : kVacationTypes[0],
          VacationRepositoryImplSqlite.columnDeduction: 1,
          VacationRepositoryImplSqlite.columnRemark: 'blah blah..'
        };
        final id = await repo.insert(row);
        print('inserted row id: $id');
    });

  });
}