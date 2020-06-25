/// This library provides parsing functions for html pages from Jisho.org,
/// and the associated URI-producing functions.
/// 
/// This might be useful for using a CORS proxy, or if you have your own system/library
/// for providing HTML.
library unofficial_jisho_parser;
import './src/objects.dart';

import './src/phraseSearch.dart' as phrase_search;
import './src/kanjiSearch.dart' as kanji_search;
import './src/exampleSearch.dart' as example_search;
import './src/phraseScrape.dart' as phrase_scrape;

/// Provides the URI for a phrase search
String uriForPhraseSearch(String phrase) => phrase_search.uriForPhraseSearch(phrase);

/// Provides the URI for a kanji search
String uriForKanjiSearch(String kanji) => kanji_search.uriForKanjiSearch(kanji);

/// Provides the URI for an example search
String uriForExampleSearch(String phrase) => example_search.uriForExampleSearch(phrase);

/// Provides the URI for a phrase scrape
String uriForPhraseScrape(String searchTerm) => phrase_scrape.uriForPhraseScrape(searchTerm);

/// Parses a jisho kanji search page to an object
KanjiResult parseKanjiPageHtml(String pageHtml, String kanji) => kanji_search.parseKanjiPageData(pageHtml, kanji);

/// Parses a jisho example sentence search page to an object
ExampleResults parseExamplePageHtml(String pageHtml, String phrase) => example_search.parseExamplePageData(pageHtml, phrase);

/// Parses a jisho word search page to an object
PhrasePageScrapeResult parsePhraseScrapeHtml(String pageHtml, String query) => phrase_scrape.parsePhrasePageData(pageHtml, query);