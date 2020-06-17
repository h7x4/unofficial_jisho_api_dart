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




