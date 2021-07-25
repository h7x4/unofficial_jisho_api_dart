/// This library provides parsing functions for html pages from Jisho.org,
/// and the associated URI-producing functions.
///
/// This might be useful for using a CORS proxy, or if you have your own system/library
/// for providing HTML.
library unofficial_jisho_parser;

export './src/objects.dart';
export 'src/example_search.dart' show uriForExampleSearch, parseExamplePageData;
export 'src/kanji_search.dart' show uriForKanjiSearch, parseKanjiPageData;
export 'src/phrase_scrape.dart' show uriForPhraseScrape, parsePhrasePageData;
export 'src/phrase_search.dart';
