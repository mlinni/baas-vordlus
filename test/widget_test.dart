import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baas_vordlus/app/app.dart';
import 'package:baas_vordlus/services/fake/fake_auth_repository.dart';
import 'package:baas_vordlus/services/fake/fake_profile_repository.dart';
import 'package:baas_vordlus/services/fake/fake_storage_repository.dart';

void main() {
  BaaSVordlusApp buildTestApp() {
    return BaaSVordlusApp(
      authRepository: FakeAuthRepository(),
      profileRepository: FakeProfileRepository(),
      storageRepository: FakeStorageRepository(),
    );
  }

  testWidgets('app shows login screen initially', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());

    expect(find.text('BaaS voordlusrakendus'), findsOneWidget);
    expect(find.text('Logi sisse'), findsOneWidget);
    expect(find.text('Registreeru parooliga'), findsNothing);
  });

  testWidgets('user can sign in to profile screen', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'demo@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    await tester.tap(find.text('Logi sisse'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Profiil'), findsOneWidget);
    expect(find.text('demo@example.com'), findsOneWidget);
  });

  testWidgets('invalid password keeps user on login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'demo@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'vale-parool');

    await tester.tap(find.text('Logi sisse'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Profiil'), findsNothing);
    expect(find.text('Vale e-post voi parool.'), findsOneWidget);
  });
}
