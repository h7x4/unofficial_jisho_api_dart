/* -------------------------------------------------------------------------- */
/*                       searchForKanji related classes                       */
/* -------------------------------------------------------------------------- */

/// An example of a word that contains the kanji in question.
class YomiExample {
  /// The original text of the example.
  String example;

  /// The reading of the example.
  String reading;

  /// The meaning of the example.
  String meaning;

  // ignore: public_member_api_docs
  YomiExample({
    required this.example,
    required this.reading,
    required this.meaning,
  });

  // ignore: public_member_api_docs
  Map<String, String> toJson() => {
        'example': example,
        'reading': reading,
        'meaning': meaning,
      };
}

/// Information regarding the radical of a kanji.
class Radical {
  /// The radical symbol.
  String symbol;

  /// The radical forms used in this kanji.
  List<String> forms;

  /// The meaning of the radical.
  String meaning;

  // ignore: public_member_api_docs
  Radical({
    required this.symbol,
    this.forms = const [],
    required this.meaning,
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'forms': forms,
        'meaning': meaning,
      };
}

/// The main wrapper containing data about the query and whether or not it was successful.
class KanjiResult {
  /// True if results were found.
  String query;

  /// The term that you searched for.
  bool found;

  /// The result data if search was successful.
  KanjiResultData? data;

  // ignore: public_member_api_docs
  KanjiResult({
    required this.query,
    required this.found,
    this.data,
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'found': found,
      'data': data,
    };
  }
}

/// The main kanji data class, collecting all the result information in one place.
class KanjiResultData {
  /// The school level that the kanji is taught in, if applicable.
  String? taughtIn;

  /// The lowest JLPT exam that this kanji is likely to appear in, if applicable.
  ///
  /// 'N5' or 'N4' or 'N3' or 'N2' or 'N1'.
  String? jlptLevel;

  /// A number representing this kanji's frequency rank in newspapers, if applicable.
  int? newspaperFrequencyRank;

  /// How many strokes this kanji is typically drawn in.
  int strokeCount;

  /// The meaning of the kanji.
  String meaning;

  /// This character's kunyomi.
  List<String> kunyomi;

  /// This character's onyomi.
  List<String> onyomi;

  /// Examples of this character's kunyomi being used.
  List<YomiExample> kunyomiExamples;

  /// Examples of this character's onyomi being used.
  List<YomiExample> onyomiExamples;

  /// Information about this character's radical, if applicable.
  Radical? radical;

  /// The parts used in this kanji.
  List<String> parts;

  /// The URL to a diagram showing how to draw this kanji step by step.
  String strokeOrderDiagramUri;

  /// The URL to an SVG describing how to draw this kanji.
  String strokeOrderSvgUri;

  ///  The URL to a gif showing the kanji being draw and its stroke order.
  String strokeOrderGifUri;

  /// The URI that these results were scraped from.
  String uri;

