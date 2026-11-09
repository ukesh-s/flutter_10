import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:experiment_10/main.dart';

void main() {
  testWidgets('validates login and displays simulated success', (tester) async {
    await tester.pumpWidget(const LoginDemoApp());
    expect(find.text('Welcome back'), findsOneWidget);
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('Use at least 8 characters'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextFormField, 'Email address'), 'demo@example.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Demo signed in as demo@example.com'), findsOneWidget);
  });
}
