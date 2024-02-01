import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Verify Chart Test', () {
    late FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });
    test('verify SixMonthsChart', () async {
      final bottomNavigationBarFinder = find.byType('BottomNavigationBar');
      final historiaTabFinder = find.text('Historia');
      await driver.tap(historiaTabFinder);
      await Future.delayed(Duration(seconds: 1));
      final inputNumberChartFinder = find.byValueKey('chart');
      await driver.waitFor(inputNumberChartFinder);
    });
  });
  group('Logout Test', () {
    late FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
    test('logout', () async {
      final settingsButtonFinder = find.byValueKey('settings');
      final logoutButtonFinder = find.text('Wyloguj się');
      final emailFieldFinder = find.byValueKey('emailField');
      await driver.tap(settingsButtonFinder);
      await driver.tap(logoutButtonFinder);
      await driver.waitFor(emailFieldFinder);
    });
  });
}
