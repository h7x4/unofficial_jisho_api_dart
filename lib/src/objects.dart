import 'package:equatable/equatable.dart';

import 'example_search.dart';
import 'kanji_search.dart';

/* -------------------------------------------------------------------------- */
/*                       searchForKanji related classes                       */
/* -------------------------------------------------------------------------- */

/// An example of a word that contains the kanji in question.
class YomiExample extends Equatable {
  /// The original text of the example.
  final String example;

  /// The reading of the example.
  final String reading;

  /// The meaning of the example.
  final String meaning;

  // ignore: public_member_api_docs
  const YomiExample({
    required this.example,
    required this.reading,
    required this.meaning,
  });

  // ignore: public_member_api_docs
  factory YomiExample.fromJson(Map<String, dynamic> json) {
    return YomiExample(
      example: json['example'] as String,
      reading: json['reading'] as String,
      meaning: json['meaning'] as String,
    );
  }

  // ignore: public_member_api_docs
  Map<String, String> toJson() => {
        'example': example,
        'reading': reading,
        'meaning': meaning,
      };

  @override
  // ignore: public_member_api_docs
  List<Object> get props => [example, reading, meaning];
}

/// Information regarding the radical of a kanji.
class Radical extends Equatable {
  /// The radical symbol.
  final String symbol;

  /// The radical forms used in this kanji.
  final List<String> forms;

  /// The meaning of the radical.
  final String meaning;

  // ignore: public_member_api_docs
  const Radical({
    required this.symbol,
    this.forms = const [],
    required this.meaning,
  });

  // ignore: public_member_api_docs
  factory Radical.fromJson(Map<String, dynamic> json) {
    return Radical(
      symbol: json['symbol'] as String,
      forms: (json['forms'] as List).map((e) => e as String).toList(),
      meaning: json['meaning'] as String,
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'forms': forms,
        'meaning': meaning,
      };

  @override
  // ignore: public_member_api_docs
  List<Object> get props => [symbol, forms, meaning];
}

/// The main wrapper containing data about the query and whether or not it was successful.
class KanjiResult extends Equatable {
  /// True if results were found.
  final String query;

  /// The term that you searched for.
  bool get found => data != null;

  /// The result data if search was successful.
  final KanjiResultData? data;

  // ignore: public_member_api_docs
  const KanjiResult({
    required this.query,
    this.data,
  });

  // ignore: public_member_api_docs
  factory KanjiResult.fromJson(Map<String, dynamic> json) {
    return KanjiResult(
      query: json['query'] as String,
      data:
          json['data'] != null ? KanjiResultData.fromJson(json['data']) : null,
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'query': query,
        'found': found,
        'data': data,
      };

  @override
  // ignore: public_member_api_docs
  List<Object?> get props => [query, data];
}

/// The main kanji data class, collecting all the result information in one place.
class KanjiResultData extends Equatable {
  /// The kanji symbol
  final String kanji;

  /// The school level that the kanji is taught in, if applicable.
  final String? taughtIn;

  /// The lowest JLPT exam that this kanji is likely to appear in, if applicable.
  ///
  /// 'N5' or 'N4' or 'N3' or 'N2' or 'N1'.
  final String? jlptLevel;

  /// A number representing this kanji's frequency rank in newspapers, if applicable.
  final int? newspaperFrequencyRank;

  /// How many strokes this kanji is typically drawn in.
  final int strokeCount;

  /// The meaning of the kanji.
  final String meaning;

  /// This character's kunyomi.
  final List<String> kunyomi;

  /// This character's onyomi.
  final List<String> onyomi;

  /// Examples of this character's kunyomi being used.
  final List<YomiExample> kunyomiExamples;

  /// Examples of this character's onyomi being used.
  final List<YomiExample> onyomiExamples;

  /// Information about this character's radical, if applicable.
  final Radical? radical;

  /// The parts used in this kanji.
  final List<String> parts;

  /// The URL to a diagram showing how to draw this kanji step by step.
  String get strokeOrderDiagramUri => getUriForStrokeOrderDiagram(kanji);

  /// The URL to an SVG describing how to draw this kanji.
  final String strokeOrderSvgUri;

  ///  The URL to a gif showing the kanji being draw and its stroke order.
  String get strokeOrderGifUri => getGifUri(kanji);

  /// The URI that these results were scraped from.
  String get uri => uriForKanjiSearch(kanji).toString();

  // ignore: public_member_api_docs
  const KanjiResultData({
    required this.kanji,
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
    required this.strokeOrderSvgUri,
  });