  // ignore: public_member_api_docs
  KanjiResultData({
    this.taughtIn,
    this.jlptLevel,
    this.newspaperFrequencyRank,
    required this.strokeCount,
    required this.meaning,
    this.kunyomi = const [],
    this.onyomi = const [],
    this.kunyomiExamples = const [],
    this.onyomiExamples = const [],
    this.radical,
    this.parts = const [],
    required this.strokeOrderDiagramUri,
    required this.strokeOrderSvgUri,
    required this.strokeOrderGifUri,
    required this.uri,
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() {
    return {
      'taughtIn': taughtIn,
      'jlptLevel': jlptLevel,
      'newspaperFrequencyRank': newspaperFrequencyRank,
      'strokeCount': strokeCount,
      'meaning': meaning,
      'kunyomi': kunyomi,
      'onyomi': onyomi,
      'onyomiExamples': onyomiExamples,
      'kunyomiExamples': kunyomiExamples,
      'radical': radical?.toJson(),
      'parts': parts,
      'strokeOrderDiagramUri': strokeOrderDiagramUri,
      'strokeOrderSvgUri': strokeOrderSvgUri,
      'strokeOrderGifUri': strokeOrderGifUri,
      'uri': uri,
    };
  }
}

/* -------------------------------------------------------------------------- */
/*                      searchForExamples related classes                     */
/* -------------------------------------------------------------------------- */

/// A word in an example sentence, consisting of either just kana, or kanji with furigana.
class ExampleSentencePiece {
  /// Furigana text shown on Jisho.org (above the unlifted text), if applicable.
  String? lifted;

  /// Baseline text shown on Jisho.org (below the lifted text / furigana).
  String unlifted;

  // ignore: public_member_api_docs
  ExampleSentencePiece({
    this.lifted,
    required this.unlifted,
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() {
    return {
      'lifted': lifted,
      'unlifted': unlifted,
    };
  }
}

/// All data making up one example sentence.
class ExampleResultData {
  /// The example sentence including kanji.
  String kanji;

  /// The example sentence without kanji (only kana). Sometimes this may include some Kanji, as furigana is not always available from Jisho.org.
  String kana;

  /// An English translation of the example.
  String english;

  /// The lifted/unlifted pairs that make up the sentence. Lifted text is furigana, unlifted is the text below the furigana.
  List<ExampleSentencePiece> pieces;

  // ignore: public_member_api_docs
  ExampleResultData({
    required this.english,
    required this.kanji,
    required this.kana,
    required this.pieces,
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() {
    return {
      'english': english,
      'kanji': kanji,
      'kana': kana,
      'pieces': pieces,
    };
  }
}

/// The main wrapper containing data about the query and whether or not it was successful.
class ExampleResults {
  /// The term that you searched for.
  String query;

  /// True if results were found.
  bool found;

  /// The URI that these results were scraped from.
  String uri;

  /// The examples that were found, if any.
  List<ExampleResultData> results;

  // ignore: public_member_api_docs
  ExampleResults({
    required this.query,
    required this.found,
    required this.results,
    required this.uri,
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'found': found,
      'results': results,
      'uri': uri,
    };
  }
}

/* -------------------------------------------------------------------------- */
/*                       scrapeForPhrase related classes                      */
/* -------------------------------------------------------------------------- */

/// An example sentence.
class PhraseScrapeSentence {
  /// The English meaning of the sentence.
  String english;

  /// The Japanese text of the sentence.
  String japanese;

  /// The lifted/unlifted pairs that make up the sentence. Lifted text is furigana, unlifted is the text below the furigana.
  List<ExampleSentencePiece> pieces;

  // ignore: public_member_api_docs
  PhraseScrapeSentence({
    required this.english,
    required this.japanese,
    required this.pieces,
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() =>
      {'english': english, 'japanese': japanese, 'pieces': pieces};
}

/// The data representing one "meaning" or "sense" of the word
class PhraseScrapeMeaning {
  /// The words that Jisho lists as "see also".
  List<String> seeAlsoTerms;

  /// Example sentences for this meaning.
  List<PhraseScrapeSentence> sentences;

  /// The definition of the meaning.
  String definition;

  /// Supplemental information.
  /// For example "usually written using kana alone".
  List<String> supplemental;

  /// An "abstract" definition.
  /// Often this is a Wikipedia definition.
  String? definitionAbstract;

  /// Tags associated with this meaning.
  List<String> tags;

  // ignore: public_member_api_docs
  PhraseScrapeMeaning({
    this.seeAlsoTerms = const [],
    required this.sentences,
    required this.definition,
    this.supplemental = const [],
    this.definitionAbstract,
    this.tags = const [],
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'seeAlsoTerms': seeAlsoTerms,
        'sentences': sentences,
        'definition': definition,
        'supplemental': supplemental,
        'definitionAbstract': definitionAbstract,
        'tags': tags,
      };
}

/// A pair of kanji and potential furigana.
class KanjiKanaPair {
  /// Kanji
  String kanji;

  /// Furigana, if applicable.
  String? kana;

  // ignore: public_member_api_docs
  KanjiKanaPair({
    required this.kanji,
    this.kana,
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'kanji': kanji,
        'kana': kana,
      };
}

/// The main wrapper containing data about the query and whether or not it was successful.
class PhrasePageScrapeResult {
  /// True if a result was found.
  bool found;

  /// The term that you searched for.
  String query;

  /// The result data if search was successful.
  PhrasePageScrapeResultData? data;

  // ignore: public_member_api_docs
  PhrasePageScrapeResult({
    required this.found,
    required this.query,
    this.data,
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'found': found,
        'query': query,
        'data': data,
      };
}

/// Pronounciation audio.
class AudioFile {
  /// The uri of the audio file.
  String uri;

  /// The mimetype of the audio.
  String mimetype;

  // ignore: public_member_api_docs
  AudioFile({
    required this.uri,
    required this.mimetype,
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'uri': uri,
        'mimetype': mimetype,
      };
}

/// The main scrape data class, collecting all the result information in one place.
class PhrasePageScrapeResultData {
  /// The URI that these results were scraped from.
  String uri;

  /// Other forms of the search term.
  List<String> tags;

  /// Information about the meanings associated with this search result.
  List<PhraseScrapeMeaning> meanings;

  /// Tags associated with this search result.
  List<KanjiKanaPair> otherForms;

  /// Pronounciation of the search result.
  List<AudioFile> audio;

  /// Notes associated with the search result.
  List<String> notes;

  // ignore: public_member_api_docs
  PhrasePageScrapeResultData({
    required this.uri,
    this.tags = const [],
    this.meanings = const [],
    this.otherForms = const [],
    this.audio = const [],
    this.notes = const [],
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'uri': uri,
        'tags': tags,
        'meanings': meanings,
        'otherForms': otherForms,
        'audio': audio,
        'notes': notes,
      };
}

/* -------------------------------------------------------------------------- */
/*                       searchForPhrase related classes                      */
/* -------------------------------------------------------------------------- */

/// Kanji/Furigana pair, or just kana as word.
///
/// Which field acts as kanji and/or kana might be unreliable, which is why both are nullable.
class JishoJapaneseWord {
  /// Usually kanji or kana.
  String? word;

  /// Usually furigana, if applicable.
  String? reading;

  // ignore: public_member_api_docs
  JishoJapaneseWord({
    this.word,
    this.reading,
  });

  // ignore: public_member_api_docs
  factory JishoJapaneseWord.fromJson(Map<String, dynamic> json) {
    return JishoJapaneseWord(
      word: json['word'] as String?,
      reading: json['reading'] as String?,
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'word': word,
        'reading': reading,
      };
}

/// Relevant links of the search result.
class JishoSenseLink {
  /// Description of the linked webpage.
  String text;

  /// Link to the webpage.
  String url;

  // ignore: public_member_api_docs
  JishoSenseLink({required this.text, required this.url});

  // ignore: public_member_api_docs
  factory JishoSenseLink.fromJson(Map<String, dynamic> json) {
    return JishoSenseLink(
      text: json['text'] as String,
      url: json['url'] as String,
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'text': text,
        'url': url,
      };
}

/// Origin of the word (from other languages).
class JishoWordSource {
  /// Origin language.
  String language;

  /// Origin word, if present.
  String? word;

  // ignore: public_member_api_docs
  JishoWordSource({
    required this.language,
    this.word,
  });

  // ignore: public_member_api_docs
  factory JishoWordSource.fromJson(Map<String, dynamic> json) {
    return JishoWordSource(
      language: json['language'] as String,
      word: json['word'] as String?,
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'language:': language,
        'word': word,
      };
}

/// One sense of the word.
class JishoWordSense {
  /// The meaning(s) of the word.
  List<String> englishDefinitions;

  /// Type of word (Noun, Verb, etc.).
  List<String> partsOfSpeech;

  /// Relevant links.
  List<JishoSenseLink> links;

  /// Relevant tags.
  List<String> tags;

  /// Relevant words (might include synonyms).
  List<String> seeAlso;

  /// Words with opposite meaning.
  List<String> antonyms;

  /// Origins of the word (from other languages).
  List<JishoWordSource> source;

  /// Additional info.
  List<String> info;

  /// Restrictions as to which variants of the japanese words are usable for this sense.
  List<String> restrictions;

  // ignore: public_member_api_docs
  JishoWordSense({
    required this.englishDefinitions,
    required this.partsOfSpeech,
    this.links = const [],
    this.tags = const [],
    this.seeAlso = const [],
    this.antonyms = const [],
    this.source = const [],
    this.info = const [],
    this.restrictions = const [],
  });

  // ignore: public_member_api_docs
  factory JishoWordSense.fromJson(Map<String, dynamic> json) {
    return JishoWordSense(
      englishDefinitions: (json['english_definitions'] as List)
          .map((result) => result as String)
          .toList(),
      partsOfSpeech: (json['parts_of_speech'] as List)
          .map((result) => result as String)
          .toList(),
      links: (json['links'] as List)
          .map((result) => JishoSenseLink.fromJson(result))
          .toList(),
      tags: (json['tags'] as List).map((result) => result as String).toList(),
      seeAlso:
          (json['see_also'] as List).map((result) => result as String).toList(),
      antonyms:
          (json['antonyms'] as List).map((result) => result as String).toList(),
      source: (json['source'] as List)
          .map((result) => JishoWordSource.fromJson(result))
          .toList(),
      info: (json['info'] as List).map((result) => result as String).toList(),
      restrictions: (json['restrictions'] as List)
          .map((result) => result as String)
          .toList(),
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'english_definitions': englishDefinitions,
        'parts_of_speech': partsOfSpeech,
        'links': links,
        'tags': tags,
        'see_also': seeAlso,
        'antonyms': antonyms,
        'source': source,
        'info': info,
        'restrictions': restrictions
      };
}

/// The original source(s) of the result.
class JishoAttribution {
  /// Whether jmdict was a source.
  bool jmdict;

  /// Whether jmnedict was a source.
  bool jmnedict;

  /// Additional sources, if applicable.
  String? dbpedia;

  // ignore: public_member_api_docs
  JishoAttribution({
    required this.jmdict,
    required this.jmnedict,
    this.dbpedia,
  });

  // ignore: public_member_api_docs
  factory JishoAttribution.fromJson(Map<String, dynamic> json) {
    return JishoAttribution(
      jmdict: (json['jmdict'].toString() == 'true'),
      jmnedict: (json['jmnedict'].toString() == 'true'),
      dbpedia: (json['dbpedia'].toString() != 'false')
          ? json['dbpedia'].toString()
          : null,
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'jmdict': jmdict,
        'jmnedict': jmnedict,
        'dbpedia': dbpedia,
      };
}

/// The main API data class, collecting all information of one result in one place.
class JishoResult {
  /// The main version of the word
  ///
  /// This value might sometimes appear as some kind of hash or encoded version of the word.
  /// Whenever it happens, the word usually originates taken from dbpedia
  String slug;

  /// Whether the word is common.
  ///
  /// Dbpedia sometimes omit this value.
  bool? isCommon;

  /// Related tags.
  List<String> tags;

  /// Relevant jlpt levels.
  List<String> jlpt;

  /// Japanese versions of the word.
  List<JishoJapaneseWord> japanese;

  /// Translations of the word.
  List<JishoWordSense> senses;

  /// Sources.
  JishoAttribution attribution;

  // ignore: public_member_api_docs
  JishoResult({
    required this.slug,
    required this.isCommon,
    this.tags = const [],
    this.jlpt = const [],
    required this.japanese,
    required this.senses,
    required this.attribution,
  });

  // ignore: public_member_api_docs
  factory JishoResult.fromJson(Map<String, dynamic> json) {
    return JishoResult(
      slug: json['slug'] as String,
      isCommon: json['is_common'] as bool?,
      tags: (json['tags'] as List).map((result) => result as String).toList(),
      jlpt: (json['jlpt'] as List).map((result) => result as String).toList(),
      japanese: (json['japanese'] as List)
          .map((result) => JishoJapaneseWord.fromJson(result))
          .toList(),
      senses: (json['senses'] as List)
          .map((result) => JishoWordSense.fromJson(result))
          .toList(),
      attribution: JishoAttribution.fromJson(json['attribution']),
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'slug': slug,
        'is_common': isCommon,
        'tags': tags,
        'jlpt': jlpt,
        'japanese': japanese,
        'senses': senses,
        'attribution': attribution,
      };
}

/// Metadata with result status.
class JishoResultMeta {
  /// HTTP status code.
  int status;

  // ignore: public_member_api_docs
  JishoResultMeta({required this.status});

  // ignore: public_member_api_docs
  factory JishoResultMeta.fromJson(Map<String, dynamic> json) {
    return JishoResultMeta(status: json['status'] as int);
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {'status': status};
}

/// The main API result wrapper containing whether it was successful, and potential results.
class JishoAPIResult {
  /// Metadata with result status.
  JishoResultMeta meta;

  /// Results.
  List<JishoResult>? data;

  // ignore: public_member_api_docs
  JishoAPIResult({
    required this.meta,
    this.data,
  });

  // ignore: public_member_api_docs
  factory JishoAPIResult.fromJson(Map<String, dynamic> json) {
    return JishoAPIResult(
        meta: JishoResultMeta.fromJson(json['meta']),
        data: (json['data'] as List)
            .map((result) => JishoResult.fromJson(result))
            .toList());
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {'meta': meta.toJson(), 'data': data};
}
