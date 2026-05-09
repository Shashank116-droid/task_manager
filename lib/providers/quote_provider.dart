import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/quote_service.dart';

class QuoteProvider extends ChangeNotifier {
  final QuoteService _quoteService = QuoteService();
  QuoteModel? _quote;
  bool _isLoading = true;

  QuoteModel? get quote => _quote;
  bool get isLoading => _isLoading;

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    _quote = await _quoteService.fetchRandomQuote();
    _isLoading = false;
    notifyListeners();
  }
}
