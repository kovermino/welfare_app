import 'package:flutter_test/flutter_test.dart';
import 'package:welfare_app/Util/vacation_calaulator.dart';

void main() async {

  group('Vacation Calculator test', () {

    test('vacation calculation first half case 1', () async {
      int result = VacationCalculator.calculateCurrentAvailableFromJoinedDate('2019-05-01','2020-05-29');
      expect(result, 15);
    });

    test('vacation calculation first half case 2', () async {
      int result = VacationCalculator.calculateCurrentAvailableFromJoinedDate('2019-05-01','2021-05-29');
      expect(result, 15);
    });

    test('vacation calculation first half case 3', () async {
      int result = VacationCalculator.calculateCurrentAvailableFromJoinedDate('2019-05-01','2022-05-29');
      expect(result, 16);
    });

    test('vacation calculation second half case 1', () async {
      int result = VacationCalculator.calculateCurrentAvailableFromJoinedDate('2019-07-01','2020-05-29');
      expect(result, 12);
    });

    test('vacation calculation second half case 2', () async {
      int result = VacationCalculator.calculateCurrentAvailableFromJoinedDate('2019-07-01','2021-05-29');
      expect(result, 15);
    });

    test('vacation calculation second half case 3', () async {
      int result = VacationCalculator.calculateCurrentAvailableFromJoinedDate('2019-07-01','2022-05-29');
      expect(result, 15);
    });

    test('vacation calculation second half case 4', () async {
      int result = VacationCalculator.calculateCurrentAvailableFromJoinedDate('2019-07-01','2023-05-29');
      expect(result, 16);
    });

  });
}