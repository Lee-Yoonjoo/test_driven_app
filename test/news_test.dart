import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:test_driven_app/src/article.dart';
import 'package:test_driven_app/src/news_change_notifier.dart';
import 'package:test_driven_app/src/news_service.dart';

class BadMockNewsService implements NewsService {
  bool getArticlesCalled = false;

  @override
  Future<List<Article>> getArticles() async {
    getArticlesCalled = true;
    return [
      Article(title: 'Test1', content: 'Test 1 content'),
      Article(title: 'Test2', content: 'Test 2 content'),
      Article(title: 'Test3', content: 'Test 3 content'),
      Article(title: 'Test4', content: 'Test 4 content'),
      Article(title: 'Test5', content: 'Test 5 content'),
      Article(title: 'Test6', content: 'Test 6 content'),
      Article(title: 'Test7', content: 'Test 7 content'),
      Article(title: 'Test8', content: 'Test 8 content'),
      Article(title: 'Test9', content: 'Test 9 content'),
    ];
  }
}

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  //system under test; why late? you should initialize everything for test.
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test("initial values are correct", () {
    expect(sut.articles, []);
    expect(sut.isLoading, false);
  });

  group('getArticles', () {
    final articlesFromService = [
      Article(title: 'Test1', content: 'Test 1 content'),
      Article(title: 'Test2', content: 'Test 2 content'),
      Article(title: 'Test3', content: 'Test 3 content'),
    ];
    void arrangeNewsServiceReturns() {
      when(() => mockNewsService.getArticles())
          .thenAnswer((_) async => articlesFromService);
    }

    test(
      "gets articles using the NewsService",
      () async {
        //when(() => mockNewsService.getArticles()).thenAnswer((_) async => []);
        arrangeNewsServiceReturns();
        await sut.getArticles();
        verify(() => mockNewsService.getArticles()).called(1);
        //
      },
    );
    test(
      """indicaets loading of data,
    sets articles to the ones from the service,
    indicates that data is not being loaded anymore""",
      () async {
        arrangeNewsServiceReturns();
        final future = sut.getArticles();
        expect(sut.isLoading, true);
        await future;
        expect(sut.articles, articlesFromService);
        expect(sut.isLoading, false);
      },
    );
  });
}
