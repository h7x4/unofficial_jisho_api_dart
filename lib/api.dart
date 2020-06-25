library unofficial_jisho_api;
import './src/objects.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './src/phraseSearch.dart';
import './src/kanjiSearch.dart';
import './src/exampleSearch.dart';
import './src/phraseScrape.dart';

/// Query the official Jisho API for a word or phrase
/// 
/// See https://jisho.org/forum/54fefc1f6e73340b1f160000-is-there-any-kind-of-search-api
/// for discussion about the official API.
Future<JishoAPIResult> searchForPhrase(String phrase) async {
  final uri = uriForPhraseSearch(phrase);
  return await http.get(uri).then((response) => JishoAPIResult.fromJson(jsonDecode(response.body)));
}

/// Scrape Jisho.org for information about a kanji character.
Future<KanjiResult> searchForKanji(String kanji) async {
  final uri = uriForKanjiSearch(kanji);
  return http.get(uri).then((response) => parseKanjiPageData(response.body, kanji));
}

/// Scrape Jisho.org for examples.
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