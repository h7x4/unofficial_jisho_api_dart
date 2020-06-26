/// This library provides parsing functions for html pages from Jisho.org,
/// and the associated URI-producing functions.
///
/// This might be useful for using a CORS proxy, or if you have your own system/library
/// for providing HTML.
library unofficial_jisho_parser;

export './src/exampleSearch.dart'
    show uriForExampleSearch, parseExamplePageData;
export './src/kanjiSearch.dart' show uriForKanjiSearch, parseKanjiPageData;
export './src/phraseScrape.dart' show uriForPhraseScrape, parsePhrasePageData;
export './src/phraseSearch.dart';
