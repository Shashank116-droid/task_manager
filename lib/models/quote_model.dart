class QuoteModel {
  final String content;
  final String author;

  QuoteModel({required this.content, required this.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      content: json['content'] ?? json['q'] ?? 'Stay focused and never give up.',
      author: json['author'] ?? json['a'] ?? 'Anonymous',
    );
  }

  factory QuoteModel.fallback() {
    final fallbacks = [
      QuoteModel(content: "The secret of getting ahead is getting started.", author: "Mark Twain"),
      QuoteModel(content: "It always seems impossible until it's done.", author: "Nelson Mandela"),
      QuoteModel(content: "Don't watch the clock; do what it does. Keep going.", author: "Sam Levenson"),
      QuoteModel(content: "Believe you can and you're halfway there.", author: "Theodore Roosevelt"),
    ];
    return (fallbacks..shuffle()).first;
  }
}
