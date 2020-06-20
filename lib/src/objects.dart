/* -------------------------------------------------------------------------- */
/*                       searchForKanji related classes                       */
/* -------------------------------------------------------------------------- */

class YomiExample {
  String example;
  String reading;
  String meaning;

  YomiExample({String example, String reading, String meaning})
  {
    this.example = example;
    this.reading = reading;
    this.meaning = meaning;
  }

  Map<String, String> toJson() =>
  {
    'example': example,
    'reading': reading,
    'meaning': meaning
  }; 

}

class Radical {
  String symbol;
  List<String> forms;
  String meaning;

  Radical({String symbol, List<String> forms, String meaning}){
    this.symbol = symbol;
    this.forms = forms;
    this.meaning = meaning;
  }

  Map<String, dynamic> toJson() =>
    {
      'symbol': symbol,
      'forms': forms,
      'meaning': meaning
    }; 

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

  Map<String, dynamic> toJson() {

    if (found == false) {
      return {
        'query': query,
        'found': found
      };
    }

    var returnObject = {
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
      'radical': radical.toJson(),
      'parts': parts,
      'strokeOrderDiagramUri': strokeOrderDiagramUri,
      'strokeOrderSvgUri': strokeOrderSvgUri,
      'strokeOrderGifUri': strokeOrderGifUri,
      'uri': uri
    };
    
    return returnObject;
  }
}

/* -------------------------------------------------------------------------- */
/*                      searchForExamples related classes                     */
/* -------------------------------------------------------------------------- */

class ExampleSentencePiece {
  String lifted;
  String unlifted;

  ExampleSentencePiece({String lifted, String unlifted}){
    this.lifted = lifted;
    this.unlifted = unlifted;
  }

  Map<String, dynamic> toJson() {
    return {
      'lifted': lifted,
      'unlifted': unlifted
    };
  }
}

class ExampleResultData {
  String kanji;
  String kana;
  String english;
  List<ExampleSentencePiece> pieces;

  ExampleResultData({String english, String kanji, String kana, List<ExampleSentencePiece> pieces}){
    this.english = english;
    this.kanji = kanji;
    this.kana = kana;
    this.pieces = pieces;
  }

  Map<String, dynamic> toJson() {
    return {
      'english': english,
      'kanji': kanji,
      'kana': kana,
      'pieces': pieces
    };
  }
}

class ExampleResults {
  String query;
  bool found;
  String uri;
  List<ExampleResultData> results;
  String phrase;

  ExampleResults({String query, bool found, List<ExampleResultData> results, String uri, String phrase}){
    this.query = query;
    this.found = found;
    this.results = results;
    this.uri = uri;
    this.phrase = phrase;
  }

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

  PhraseScrapeSentence ({String english, String japanese, List<ExampleSentencePiece> pieces}){
    this.english = english;
    this.japanese = japanese;
    this.pieces = pieces;
  }

  Map<String, dynamic> toJson() => {
    'english': english,
    'japanese': japanese,
    'pieces': pieces
  };
}

class PhraseScrapeMeaning {
  List<String> seeAlsoTerms;
  List<PhraseScrapeSentence> sentences;
  String definition;
  List<String> supplemental;
  String definitionAbstract;
  List<String> tags;

  PhraseScrapeMeaning({
    List<String> seeAlsoTerms,
    List<PhraseScrapeSentence> sentences,
    String definition,
    List<String> supplemental,
    String definitionAbstract,
    List<String> tags,
  }){
    this.seeAlsoTerms = seeAlsoTerms;
    this.sentences = sentences;
    this.definition = definition;
    this.supplemental = supplemental;
    this.definitionAbstract = definitionAbstract;
    this.tags = tags;
    
  }

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

  KanjiKanaPair({
    String kanji,
    String kana
  }){
    this.kanji = kanji;
    this.kana = kana;
  }

  Map<String, String> toJson() => {
    'kanji': kanji,
    'kana': kana
  };
}

