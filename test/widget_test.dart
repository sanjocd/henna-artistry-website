import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterpro/main.dart';

void main() {
  testWidgets('landing page adapts to laptop and phone widths', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const MehndiApp());
    await tester.pumpAndSettle();

    expect(find.text('Henna art,\nmade for you.'), findsOneWidget);
    expect(find.text('Mehndi for every moment'), findsOneWidget);
    expect(find.text('Made for your occasion'), findsOneWidget);
    expect(find.text('HENNA ARTISTRY'), findsWidgets);
    expect(find.text('Book on WhatsApp'), findsOneWidget);
    expect(find.text('Kochi & Kottayam, Kerala'), findsWidgets);
    expect(find.textContaining('9037211596'), findsNothing);
    expect(find.textContaining('903 721 1596'), findsNothing);
    expect(find.byType(Image), findsNWidgets(5));
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();

    expect(find.byTooltip('Open menu'), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('mobile navigation opens and closes', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const MehndiApp());

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    expect(find.text('Book your date'), findsOneWidget);

    await tester.tap(find.byTooltip('Close menu'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Open menu'), findsOneWidget);

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
