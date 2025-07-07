import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/core/utils/date_formatter.dart';

void main() {
  test('formats dates to dd/MM/yyyy', () {
    final formatted = formatDate(DateTime(2024, 7, 4));
    expect(formatted, '04/07/2024');
  });
}
