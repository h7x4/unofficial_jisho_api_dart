class PhraseScrapeSentence {
  String english;
  String japanese;
  List<ExampleSentencePiece> pieces;

  PhraseScrapeSentence ({String english, String japanese, List<ExampleSentencePiece> pieces}){
    this.english = english;
    this.japanese = japanese;
    this.pieces = pieces;
  }
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
}

class PhrasePageScrapeResult {
  bool found;
  String query;
  String uri;
  List<KanjiKanaPair> otherForms;
  List<PhraseScrapeMeaning> meanings;
  List<String> tags;
  List<String> notes;

  PhrasePageScrapeResult({
    bool found,
    String query,
    String uri,
    List<KanjiKanaPair> otherForms,
    List<PhraseScrapeMeaning> meanings,
    List<String> tags,
    List<String> notes,
  }){
    this.found = found;
    this.query = query;
    this.uri = uri;
    this.otherForms = otherForms;
    this.meanings = meanings;
    this.tags = tags;
    this.notes = notes;
  }
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
      if (symbol != null) 'symbol': symbol,
      if (forms != null) 'forms': forms,
      if (meaning != null) 'meaning': meaning
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

    if (found == false) return {
      'query': query,
      'found': found
    };

    return {
      'query': query,
      'found': found,
      'taughtIn': taughtIn,
      'jlptLevel': jlptLevel,
      'newspaperFrequencyRank': newspaperFrequencyRank.toString(),
      'strokeCount': strokeCount,
      'meaning': meaning,
      'kunyomi': kunyomi,
      'onyomi': onyomi,
      'onyomiExamples': onyomiExamples.map((onyomiExample) => onyomiExample.toJson()).toList(),
      'kunyomiExamples': kunyomiExamples.map((kunyomiExample) => kunyomiExample.toJson()).toList(),
      'radical': radical.toJson(),
      'parts': parts,
      'strokeOrderDiagramUri': strokeOrderDiagramUri,
      'strokeOrderSvgUri': strokeOrderSvgUri,
      'strokeOrderGifUri': strokeOrderGifUri,
      'uri': uri
    };
  }
}

class ExampleSentencePiece {
  String unlifted;
  String lifted;

  ExampleSentencePiece({String unlifted, String lifted}){
    this.unlifted = unlifted;
    this.lifted = lifted;
  }
}

class ExampleResultData {
  String kanji;
  String kana;
  String english;
  List<ExampleSentencePiece> pieces;

  ExampleResultData({String kanji, String kana, String english, List<ExampleSentencePiece> pieces}){
    this.kanji = kanji;
    this.kana = kana;
    this.english = english;
    this.pieces = pieces;
  }
}

class ExampleResults {
  String query;
  bool found;
  String uri;
  List<ExampleResultData> results;
  String phrase;

  ExampleResults({String query, bool found, String uri, List<ExampleResultData> results, String phrase}){
    this.query = query;
    this.found = found;
    this.uri = uri;
    this.results = results;
    this.phrase = phrase;
  }
}




