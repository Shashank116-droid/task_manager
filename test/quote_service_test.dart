import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:task_manager/features/quotes/services/quote_service.dart';

void main() {
  test('returns quote from primary API when it succeeds', () async {
    final service = QuoteService(
      client: MockClient((request) async {
        expect(request.url.toString(), 'https://api.quotable.io/random');
        return http.Response(
          '{"content":"Start where you are.","author":"Arthur Ashe"}',
          200,
        );
      }),
    );

    final quote = await service.fetchRandomQuote();

    expect(quote.content, 'Start where you are.');
    expect(quote.author, 'Arthur Ashe');
  });

  test('uses ZenQuotes fallback when primary API fails', () async {
    var requestCount = 0;
    final service = QuoteService(
      client: MockClient((request) async {
        requestCount++;
        if (request.url.toString() == 'https://api.quotable.io/random') {
          return http.Response('Server error', 500);
        }
        return http.Response('[{"q":"Keep going.","a":"Unknown"}]', 200);
      }),
    );

    final quote = await service.fetchRandomQuote();

    expect(requestCount, 2);
    expect(quote.content, 'Keep going.');
    expect(quote.author, 'Unknown');
  });

  test('returns hardcoded fallback when both APIs fail', () async {
    final service = QuoteService(
      client: MockClient((request) async => http.Response('Server error', 500)),
    );

    final quote = await service.fetchRandomQuote();

    expect(quote.content, 'The secret of getting ahead is getting started.');
    expect(quote.author, 'Mark Twain');
  });
}
