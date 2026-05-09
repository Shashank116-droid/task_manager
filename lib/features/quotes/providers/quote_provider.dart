import 'package:flutter/material.dart';
import 'package:task_manager/features/quotes/models/quote_model.dart';
import 'package:task_manager/features/quotes/services/quote_service.dart';

/// Quote state management provider.
class QuoteProvider extends ChangeNotifier {
  final QuoteService _quoteService = QuoteService();

  QuoteModel? _quote;
  bool _isLoading = false;
  String? _error;

  // ── Getters ──────────────────────────────────────────────
  QuoteModel? get quote => _quote;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetches a new random quote.
  Future<void> fetchQuote() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _quote = await _quoteService.fetchRandomQuote();
    } catch (e) {
      _error = 'Could not load quote';
      _quote = QuoteModel.fallback();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refreshes the quote (retry).
  Future<void> refresh() async {
    await fetchQuote();
  }
}