class PhrasePageScrapeResult {
  bool found;
  String query;
  String uri;
  List<String> tags;
  List<PhraseScrapeMeaning> meanings;
  List<KanjiKanaPair> otherForms;
  List<String> notes;

  PhrasePageScrapeResult({
    bool found,
    String query,
    String uri,
    List<String> tags,
    List<PhraseScrapeMeaning> meanings,
    List<KanjiKanaPair> otherForms,
    List<String> notes,
  }){
    this.found = found;
    this.query = query;
    this.uri = uri;
    this.tags = tags;
    this.meanings = meanings;
    this.otherForms = otherForms;
    this.notes = notes;
  }

  Map<String, dynamic> toJson() =>
  {
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

  factory JishoJapaneseWord.fromJson(Map<String, dynamic> json){
    return JishoJapaneseWord(
      word: json['word'] as String,
      reading: json['reading'] as String
    );
    
  }
}

class JishoSenseLink {
  String text;
  String url;

  JishoSenseLink({this.text, this.url});

  factory JishoSenseLink.fromJson(Map<String, dynamic> json){
    return JishoSenseLink(
      text: json['text'] as String,
      url: json['url'] as String
    );
  }
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

  JishoWordSense({
    this.english_definitions,
    this.parts_of_speech,
    this.links,
    this.tags,
    this.see_also,
    this.antonyms,
    this.source,
    this.info,
    this.restrictions
  });

  factory JishoWordSense.fromJson(Map<String, dynamic> json){
    return JishoWordSense(
      english_definitions: json['english_definitions'] as List<String>,
      parts_of_speech: json['parts_of_speech'] as List<String>,
      links: json['links'] as List<JishoSenseLink>,
      tags: json['tags'] as List<String>,
      see_also: json['see_also'] as List<String>,
      antonyms: json['antonyms'] as List<String>,
      source: json['source'] as List<dynamic>,
      info: json['info'] as List<String>,
      restrictions: json['restrictions'] as List<dynamic>
    );
  }
}

class JishoAttribution {
  bool jmdict;
  bool jmnedict;
  bool dbpedia;

  JishoAttribution({
    this.jmdict,
    this.jmnedict,
    this.dbpedia
  });

  factory JishoAttribution.fromJson(Map<String, dynamic> json){
    return JishoAttribution(
      jmdict: json['jmdict'] as bool,
      jmnedict: json['jmnedict'] as bool,
      dbpedia: json['dbpedia'] as bool
    );
  }
}

class JishoResult {
  String slug;
  bool is_common;
  List<String> tags;
  List<String> jlpt;
  List<JishoJapaneseWord> japanese;
  List<JishoWordSense> senses;
  JishoAttribution attribution;

  JishoResult({
    this.slug,
    this.is_common,
    this.tags,
    this.jlpt,
    this.japanese,
    this.senses,
    this.attribution
  })

  factory JishoResult.fromJson(Map<String, dynamic> json){
    return JishoResult(
      slug: json['slug'] as String,
      is_common: json['is_common'] as bool,
      tags: json['tags'] as List<String>,
      jlpt: json['jlpt'] as List<String>,
      japanese: json['japanese'] as List<JishoJapaneseWord>,
      senses: json['senses'] as List<JishoWordSense>,
      attribution: json['attribution'] as JishoAttribution
    );
  }
}

class JishoResultMeta {
  int status;

  JishoResultMeta({this.status});

  factory JishoResultMeta.fromJson(Map<String, dynamic> json){
    return JishoResultMeta(
      status: json['status'] as int
    );
  }
}

class JishoAPIResult {
  JishoResultMeta meta;
  List<JishoResult> data;

  JishoAPIResult({this.meta, this.data});

  factory JishoAPIResult.fromJson(Map<String, dynamic> json){
    return JishoAPIResult(
      meta: json['meta'] as JishoResultMeta,
      data: json['data'] as List<JishoResult>
    );
  }
}