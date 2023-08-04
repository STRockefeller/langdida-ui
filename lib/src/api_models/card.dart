class CardModel {
  CardIndex index;
  List<String> labels;
  List<String> explanations;
  List<String> exampleSentences;
  int familiarity;
  String reviewDate;

  CardModel({
    required this.index,
    required this.labels,
    required this.explanations,
    required this.exampleSentences,
    required this.familiarity,
    required this.reviewDate,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      index: CardIndex.fromJson(json['index']),
      labels: List<String>.from(json['labels']),
      explanations: List<String>.from(json['explanations']),
      exampleSentences: List<String>.from(json['example_sentences']),
      familiarity: json['familiarity'] ?? 0,
      reviewDate: json['review_date'],
    );
  }

  static List<CardModel> arrayFromJson(List<Map<String, dynamic>> json) {
    List<CardModel> cardModels = json.map((cardJson) {
      return CardModel.fromJson(cardJson);
    }).toList();

    return cardModels;
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index.toJson(),
      'labels': labels,
      'explanations': explanations,
      'example_sentences': exampleSentences,
      'familiarity': familiarity,
      'review_date': reviewDate,
    };
  }
}

class CardIndex {
  String name;
  String language;

  CardIndex({required this.name, required this.language});

  factory CardIndex.fromJson(Map<String, dynamic> json) {
    return CardIndex(
      name: json['name'],
      language: json.containsKey('language') ? json['language'] : 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'language': language,
    };
  }
}

class CardAssociations {
  CardIndex index;
  List<CardIndex> synonyms;
  List<CardIndex> antonyms;
  CardIndex origin;
  List<CardIndex> derivatives;
  List<CardIndex> inOtherLanguages;
  List<CardIndex> others;

  CardAssociations({
    required this.index,
    required this.synonyms,
    required this.antonyms,
    required this.origin,
    required this.derivatives,
    required this.inOtherLanguages,
    required this.others,
  });

  factory CardAssociations.fromJson(Map<String, dynamic> json) {
    return CardAssociations(
      index: CardIndex.fromJson(json['index']),
      synonyms: List<CardIndex>.from(
          json['synonyms'].map((x) => CardIndex.fromJson(x))),
      antonyms: List<CardIndex>.from(
          json['antonyms'].map((x) => CardIndex.fromJson(x))),
      origin: CardIndex.fromJson(json['origin']),
      derivatives: List<CardIndex>.from(
          json['derivatives'].map((x) => CardIndex.fromJson(x))),
      inOtherLanguages: List<CardIndex>.from(
          json['inOtherLanguages'].map((x) => CardIndex.fromJson(x))),
      others: List<CardIndex>.from(
          json['others'].map((x) => CardIndex.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index.toJson();
    data['synonyms'] = synonyms.map((x) => x.toJson()).toList();
    data['antonyms'] = antonyms.map((x) => x.toJson()).toList();
    data['origin'] = origin.toJson();
    data['derivatives'] = derivatives.map((x) => x.toJson()).toList();
    data['inOtherLanguages'] = inOtherLanguages.map((x) => x.toJson()).toList();
    data['others'] = others.map((x) => x.toJson()).toList();
    return data;
  }
}

enum AssociationTypes {
  synonyms,
  antonyms,
  origin,
  derivatives,
  inOtherLanguages,
  others,
}

class CreateAssociationConditions {
  CardIndex cardIndex;
  CardIndex relatedCardIndex;
  AssociationTypes association;

  CreateAssociationConditions({
    required this.cardIndex,
    required this.relatedCardIndex,
    required this.association,
  });

  Map<String, dynamic> toJson() => {
        'CardIndex': cardIndex.toJson(),
        'RelatedCardIndex': relatedCardIndex.toJson(),
        'Association': association.index,
      };
}
