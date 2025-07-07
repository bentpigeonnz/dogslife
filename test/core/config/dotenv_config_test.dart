import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  test('Loads .env file', () async {
    await dotenv.load(fileName: ".env");
    expect(dotenv.env['FIREBASE_API_KEY'], isNotNull);
  });
}
