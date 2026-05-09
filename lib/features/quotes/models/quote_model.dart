/// Quote model representing an API response from quotable.io.
class QuoteModel {
  final String content;
  final String author;

  QuoteModel({required this.content, required this.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      content: json['content'] ?? json['quote'] ?? '',
      author: json['author'] ?? 'Unknown',
    );
  }

  /// Fallback quote when API is unavailable.
  factory QuoteModel.fallback() {
    return QuoteModel(
      content: 'The secret of getting ahead is getting started.',
      author: 'Mark Twain',
    );
  }

  @override
  String toString() => 'QuoteModel(author: $author)';
}
