import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_manager/features/quotes/models/quote_model.dart';

/// Service for fetching motivational quotes from the Quotable API.
class QuoteService {
  final http.Client _client;

  QuoteService({http.Client? client}) : _client = client ?? http.Client();

  // Primary API
  static const String _primaryUrl = 'https://api.quotable.io/random';
  // Fallback API (ZenQuotes)
  static const String _fallbackUrl = 'https://zenquotes.io/api/random';

  /// Fetches a random motivational quote.
  /// Falls back to ZenQuotes if the primary API fails,
  /// and to a hardcoded quote if both fail.
  Future<QuoteModel> fetchRandomQuote() async {
    try {
      // Try primary API
      final response = await _client
          .get(Uri.parse(_primaryUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return QuoteModel.fromJson(json);
      }
    } catch (_) {
      // Primary API failed, try fallback
    }

    try {
      // Try fallback API
      final response = await _client
          .get(Uri.parse(_fallbackUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List<dynamic>;
        if (jsonList.isNotEmpty) {
          final json = jsonList[0] as Map<String, dynamic>;
          return QuoteModel(
            content: json['q'] ?? '',
            author: json['a'] ?? 'Unknown',
          );
        }
      }
    } catch (_) {
      // Fallback API also failed
    }

    // Return hardcoded fallback
    return QuoteModel.fallback();
  }
}
