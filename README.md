# unofficial_jisho_api
 ![pub version](https://img.shields.io/pub/v/unofficial_jisho_api)
 ![pub likes](https://badges.bar/unofficial_jisho_api/likes)
 ![pub points](https://badges.bar/unofficial_jisho_api/pub%20points)
 ![pub popularity](https://badges.bar/unofficial_jisho_api/popularity)

A rewrite of the [unofficial-jisho-api](https://www.npmjs.com/package/unofficial-jisho-api)


## Usage

Below are some basic examples.

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

    final data = result.data;
    if (data != null) {
      print('Kanji: ${data.kanji}');
      print('Taught in: ${data.taughtIn}');
      print('JLPT level: ${data.jlptLevel}');
      print('Newspaper frequency rank: ${data.newspaperFrequencyRank}');
      print('Stroke count: ${data.strokeCount}');
      print('Meaning: ${data.meaning}');
      print('Kunyomi: ${jsonEncode(data.kunyomi)}');
      print('Kunyomi example: ${jsonEncode(data.kunyomiExamples[0])}');
      print('Onyomi: ${jsonEncode(data.onyomi)}');
      print('Onyomi example: ${jsonEncode(data.onyomiExamples[0])}');
      print('Radical: ${jsonEncode(data.radical)}');
      print('Parts: ${jsonEncode(data.parts)}');
      print('Stroke order diagram: ${data.strokeOrderDiagramUri}');
      print('Stroke order SVG: ${data.strokeOrderSvgUri}');
      print('Stroke order GIF: ${data.strokeOrderGifUri}');
      print('Jisho Uri: ${data.uri}');
    }
  });
}
```

This outputs the following:

```
Found: true
Kanji: 語
Taught in: grade 2
JLPT level: N5
Newspaper frequency rank: 301
Stroke count: 14
Meaning: word, speech, language
Kunyomi: ["かた.る","かた.らう"]
Kunyomi example: {"example":"語る","reading":"かたる","meaning":"to talk about, to speak of, to tell, to narrate, to recite, to chant, to indicate, to show"}
Onyomi: ["ゴ"]
Onyomi example: {"example":"語","reading":"ゴ","meaning":"language, word"}
Radical: {"symbol":"言","forms":["訁"],"meaning":"speech"}
Parts: ["五","口","言"]
Stroke order diagram: https://classic.jisho.org/static/images/stroke_diagrams/35486_frames.png
Stroke order SVG: https://d1w6u4xc3l95km.cloudfront.net/kanji-2015-03/08a9e.svg
Stroke order GIF: https://raw.githubusercontent.com/mistval/kanji_images/master/gifs/8a9e.gif
Jisho Uri: https://jisho.org/search/%E8%AA%9E%23kanji
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

This outputs the following:

```
Jisho Uri: https://jisho.org/search/%E6%97%A5%23sentences

日本人ならそんなことはけっしてしないでしょう。
にほんじんならそんなことはけっしてしないでしょう。
A Japanese person would never do such a thing.
[{"lifted":"にほんじん","unlifted":"日本人"},{"lifted":null,"unlifted":"なら"},{"lifted":null,"unlifted":"そんな"},{"lifted":null,"unlifted":"こと"},{"lifted":null,"unlifted":"は"},{"lifted":null,"unlifted":"けっして"},{"lifted":null,"unlifted":"しない"},{"lifted":null,"unlifted":"でしょう"}]

今日はとても暑い。
きょうはとてもあつい。
It is very hot today.
[{"lifted":"きょう","unlifted":"今日"},{"lifted":null,"unlifted":"は"},{"lifted":null,"unlifted":"とても"},{"lifted":"あつ","unlifted":"暑い"}]

日本には美しい都市が多い。例えば京都、奈良だ。
にほんにはうつくしいとしがおおい。たとえばきょうと、奈良だ。
Japan is full of beautiful cities. Kyoto and Nara, for instance.
[{"lifted":"にほん","unlifted":"日本"},{"lifted":null,"unlifted":"には"},{"lifted":"うつく","unlifted":"美しい"},{"lifted":"とし","unlifted":"都市"},{"lifted":null,"unlifted":"が"},{"lifted":"おお","unlifted":"多い"},{"lifted":"たと","unlifted":"例えば"},{"lifted":"きょうと","unlifted":"京都"},{"lifted":null,"unlifted":"だ"}]

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

This outputs the following:

```json
{
  "found": true,
  "query": "谷",
  "data": {
    "uri": "https://jisho.org/word/%E8%B0%B7",
    "tags": [
      "Common word",
      "JLPT N3",
      "Wanikani level 5"
    ],
    "meanings": [
      {
        "seeAlsoTerms": [],
        "sentences": [],
        "definition": "valley",
        "supplemental": [],
        "definitionAbstract": null,
        "tags": []
      },
      {
        "seeAlsoTerms": [],
        "sentences": [],
        "definition": "Valley",
        "supplemental": [],
        "definitionAbstract": "In geology, a valley or dale is a depression with predominant extent in one direction. A very deep river valley may be called a canyon or gorge. The terms U-shaped and V-shaped are descriptive terms of geography to characterize the form of valleys. Most valleys belong to one of these two main types or a mixture of them, (at least) with respect of the cross section of the slopes or hillsides.",
        "tags": []
      }
    ],
    "otherForms": [
      {
        "kanji": "渓",
        "kana": "たに"
      },
      {
        "kanji": "谿",
        "kana": "たに"
      }
    ],
    "audio": [
      {
        "uri": "https://d1vjc5dkcd3yh2.cloudfront.net/audio/b9ff4f25c7a20f0f39131b3e3db0cd19.mp3",
        "mimetype": "audio/mpeg"
      },
      {
        "uri": "https://d1vjc5dkcd3yh2.cloudfront.net/audio_ogg/b9ff4f25c7a20f0f39131b3e3db0cd19.ogg",
        "mimetype": "audio/ogg"
      }
    ],
    "notes": []
  }
}
```

## Parsing HTML strings

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
    final data = parsedResult.data;
    if (data != null) {
      print('JLPT level: ${data.jlptLevel}');
      print('Stroke count: ${data.strokeCount}');
      print('Meaning: ${data.meaning}');
    }
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

## Note on usage with web

Although the library is marked as ok for use with website outputs, you will not be able to reach through the CORS setup of jisho.org. You should set up a backend as a proxy if you want to make a website. See (#3)

## About

Permission to scrape granted by Jisho's admin Kimtaro: https://jisho.org/forum/54fefc1f6e73340b1f160000-is-there-any-kind-of-search-api

## Notes

The null-safety of dart 2.12 makes the parsing and interpreting of the native search API a little unreliable. Please be cautious when using `jisho.searchForPhrase()`, and if you do, please read the [API docs][api-docs] about the different result values.

[api-docs]: https://pub.dev/documentation/unofficial_jisho_api/latest/