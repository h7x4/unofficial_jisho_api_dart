import './objects.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './phraseSearch.dart';
import './kanjiSearch.dart';
import './exampleSearch.dart';
import './phraseScrape.dart';


class JishoApi {

  /// Query the official Jisho API for a word or phrase
  /// 
  /// See [here]{@link https://jisho.org/forum/54fefc1f6e73340b1f160000-is-there-any-kind-of-search-api}
  /// for discussion about the official API.
  /// @param {string} phrase The search term to search for.
  /// @returns {Object} The response data from the official Jisho.org API. Its format is somewhat
  ///   complex and is not documented, so put on your trial-and-error hat.
  /// @async
  Future<List<JishoResult>> searchForPhrase(String phrase) async {
    final uri = uriForPhraseSearch(phrase);
    final jsonData = await http.get(uri).then((response) => JishoAPIResult.fromJson(jsonDecode(response.body)));
    return jsonData.data;
  }

  /// Scrape Jisho.org for information about a kanji character.
  /// @param {string} kanji The kanji to search for.
  /// @returns {KanjiResult} Information about the searched kanji.
  /// @async
  Future<KanjiResult> searchForKanji(String kanji) async {
    final uri = uriForKanjiSearch(kanji);
    return http.get(uri).then((response) => parseKanjiPageData(response.body, kanji));
  }

  /// Scrape Jisho.org for examples.
  /// @param {string} phrase The word or phrase to search for.
  /// @returns {ExampleResults}
  /// @async
  Future<ExampleResults> searchForExamples(String phrase) async {
    final uri = uriForExampleSearch(phrase);
    return http.get(uri).then((response) => parseExamplePageData(response.body, phrase));
  }

  /// Scrape the word page for a word/phrase.
  /// 
  /// This allows you to get some information that isn't provided by the official API, such as
  /// part-of-speech and JLPT level. However, the official API should be preferred
  /// if it has the information you need. This function scrapes https://jisho.org/word/XXX.
  /// In general, you'll want to include kanji in your search term, for example 掛かる
  /// instead of かかる (no results).
  /// @param {string} phrase The search term to search for.
  /// @returns {PhrasePageScrapeResult} Information about the searched query.
  /// @async
  Future<PhrasePageScrapeResult> scrapeForPhrase(String phrase) async {
    final uri = uriForPhraseScrape(phrase);
    try {
      final response = await http.get(uri);
      return parsePhrasePageData(response.body, phrase);
    } catch (err) {
      // if (response.statusCode == 404) {
      //   return PhrasePageScrapeResult(
      //     query: phrase,
      //     found: false,
      //   );
      // }

      throw err;
    }
  }
}