  // ignore: public_member_api_docs
  factory KanjiResultData.fromJson(Map<String, dynamic> json) {
    return KanjiResultData(
      kanji: json['kanji'] as String,
      taughtIn: json['taughtIn'] as String?,
      jlptLevel: json['jlptLevel'] as String?,
      newspaperFrequencyRank: json['newspaperFrequencyRank'] as int?,
      strokeCount: json['strokeCount'] as int,
      meaning: json['meaning'] as String,
      kunyomi: (json['kunyomi'] as List).map((e) => e as String).toList(),
      onyomi: (json['onyomi'] as List).map((e) => e as String).toList(),
      kunyomiExamples: (json['kunyomiExamples'] as List)
          .map((e) => YomiExample.fromJson(e))
          .toList(),
      onyomiExamples: (json['onyomiExamples'] as List)
          .map((e) => YomiExample.fromJson(e))
          .toList(),
      radical:
          json['radical'] != null ? Radical.fromJson(json['radical']) : null,
      parts: (json['parts'] as List).map((e) => e as String).toList(),
      strokeOrderSvgUri: json['strokeOrderSvgUri'] as String,
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'kanji': kanji,
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

  @override
  // ignore: public_member_api_docs
  List<Object?> get props => [
        taughtIn,
        jlptLevel,
        newspaperFrequencyRank,
        strokeCount,
        meaning,
        kunyomi,
        onyomi,
        kunyomiExamples,
        onyomiExamples,
        radical,
        parts,
        strokeOrderSvgUri,
      ];
}

/* -------------------------------------------------------------------------- */
/*                      searchForExamples related classes                     */
/* -------------------------------------------------------------------------- */

/// A word in an example sentence, consisting of either just kana, or kanji with furigana.
class ExampleSentencePiece extends Equatable {
  /// Furigana text shown on Jisho.org (above the unlifted text), if applicable.
  final String? lifted;

  /// Baseline text shown on Jisho.org (below the lifted text / furigana).
  final String unlifted;

  // ignore: public_member_api_docs
  const ExampleSentencePiece({
    this.lifted,
    required this.unlifted,
  });

  // ignore: public_member_api_docs
  factory ExampleSentencePiece.fromJson(Map<String, dynamic> json) {
    return ExampleSentencePiece(
      lifted: json['lifted'] as String?,
      unlifted: json['unlifted'] as String,
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() {
    return {
      'lifted': lifted,
      'unlifted': unlifted,
    };
  }

  List<Object?> get props => [lifted, unlifted];
}

/// All data making up one example sentence.
class ExampleResultData extends Equatable {
  /// The example sentence including kanji.
  final String kanji;

  /// The example sentence without kanji (only kana). Sometimes this may include some Kanji, as furigana is not always available from Jisho.org.
  final String kana;

  /// An English translation of the example.
  final String english;

  /// The lifted/unlifted pairs that make up the sentence. Lifted text is furigana, unlifted is the text below the furigana.
  final List<ExampleSentencePiece> pieces;

  // ignore: public_member_api_docs
  const ExampleResultData({
    required this.english,
    required this.kanji,
    required this.kana,
    required this.pieces,
  });

  // ignore: public_member_api_docs
  factory ExampleResultData.fromJson(Map<String, dynamic> json) {
    return ExampleResultData(
      english: json['english'] as String,
      kanji: json['kanji'] as String,
      kana: json['kana'] as String,
      pieces: (json['pieces'] as List)
          .map((e) => ExampleSentencePiece.fromJson(e))
          .toList(),
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() {
    return {
      'english': english,
      'kanji': kanji,
      'kana': kana,
      'pieces': pieces,
    };
  }

  List<Object> get props => [english, kanji, kana, pieces];
}

/// The main wrapper containing data about the query and whether or not it was successful.
class ExampleResults extends Equatable {
  /// The term that you searched for.
  final String query;

  /// True if results were found.
  bool get found => results.isNotEmpty;

  /// The URI that these results were scraped from.
  String get uri => uriForExampleSearch(query).toString();

  /// The examples that were found, if any.
  final List<ExampleResultData> results;

  // ignore: public_member_api_docs
  const ExampleResults({
    required this.query,
    required this.results,
  });

  // ignore: public_member_api_docs
  factory ExampleResults.fromJson(Map<String, dynamic> json) {
    return ExampleResults(
      query: json['query'] as String,
      results: (json['results'] as List)
          .map((e) => ExampleResultData.fromJson(e))
          .toList(),
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'found': found,
      'results': results,
      'uri': uri,
    };
  }

  List<Object> get props => [query, results];
}

/* -------------------------------------------------------------------------- */
/*                       scrapeForPhrase related classes                      */
/* -------------------------------------------------------------------------- */

/// An example sentence.
class PhraseScrapeSentence extends Equatable {
  /// The English meaning of the sentence.
  final String english;

  /// The Japanese text of the sentence.
  final String japanese;

  /// The lifted/unlifted pairs that make up the sentence. Lifted text is furigana, unlifted is the text below the furigana.
  final List<ExampleSentencePiece> pieces;

  // ignore: public_member_api_docs
  const PhraseScrapeSentence({
    required this.english,
    required this.japanese,
    required this.pieces,
  });

  // ignore: public_member_api_docs
  factory PhraseScrapeSentence.fromJson(Map<String, dynamic> json) {
    return PhraseScrapeSentence(
      english: json['english'] as String,
      japanese: json['japanese'] as String,
      pieces: (json['pieces'] as List)
          .map((e) => ExampleSentencePiece.fromJson(e))
          .toList(),
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'english': english,
        'japanese': japanese,
        'pieces': pieces,
      };

  @override
  // ignore: public_member_api_docs
  List<Object> get props => [english, japanese, pieces];
}

/// The data representing one "meaning" or "sense" of the word
class PhraseScrapeMeaning extends Equatable {
  /// The words that Jisho lists as "see also".
  final List<String> seeAlsoTerms;

  /// Example sentences for this meaning.
  final List<PhraseScrapeSentence> sentences;

  /// The definition of the meaning.
  final String definition;

  /// Supplemental information.
  /// For example "usually written using kana alone".
  final List<String> supplemental;

  /// An "abstract" definition.
  /// Often this is a Wikipedia definition.
  final String? definitionAbstract;

  /// Tags associated with this meaning.
  final List<String> tags;

  // ignore: public_member_api_docs
  const PhraseScrapeMeaning({
    this.seeAlsoTerms = const [],
    required this.sentences,
    required this.definition,
    this.supplemental = const [],
    this.definitionAbstract,
    this.tags = const [],
  });

  // ignore: public_member_api_docs
  factory PhraseScrapeMeaning.fromJson(Map<String, dynamic> json) {
    return PhraseScrapeMeaning(
      seeAlsoTerms:
          (json['seeAlsoTerms'] as List).map((e) => e as String).toList(),
      sentences: (json['sentences'] as List)
          .map((e) => PhraseScrapeSentence.fromJson(e))
          .toList(),
      definition: json['definition'] as String,
      supplemental:
          (json['supplemental'] as List).map((e) => e as String).toList(),
      definitionAbstract: json['definitionAbstract'] as String?,
      tags: (json['tags'] as List).map((e) => e as String).toList(),
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'seeAlsoTerms': seeAlsoTerms,
        'sentences': sentences,
        'definition': definition,
        'supplemental': supplemental,
        'definitionAbstract': definitionAbstract,
        'tags': tags,
      };

  @override
  // ignore: public_member_api_docs
  List<Object?> get props => [
        seeAlsoTerms,
        sentences,
        definition,
        supplemental,
        definitionAbstract,
        tags
      ];
}

/// A pair of kanji and potential furigana.
class KanjiKanaPair extends Equatable {
  /// Kanji
  final String kanji;

  /// Furigana, if applicable.
  final String? kana;

  // ignore: public_member_api_docs
  const KanjiKanaPair({
    required this.kanji,
    this.kana,
  });

  // ignore: public_member_api_docs
  factory KanjiKanaPair.fromJson(Map<String, dynamic> json) {
    return KanjiKanaPair(
      kanji: json['kanji'] as String,
      kana: json['kana'] as String?,
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'kanji': kanji,
        'kana': kana,
      };

  @override
  // ignore: public_member_api_docs
  List<Object?> get props => [kanji, kana];
}

/// The main wrapper containing data about the query and whether or not it was successful.
class PhrasePageScrapeResult extends Equatable {
  /// True if a result was found.
  bool get found => data != null;

  /// The term that you searched for.
  final String query;

  /// The result data if search was successful.
  final PhrasePageScrapeResultData? data;

  // ignore: public_member_api_docs
  const PhrasePageScrapeResult({
    required this.query,
    this.data,
  });

  // ignore: public_member_api_docs
  factory PhrasePageScrapeResult.fromJson(Map<String, dynamic> json) {
    return PhrasePageScrapeResult(
      query: json['query'] as String,
      data: json['data'] != null
          ? PhrasePageScrapeResultData.fromJson(json['data'])
          : null,
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'found': found,
        'query': query,
        'data': data,
      };

  @override
  // ignore: public_member_api_docs
  List<Object?> get props => [query, data];
}

/// Pronounciation audio.
class AudioFile extends Equatable {
  /// The uri of the audio file.
  final String uri;

  /// The mimetype of the audio.
  final String mimetype;

  // ignore: public_member_api_docs
  const AudioFile({
    required this.uri,
    required this.mimetype,
  });

  // ignore: public_member_api_docs
  factory AudioFile.fromJson(Map<String, dynamic> json) {
    return AudioFile(
      uri: json['uri'] as String,
      mimetype: json['mimetype'] as String,
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'uri': uri,
        'mimetype': mimetype,
      };

  @override
  // ignore: public_member_api_docs
  List<Object> get props => [uri, mimetype];
}

/// The main scrape data class, collecting all the result information in one place.
class PhrasePageScrapeResultData extends Equatable {
  /// The URI that these results were scraped from.
  final String uri;

  /// Other forms of the search term.
  final List<String> tags;

  /// Information about the meanings associated with this search result.
  final List<PhraseScrapeMeaning> meanings;

  /// Tags associated with this search result.
  final List<KanjiKanaPair> otherForms;

  /// Pronounciation of the search result.
  final List<AudioFile> audio;

  /// Notes associated with the search result.
  final List<String> notes;

  // ignore: public_member_api_docs
  const PhrasePageScrapeResultData({
    required this.uri,
    this.tags = const [],
    this.meanings = const [],
    this.otherForms = const [],
    this.audio = const [],
    this.notes = const [],
  });

  // ignore: public_member_api_docs
  factory PhrasePageScrapeResultData.fromJson(Map<String, dynamic> json) {
    return PhrasePageScrapeResultData(
      uri: json['uri'] as String,
      tags: (json['tags'] as List).map((e) => e as String).toList(),
      meanings: (json['meanings'] as List)
          .map((e) => PhraseScrapeMeaning.fromJson(e))
          .toList(),
      otherForms: (json['otherForms'] as List)
          .map((e) => KanjiKanaPair.fromJson(e))
          .toList(),
      audio: (json['audio'] as List).map((e) => AudioFile.fromJson(e)).toList(),
      notes: (json['notes'] as List).map((e) => e as String).toList(),
    );
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'uri': uri,
        'tags': tags,
        'meanings': meanings,
        'otherForms': otherForms,
        'audio': audio,
        'notes': notes,
      };

  @override
  // ignore: public_member_api_docs
  List<Object> get props => [uri, tags, meanings, otherForms, audio, notes];
}

/* -------------------------------------------------------------------------- */
/*                       searchForPhrase related classes                      */
/* -------------------------------------------------------------------------- */

/// Kanji/Furigana pair, or just kana as word.
///
/// Which field acts as kanji and/or kana might be unreliable, which is why both are nullable.
class JishoJapaneseWord extends Equatable {
  /// Usually kanji or kana.
  final String? word;

  /// Usually furigana, if applicable.
  final String? reading;

  // ignore: public_member_api_docs
  const JishoJapaneseWord({
    this.word,
    this.reading,
  }) : assert(word != null || reading != null);

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

  @override
  // ignore: public_member_api_docs
  List<Object?> get props => [word, reading];
}

/// Relevant links of the search result.
class JishoSenseLink extends Equatable {
  /// Description of the linked webpage.
  final String text;

  /// Link to the webpage.
  final String url;

  // ignore: public_member_api_docs
  const JishoSenseLink({required this.text, required this.url});

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

  @override
  // ignore: public_member_api_docs
  List<Object> get props => [text, url];
}

/// Origin of the word (from other languages).
class JishoWordSource extends Equatable {
  /// Origin language.
  final String language;

  /// Origin word, if present.
  final String? word;

  // ignore: public_member_api_docs
  const JishoWordSource({
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

  @override
  // ignore: public_member_api_docs
  List<Object?> get props => [language, word];
}

/// One sense of the word.
class JishoWordSense extends Equatable {
  /// The meaning(s) of the word.
  final List<String> englishDefinitions;

  /// Type of word (Noun, Verb, etc.).
  final List<String> partsOfSpeech;

  /// Relevant links.
  final List<JishoSenseLink> links;

  /// Relevant tags.
  final List<String> tags;

  /// Relevant words (might include synonyms).
  final List<String> seeAlso;

  /// Words with opposite meaning.
  final List<String> antonyms;

  /// Origins of the word (from other languages).
  final List<JishoWordSource> source;

  /// Additional info.
  final List<String> info;

  /// Restrictions as to which variants of the japanese words are usable for this sense.
  final List<String> restrictions;

  // ignore: public_member_api_docs
  const JishoWordSense({
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
          .map((e) => e as String)
          .toList(),
      partsOfSpeech:
          (json['parts_of_speech'] as List).map((e) => e as String).toList(),
      links: (json['links'] as List)
          .map((e) => JishoSenseLink.fromJson(e))
          .toList(),
      tags: (json['tags'] as List).map((e) => e as String).toList(),
      seeAlso: (json['see_also'] as List).map((e) => e as String).toList(),
      antonyms: (json['antonyms'] as List).map((e) => e as String).toList(),
      source: (json['source'] as List)
          .map((e) => JishoWordSource.fromJson(e))
          .toList(),
      info: (json['info'] as List).map((e) => e as String).toList(),
      restrictions:
          (json['restrictions'] as List).map((e) => e as String).toList(),
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

  @override
  // ignore: public_member_api_docs
  List<Object> get props => [
        englishDefinitions,
        partsOfSpeech,
        links,
        tags,
        seeAlso,
        antonyms,
        source,
        info,
        restrictions,
      ];
}

/// The original source(s) of the result.
class JishoAttribution extends Equatable {
  /// Whether jmdict was a source.
  final bool jmdict;

  /// Whether jmnedict was a source.
  final bool jmnedict;

  /// Additional sources, if applicable.
  final String? dbpedia;

  // ignore: public_member_api_docs
  const JishoAttribution({
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

  @override
  // ignore: public_member_api_docs
  List<Object?> get props => [jmdict, jmnedict, dbpedia];
}

/// The main API data class, collecting all information of one result in one place.
class JishoResult extends Equatable {
  /// The main version of the word
  ///
  /// This value might sometimes appear as some kind of hash or encoded version of the word.
  /// Whenever it happens, the word usually originates taken from dbpedia
  final String slug;

  /// Whether the word is common.
  ///
  /// Dbpedia sometimes omit this value.
  final bool? isCommon;

  /// Related tags.
  final List<String> tags;

  /// Relevant jlpt levels.
  final List<String> jlpt;

  /// Japanese versions of the word.
  final List<JishoJapaneseWord> japanese;

  /// Translations of the word.
  final List<JishoWordSense> senses;

  /// Sources.
  final JishoAttribution attribution;

  // ignore: public_member_api_docs
  const JishoResult({
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
      tags: (json['tags'] as List).map((e) => e as String).toList(),
      jlpt: (json['jlpt'] as List).map((e) => e as String).toList(),
      japanese: (json['japanese'] as List)
          .map((e) => JishoJapaneseWord.fromJson(e))
          .toList(),
      senses: (json['senses'] as List)
          .map((e) => JishoWordSense.fromJson(e))
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

  @override
  // ignore: public_member_api_docs
  List<Object?> get props => [
        slug,
        isCommon,
        tags,
        jlpt,
        japanese,
        senses,
        attribution,
      ];
}

/// Metadata with result status.
class JishoResultMeta extends Equatable {
  /// HTTP status code.
  final int status;

  // ignore: public_member_api_docs
  const JishoResultMeta({required this.status});

  // ignore: public_member_api_docs
  factory JishoResultMeta.fromJson(Map<String, dynamic> json) {
    return JishoResultMeta(status: json['status'] as int);
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {'status': status};

  @override
  // ignore: public_member_api_docs
  List<Object> get props => [status];
}

/// The main API result wrapper containing whether it was successful, and potential results.
class JishoAPIResult extends Equatable {
  /// Metadata with result status.
  final JishoResultMeta meta;

  /// Results.
  final List<JishoResult>? data;

  // ignore: public_member_api_docs
  const JishoAPIResult({
    required this.meta,
    this.data,
  });

  // ignore: public_member_api_docs
  factory JishoAPIResult.fromJson(Map<String, dynamic> json) {
    return JishoAPIResult(
        meta: JishoResultMeta.fromJson(json['meta']),
        data: (json['data'] as List)
            .map((e) => JishoResult.fromJson(e))
            .toList());
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {'meta': meta.toJson(), 'data': data};

  @override
  // ignore: public_member_api_docs
  List<Object?> get props => [meta, data];
}
