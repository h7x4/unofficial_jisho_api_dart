/* -------------------------------------------------------------------------- */
/*                       searchForKanji related classes                       */
/* -------------------------------------------------------------------------- */

class YomiExample {
  String example;
  String reading;
  String meaning;

  YomiExample({this.example, this.reading, this.meaning});

  Map<String, String> toJson() =>
      {'example': example, 'reading': reading, 'meaning': meaning};
}

class Radical {
  String symbol;
  List<String> forms;
  String meaning;

  Radical({this.symbol, this.forms, this.meaning});

  Map<String, dynamic> toJson() =>
      {'symbol': symbol, 'forms': forms, 'meaning': meaning};
}

class KanjiResult {
  String query;
  bool found;

  String taughtIn;
  String jlptLevel;
  int newspaperFrequencyRank;
  int strokeCount;
  String meaning;
  List<String> kunyomi;
  List<String> onyomi;
  List<YomiExample> kunyomiExamples;
  List<YomiExample> onyomiExamples;
  Radical radical;
  List<String> parts;
  String strokeOrderDiagramUri;
  String strokeOrderSvgUri;
  String strokeOrderGifUri;
  String uri;

  KanjiResult(
      {this.query,
      this.found,
      this.taughtIn,
      this.jlptLevel,
      this.newspaperFrequencyRank,
      this.strokeCount,
      this.meaning,
      this.kunyomi,
      this.onyomi,
      this.kunyomiExamples,
      this.onyomiExamples,
      this.radical,
      this.parts,
      this.strokeOrderDiagramUri,
      this.strokeOrderSvgUri,
      this.strokeOrderGifUri,
      this.uri});

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'found': found,
      'taughtIn': taughtIn,
      'jlptLevel': jlptLevel,
      'newspaperFrequencyRank': newspaperFrequencyRank,
      'strokeCount': strokeCount,
      'meaning': meaning,
      'kunyomi': kunyomi,
      'onyomi': onyomi,
      'onyomiExamples': onyomiExamples,
      'kunyomiExamples': kunyomiExamples,
      'radical': (radical != null) ? radical.toJson() : null,
      'parts': parts,
      'strokeOrderDiagramUri': strokeOrderDiagramUri,
      'strokeOrderSvgUri': strokeOrderSvgUri,
      'strokeOrderGifUri': strokeOrderGifUri,
      'uri': uri
    };
  }
}

/* -------------------------------------------------------------------------- */
/*                      searchForExamples related classes                     */
/* -------------------------------------------------------------------------- */

class ExampleSentencePiece {
  String lifted;
  String unlifted;

  ExampleSentencePiece({this.lifted, this.unlifted});

  Map<String, dynamic> toJson() {
    return {'lifted': lifted, 'unlifted': unlifted};
  }
}

class ExampleResultData {
  String kanji;
  String kana;
  String english;
  List<ExampleSentencePiece> pieces;

  ExampleResultData({this.english, this.kanji, this.kana, this.pieces});

  Map<String, dynamic> toJson() {
    return {'english': english, 'kanji': kanji, 'kana': kana, 'pieces': pieces};
  }
}

class ExampleResults {
  String query;
  bool found;
  String uri;
  List<ExampleResultData> results;
  String phrase;

  ExampleResults({this.query, this.found, this.results, this.uri, this.phrase});

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'found': found,
      'results': results,
      'uri': uri,
      'phrase': phrase
    };
  }
}

/* -------------------------------------------------------------------------- */
/*                       scrapeForPhrase related classes                      */
/* -------------------------------------------------------------------------- */

class PhraseScrapeSentence {
  String english;
  String japanese;
  List<ExampleSentencePiece> pieces;

  PhraseScrapeSentence({this.english, this.japanese, this.pieces});

  Map<String, dynamic> toJson() =>
      {'english': english, 'japanese': japanese, 'pieces': pieces};
}

class PhraseScrapeMeaning {
  List<String> seeAlsoTerms;
  List<PhraseScrapeSentence> sentences;
  String definition;
  List<String> supplemental;
  String definitionAbstract;
  List<String> tags;

  PhraseScrapeMeaning(
      {this.seeAlsoTerms,
      this.sentences,
      this.definition,
      this.supplemental,
      this.definitionAbstract,
      this.tags});

  Map<String, dynamic> toJson() => {
        'seeAlsoTerms': seeAlsoTerms,
        'sentences': sentences,
        'definition': definition,
        'supplemental': supplemental,
        'definitionAbstract': definitionAbstract,
        'tags': tags
      };
}

class KanjiKanaPair {
  String kanji;
  String kana;

  KanjiKanaPair({this.kanji, this.kana});

  Map<String, String> toJson() => {'kanji': kanji, 'kana': kana};
}

class PhrasePageScrapeResult {
  bool found;
  String query;
  String uri;
  List<String> tags;
  List<PhraseScrapeMeaning> meanings;
  List<KanjiKanaPair> otherForms;
  List<String> notes;

  PhrasePageScrapeResult(
      {this.found,
      this.query,
      this.uri,
      this.tags,
      this.meanings,
      this.otherForms,
      this.notes});

  Map<String, dynamic> toJson() => {
        'found': found,
        'query': query,
        'uri': uri,
        'tags': tags,
        'meanings': meanings,
        'otherForms': otherForms,
        'notes': notes
      };
}

