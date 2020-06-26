# Examples

Examples for use of the api functions, and for parsing.

These examples are also available on the main readme.

## API searching/scraping

These are usage examples of the api library, providing results directly.

### Word/phrase search (provided by official Jisho API)

This returns the same results as the official [Jisho.org](https://jisho.org/) API. See the discussion of that [here](https://jisho.org/forum/54fefc1f6e73340b1f160000-is-there-any-kind-of-search-api).

```dart
import 'package:unofficial_jisho_api/api.dart' as jisho;

void main() async {
  jisho.searchForPhrase('日').then((result) {
    ...
    ...
    ...
  });
}
```

### Kanji search

```dart
import 'dart:convert' show jsonEncode;
import 'package:unofficial_jisho_api/api.dart' as jisho;

void main() async {
  await jisho.searchForKanji('語').then((result) {
    print('Found: ${result.found}');
    print('Taught in: ${result.taughtIn}');
    print('JLPT level: ${result.jlptLevel}');
    print('Newspaper frequency rank: ${result.newspaperFrequencyRank}');
    print('Stroke count: ${result.strokeCount}');
    print('Meaning: ${result.meaning}');
    print('Kunyomi: ${jsonEncode(result.kunyomi)}');
    print('Kunyomi example: ${jsonEncode(result.kunyomiExamples[0])}');
    print('Onyomi: ${jsonEncode(result.onyomi)}');
    print('Onyomi example: ${jsonEncode(result.onyomiExamples[0])}');
    print('Radical: ${jsonEncode(result.radical)}');
    print('Parts: ${jsonEncode(result.parts)}');
    print('Stroke order diagram: ${result.strokeOrderDiagramUri}');
    print('Stroke order SVG: ${result.strokeOrderSvgUri}');
    print('Stroke order GIF: ${result.strokeOrderGifUri}');
    print('Jisho Uri: ${result.uri}');
  });
}
```

### Example search

```dart
import 'dart:convert' show jsonEncode;
import 'package:unofficial_jisho_api/api.dart' as jisho;

void main() async {
  await jisho.searchForExamples('日').then((result) {
    print('Jisho Uri: ${result.uri}');
    print('');

    for (var i = 0; i < 3; i++) {
      var example = result.results[i];
      print(example.kanji);
      print(example.kana);
      print(example.english);
      print(jsonEncode(example.pieces));
      print('');
    }
  });
}
```

### Word/phrase scraping

This scrapes the word/phrase page on Jisho.org. This can get you some data that the official API doesn't have, such as JLPT level and part-of-speech. The official API (`searchForPhrase`) should be preferred if it has the data you need.

```dart
import 'dart:convert';
import 'package:unofficial_jisho_api/api.dart' as jisho;
final JsonEncoder encoder = JsonEncoder.withIndent('  ');

void main() async {
  await jisho.scrapeForPhrase('谷').then((data) {
    print(encoder.convert(data));
  });
}
```

## Parsing

You can provide the HTML responses from Jisho yourself. This can be useful if you need to use a CORS proxy or something. You can do whatever you need to do to get the HTML and then provide it to this module's parsing functions. For example:

### Parse kanji page HTML

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unofficial_jisho_api/parser.dart' as jisho_parser;

final JsonEncoder encoder = JsonEncoder.withIndent('  ');

const String searchKanji = '車';
final String searchURI = jisho_parser.uriForKanjiSearch(searchKanji);

void main() async {
  await http.get(searchURI).then((result) {
    final parsedResult = jisho_parser.parseKanjiPageData(result.body, searchKanji);
    print('JLPT level: ${parsedResult.jlptLevel}');
    print('Stroke count: ${parsedResult.strokeCount}');
    print('Meaning: ${parsedResult.meaning}');
  });
}
```

### Parse example page HTML

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unofficial_jisho_api/parser.dart' as jisho_parser;

final JsonEncoder encoder = JsonEncoder.withIndent('  ');

const String searchExample = '保護者';
final String searchURI = jisho_parser.uriForExampleSearch(searchExample);

void main() async {
  await http.get(searchURI).then((result) {
    final parsedResult = jisho_parser.parseExamplePageData(result.body, searchExample);
    print('English: ${parsedResult.results[0].english}');
    print('Kanji ${parsedResult.results[0].kanji}');
    print('Kana: ${parsedResult.results[0].kana}');
  });
}
```

### Parse phrase page HTML

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unofficial_jisho_api/parser.dart' as jisho_parser;

final JsonEncoder encoder = JsonEncoder.withIndent('  ');

const String searchExample = '保護者';
final String searchURI = jisho_parser.uriForPhraseScrape(searchExample);

void main() async {

  await http.get(searchURI).then((result) {
    final parsedResult = jisho_parser.parsePhrasePageData(result.body, searchExample);
    print(encoder.convert(parsedResult));
  });
}
```