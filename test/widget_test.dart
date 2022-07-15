// This is an example Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
//
// Visit https://flutter.dev/docs/cookbook/testing/widget/introduction for
// more information about Widget testing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:test_driven_app/src/article.dart';
import 'package:test_driven_app/src/news_change_notifier.dart';
import 'package:test_driven_app/src/news_page.dart';
/*
import 'package:test_driven_app/src/article.dart';
import 'package:test_driven_app/src/news_change_notifier.dart'; */
import 'package:test_driven_app/src/news_service.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;
  setUp(() {
    mockNewsService = MockNewsService();
  });

  final articlesFromService = [
    Article(title: 'Test1', content: 'Test 1 content'),
    Article(title: 'Test2', content: 'Test 2 content'),
    Article(title: 'Test3', content: 'Test 3 content'),
  ];
  void arrangeNewsServiceReturns() {
    when(() => mockNewsService.getArticles())
        .thenAnswer((_) async => articlesFromService);
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
        title: 'News App',
        home: ChangeNotifierProvider(
          create: (_) => NewsChangeNotifier(mockNewsService),
          child: const NewsPage(),
        ));
  }
// Above this widget test. It is kind of all setup for widget test.
// Business logic or logic should be loaded before testing Widget.
// So we call all the Mock Data and widget and then run the test funcion.

  testWidgets("Title is displayed", (WidgetTester tester) async {
    arrangeNewsServiceReturns();
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text("News"), findsOneWidget);
  });

// setting up for "waiting for articles"

  void arrangeNewsServiceReturnsAfterWaiting() {
    when(() => mockNewsService.getArticles()).thenAnswer(
      (_) async {
        await Future.delayed(const Duration(seconds: 2));
        return articlesFromService;
      },
    );
  }

  testWidgets(
    "Loading indicator is displayed while waiting for articles",
    (WidgetTester tester) async {
      arrangeNewsServiceReturnsAfterWaiting();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byKey(Key('progress-indicator')), findsOneWidget);
      await tester.pumpAndSettle();
      // This function needed to make test run while the business logic(arrangeNewsServiceReturnsAfterWaiting) is still running.
      // It will wait till the target widget ends.
    },
  );

  testWidgets(
    "Articles are displayed",
    (WidgetTester tester) async {
      arrangeNewsServiceReturns();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // When the business logic happens instantly, no duration needed.
      for(final article in articlesFromService ){
        expect(find.text(article.title), findsOneWidget);
        expect(find.text(article.content), findsOneWidget);
      }

    },
  );

  group('MyWidget', () {
    testWidgets('should display a string of text', (WidgetTester tester) async {
      // Define a Widget
      const myWidget = MaterialApp(
        home: Scaffold(
          body: Text('Hello'),
        ),
      );

      // Build myWidget and trigger a frame.
      await tester.pumpWidget(myWidget);

      // Verify myWidget shows some text
      expect(find.byType(Text), findsOneWidget);
    });
  });
}
