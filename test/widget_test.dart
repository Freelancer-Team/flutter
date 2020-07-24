// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freelancer_flutter/pages/home.dart';
import 'package:freelancer_flutter/pages/login.dart';
import 'package:freelancer_flutter/pages/publish.dart';

import 'package:freelancer_flutter/main.dart';

void main() {
  testWidgets("failing test example", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
//        home: PublishPage(),
          home: LoginScreen(),
      ),
    );
//    await tester.enterText(find.byWidget(emailAddressControl), 'dkfyfvgu@163.com');
//    await tester.enterText(find.byType(TextField).at(1), '536');
//      expect(find.byType(TextField), findsNWidgets(2));
    await tester.enterText(find.byType(TextField).first, 'dkfyfvgu@163.com');
    await tester.enterText(find.byType(TextField).last, '536');
    await tester.pump();

//    expect(find.byType(), matcher)

//     expect(actual, matcher)
//    expect(find.text('Publish A Project'), findsOneWidget);
//    expect(find.byType(TextFormField), findsNWidgets(5));
//     await tester.pumpWidget(MyApp());
//     expect(find.byWidget(HomePage()), findsOneWidget);
  });
//  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//    // Build our app and trigger a frame.
//    await tester.pumpWidget(MyApp());
//
//    // Verify that our counter starts at 0.
//    expect(find.text('0'), findsOneWidget);
//    expect(find.text('1'), findsNothing);
//
//    // Tap the '+' icon and trigger a frame.
//    await tester.tap(find.byIcon(Icons.add));
//    await tester.pump();
//
//    // Verify that our counter has incremented.
//    expect(find.text('0'), findsNothing);
//    expect(find.text('1'), findsOneWidget);
//  });
}
