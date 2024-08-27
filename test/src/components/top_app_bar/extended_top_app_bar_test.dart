import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../../test_utils/test_app.dart';
import '../../../test_utils/tolerant_comparator.dart';
import '../../../test_utils/utils.dart';

void main() {
  setUpAll(() {
    final testUri = Uri.parse(getCurrentPath('top_app_bar'));
    goldenFileComparator = TolerantComparator(testUri, tolerance: 0.01);
  });

  testWidgets('ZetaExtendedAppBarDelegate builds correctly', (WidgetTester tester) async {
    const title = Text('Title');
    final actions = [IconButton(icon: const Icon(Icons.search), onPressed: () {})];
    final leading = IconButton(icon: const Icon(Icons.menu), onPressed: () {});
    const boxKey = Key('box');
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(481, 480);

    await tester.pumpWidget(
      TestApp(
        home: Builder(
          builder: (context) {
            return SizedBox(
              child: CustomScrollView(
                slivers: [
                  ZetaTopAppBar.extended(leading: leading, title: title, actions: actions),
                  SliverToBoxAdapter(
                    child: Container(
                      width: 800,
                      height: 700,
                      color: Zeta.of(context).colors.surfaceSelectedHover,
                      key: boxKey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    final boxFinder = find.byKey(boxKey);
    expect(boxFinder, findsOneWidget);

    await tester.drag(boxFinder.first, const Offset(0, -100));
    await tester.pumpAndSettle();

    final appBarFinder = find.byType(ZetaTopAppBar);
    expect(appBarFinder, findsOneWidget);

    final titleFinder = find.descendant(of: appBarFinder, matching: find.byWidget(title));
    expect(titleFinder, findsOneWidget);

    final actionsFinder = find.descendant(of: appBarFinder, matching: find.byWidget(actions[0]));
    expect(actionsFinder, findsOneWidget);

    final leadingFinder = find.descendant(of: appBarFinder, matching: find.byWidget(leading));
    expect(leadingFinder, findsOneWidget);

    await expectLater(
      appBarFinder,
      matchesGoldenFile(join(getCurrentPath('top_app_bar'), 'extended_app_bar_shrinks.png')),
    );
  });

  testWidgets('ZetaExtendedAppBarDelegate shrinks correctly with padding', (WidgetTester tester) async {
    const title = Text('Title');
    final actions = [IconButton(icon: const Icon(Icons.search), onPressed: () {})];
    final leading = IconButton(icon: const Icon(Icons.menu), onPressed: () {});
    const boxKey = Key('box');
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(481, 480);

    await tester.pumpWidget(
      TestApp(
        home: Builder(
          builder: (context) {
            return SizedBox(
              child: CustomScrollView(
                slivers: [
                  ZetaTopAppBar.extended(leading: leading, title: title, actions: actions),
                  SliverToBoxAdapter(
                    child: Container(
                      width: 800,
                      height: 700,
                      color: Zeta.of(context).colors.surfaceSelectedHover,
                      key: boxKey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    final boxFinder = find.byKey(boxKey);
    expect(boxFinder, findsOneWidget);

    await tester.drag(boxFinder.first, const Offset(0, -100));
    await tester.pumpAndSettle();

    final appBarFinder = find.byType(ZetaTopAppBar);
    expect(appBarFinder, findsOneWidget);

    final positionedFinder = find.descendant(of: appBarFinder, matching: find.byType(Positioned));

    final positionedWidget = tester.widget<Positioned>(positionedFinder.first);
    expect(positionedWidget.left, 60);
  });
  testWidgets('ZetaExtendedAppBarDelegate shrinks correctly with padding and no leading', (WidgetTester tester) async {
    const title = Text('Title');
    final actions = [IconButton(icon: const Icon(Icons.search), onPressed: () {})];

    const boxKey = Key('box');
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(481, 480);

    await tester.pumpWidget(
      TestApp(
        home: Builder(
          builder: (context) {
            return SizedBox(
              child: CustomScrollView(
                slivers: [
                  ZetaTopAppBar.extended(title: title, actions: actions),
                  SliverToBoxAdapter(
                    child: Container(
                      width: 800,
                      height: 700,
                      color: Zeta.of(context).colors.surfaceSelectedHover,
                      key: boxKey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    final boxFinder = find.byKey(boxKey);
    expect(boxFinder, findsOneWidget);

    await tester.drag(boxFinder.first, const Offset(0, -100));
    await tester.pumpAndSettle();

    final appBarFinder = find.byType(ZetaTopAppBar);
    expect(appBarFinder, findsOneWidget);

    final positionedFinder = find.descendant(of: appBarFinder, matching: find.byType(Positioned));

    final positionedWidget = tester.widget<Positioned>(positionedFinder.first);
    expect(positionedWidget.left, 16);

    await expectLater(
      appBarFinder,
      matchesGoldenFile(join(getCurrentPath('top_app_bar'), 'extended_app_bar_shrinks_with_no_leading.png')),
    );
  });
}