/* -------------------------------------------------------------------------- */
/*                       searchForPhrase related classes                      */
/* -------------------------------------------------------------------------- */

class JishoJapaneseWord {
  String word;
  String reading;

  JishoJapaneseWord({this.word, this.reading});

  factory JishoJapaneseWord.fromJson(Map<String, dynamic> json) {
    return JishoJapaneseWord(
        word: json['word'] as String, reading: json['reading'] as String);
  }

  Map<String, dynamic> toJson() => {'word': word, 'reading': reading};
}

class JishoSenseLink {
  String text;
  String url;

  JishoSenseLink({this.text, this.url});

  factory JishoSenseLink.fromJson(Map<String, dynamic> json) {
    return JishoSenseLink(
        text: json['text'] as String, url: json['url'] as String);
  }

  Map<String, dynamic> toJson() => {'text': text, 'url': url};
}

class JishoWordSense {
  List<String> english_definitions;
  List<String> parts_of_speech;
  List<JishoSenseLink> links;
  List<String> tags;
  List<String> see_also;
  List<String> antonyms;
  List<dynamic> source;
  List<String> info;
  List<dynamic> restrictions;

  JishoWordSense(
      {this.english_definitions,
      this.parts_of_speech,
      this.links,
      this.tags,
      this.see_also,
      this.antonyms,
      this.source,
      this.info,
      this.restrictions});

  factory JishoWordSense.fromJson(Map<String, dynamic> json) {
    return JishoWordSense(
        english_definitions: (json['english_definitions'] as List)
            .map((result) => result as String)
            .toList(),
        parts_of_speech: (json['parts_of_speech'] as List)
            .map((result) => result as String)
            .toList(),
        links: (json['links'] as List)
            .map((result) => JishoSenseLink.fromJson(result))
            .toList(),
        tags: (json['tags'] as List).map((result) => result as String).toList(),
        see_also: (json['see_also'] as List)
            .map((result) => result as String)
            .toList(),
        antonyms: (json['antonyms'] as List)
            .map((result) => result as String)
            .toList(),
        source: json['source'] as List<dynamic>,
        info: (json['info'] as List).map((result) => result as String).toList(),
        restrictions: json['restrictions'] as List<dynamic>);
  }

  Map<String, dynamic> toJson() => {
        'english_definitions': english_definitions,
        'parts_of_speech': parts_of_speech,
        'links': links,
        'tags': tags,
        'see_also': see_also,
        'antonyms': antonyms,
        'source': source,
        'info': info,
        'restrictions': restrictions
      };
}

class JishoAttribution {
  bool jmdict;
  bool jmnedict;
  String dbpedia;

  JishoAttribution({this.jmdict, this.jmnedict, this.dbpedia});

  factory JishoAttribution.fromJson(Map<String, dynamic> json) {
    return JishoAttribution(
        jmdict: (json['jmdict'].toString() == 'true'),
        jmnedict: (json['jmnedict'].toString() == 'true'),
        dbpedia: (json['dbpedia'].toString() != 'false')
            ? json['dbpedia'].toString()
            : null);
  }

  Map<String, dynamic> toJson() =>
      {'jmdict': jmdict, 'jmnedict': jmnedict, 'dbpedia': dbpedia};
}

class JishoResult {
  String slug;
  bool is_common;
  List<String> tags;
  List<String> jlpt;
  List<JishoJapaneseWord> japanese;
  List<JishoWordSense> senses;
  JishoAttribution attribution;

  JishoResult(
      {this.slug,
      this.is_common,
      this.tags,
      this.jlpt,
      this.japanese,
      this.senses,
      this.attribution});

  factory JishoResult.fromJson(Map<String, dynamic> json) {
    return JishoResult(
        slug: json['slug'] as String,
        is_common: json['is_common'] as bool,
        tags: (json['tags'] as List).map((result) => result as String).toList(),
        jlpt: (json['jlpt'] as List).map((result) => result as String).toList(),
        japanese: (json['japanese'] as List)
            .map((result) => JishoJapaneseWord.fromJson(result))
            .toList(),
        senses: (json['senses'] as List)
            .map((result) => JishoWordSense.fromJson(result))
            .toList(),
        attribution: JishoAttribution.fromJson(json['attribution']));
  }

  Map<String, dynamic> toJson() => {
        'slug': slug,
        'is_common': is_common,
        'tags': tags,
        'jlpt': jlpt,
        'japanese': japanese,
        'senses': senses,
        'attribution': attribution
      };
}

class JishoResultMeta {
  int status;

  JishoResultMeta({this.status});

  factory JishoResultMeta.fromJson(Map<String, dynamic> json) {
    return JishoResultMeta(status: json['status'] as int);
  }

  Map<String, dynamic> toJson() => {'status': status};
}

class JishoAPIResult {
  JishoResultMeta meta;
  List<JishoResult> data;

  JishoAPIResult({this.meta, this.data});

  factory JishoAPIResult.fromJson(Map<String, dynamic> json) {
    return JishoAPIResult(
        meta: JishoResultMeta.fromJson(json['meta']),
        data: (json['data'] as List)
            .map((result) => JishoResult.fromJson(result))
            .toList());
  }

  Map<String, dynamic> toJson() => {'meta': meta.toJson(), 'data': data};
}
