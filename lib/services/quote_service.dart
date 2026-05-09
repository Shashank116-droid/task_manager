import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';
import '../constants/app_constants.dart';

class QuoteService {
  final http.Client _client;

  QuoteService({http.Client? client}) : _client = client ?? http.Client();

  Future<QuoteModel> fetchRandomQuote() async {
    try {
      final url = '${AppConstants.quoteApiPrimary}?t=${DateTime.now().millisecondsSinceEpoch}';
      final response = await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return QuoteModel.fromJson(data);
      }
      throw Exception();
    } catch (_) {
      return _fetchFallbackQuote();
    }
  }

  Future<QuoteModel> _fetchFallbackQuote() async {
    try {
      final response = await _client.get(Uri.parse(AppConstants.quoteApiFallback)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return QuoteModel.fromJson(data[0]);
      }
      throw Exception();
    } catch (_) {
      return QuoteModel.fallback();
    }
  }
}
