class GetCardResponse {
  CardIndex index;
  List<String> labels;
  List<String> explanations;
  List<String> exampleSentences;
  int familiarity;
  String reviewDate;

  GetCardResponse({
    required this.index,
    required this.labels,
    required this.explanations,
    required this.exampleSentences,
    required this.familiarity,
    required this.reviewDate,
  });

  factory GetCardResponse.fromJson(Map<String, dynamic> json) {
    return GetCardResponse(
      index: CardIndex.fromJson(json['index']),
      labels: List<String>.from(json['labels']),
      explanations: List<String>.from(json['explanations']),
      exampleSentences: List<String>.from(json['example_sentences']),
      familiarity: json['familiarity'],
      reviewDate: json['review_date'],
    );
  }
}

class CardIndex {
  String name;
  String language;

  CardIndex({required this.name, required this.language});

  factory CardIndex.fromJson(Map<String, dynamic> json) {
    return CardIndex(
      name: json['name'],
      language: json['language'],
    );
  }
}
