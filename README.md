# Warning: not functional yet

A rewrite of the [unofficial-jisho-api](https://www.npmjs.com/package/unofficial-jisho-api)


## Usage

Below are some basic examples.

### Word/phrase search (provided by official Jisho API)

This returns the same results as the official [Jisho.org](https://jisho.org/) API. See the discussion of that [here](http://jisho.org/forum/54fefc1f6e73340b1f160000-is-there-any-kind-of-search-api).

```dart
import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
final jisho = JishoApi();

main() async {
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
import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
final jisho = JishoApi();

main() async {
  jisho.searchForKanji('語').then((result) {
    print('Found: ' + result.found);
    print('Taught in: ' + result.taughtIn);
    print('JLPT level: ' + result.jlptLevel);
    print('Newspaper frequency rank: ' + result.newspaperFrequencyRank);
    print('Stroke count: ' + result.strokeCount);
    print('Meaning: ' + result.meaning);
    print('Kunyomi: ' + jsonEncode(result.kunyomi));
    print('Kunyomi example: ' + jsonEncode(result.kunyomiExamples[0]));
    print('Onyomi: ' + jsonEncode(result.onyomi));
    print('Onyomi example: ' + jsonEncode(result.onyomiExamples[0]));
    print('Radical: ' + jsonEncode(result.radical));
    print('Parts: ' + jsonEncode(result.parts));
    print('Stroke order diagram: ' + result.strokeOrderDiagramUri);
    print('Stroke order SVG: ' + result.strokeOrderSvgUri);
    print('Stroke order GIF: ' + result.strokeOrderGifUri);
    print('Jisho Uri: ' + result.uri);
  }
}
```

This outputs the following:

```
Found: true
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
Parts: ["口","五","言"]
Stroke order diagram: http://classic.jisho.org/static/images/stroke_diagrams/35486_frames.png
Stroke order SVG: http://d1w6u4xc3l95km.cloudfront.net/kanji-2015-03/08a9e.svg
Stroke order GIF: https://raw.githubusercontent.com/mistval/kotoba/master/resources/images/kanjianimations/08a9e_anim.gif
Jisho Uri: http://jisho.org/search/%E8%AA%9E%23kanji
```

### Example search

```dart
import 'dart:convert' show jsonEncode;
import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
final jisho = JishoApi();

main() async {
  jisho.searchForExamples('日').then((result) {
    print('Jisho Uri: ' + result.uri);
    print();

    for (int i = 0; i < 3; ++i) {
      var example = result.results[i];
      print(example.kanji);
      print(example.kana);
      print(example.english);
      print(jsonEncode(example.pieces));
      print();
    }
  });
}
```

This outputs the following:

```
Jisho Uri: http://jisho.org/search/%E6%97%A5%23sentences

日本人ならそんなことはけっしてしないでしょう。
にほんじんならそんなことはけっしてしないでしょう。
A Japanese person would never do such a thing.
[{"lifted":"にほんじん","unlifted":"日本人"},{"lifted":"","unlifted":"なら"},{"lifted":"","unlifted":"そんな"},{"lifted":"","unlifted":"こと"},{"lifted":"","unlifted":"は"},{"lifted":"","unlifted":"けっして"},{"lifted":"","unlifted":"しない"},{"lifted":"","
unlifted":"でしょう"}]

今日はとても暑い。
きょうはとてもあつい。
It is very hot today.
[{"lifted":"きょう","unlifted":"今日"},{"lifted":"","unlifted":"は"},{"lifted":"","unlifted":"とても"},{"lifted":"あつ","unlifted":"暑い"}]

日本には美しい都市が多い。例えば京都、奈良だ。
にほんにはうつくしいとしがおおい。たとえばきょうと、奈良だ。
Japan is full of beautiful cities. Kyoto and Nara, for instance.
[{"lifted":"にほん","unlifted":"日本"},{"lifted":"","unlifted":"には"},{"lifted":"うつく","unlifted":"美しい"},{"lifted":"とし","unlifted":"都市"},{"lifted":"","unlifted":"が"},{"lifted":"おお","unlifted":"多い"},{"lifted":"たと","unlifted":"例えば"},{"lift
ed":"きょうと","unlifted":"京都"},{"lifted":"","unlifted":"だ"}]
```

### Word/phrase scraping

This scrapes the word/phrase page on Jisho.org. This can get you some data that the official API doesn't have, such as JLPT level and part-of-speech. The official API (`searchForPhrase`) should be preferred if it has the data you need.

```dart
import 'dart:convert' show jsonEncode;
import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
final jisho = JishoApi();

main() async {
  jisho.scrapeForPhrase('谷').then((data) {
    print(jsonEncode(data);
  });
}
```

This outputs the following:

```json
{
  "found": true,
  "query": "谷",
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
      "definitionAbstract": "",
      "tags": [
        "noun"
      ]
    },
    {
      "seeAlsoTerms": [],
      "sentences": [],
      "definition": "Valley",
      "supplemental": [],
      "definitionAbstract": "In geology, a valley or dale is a depression with predominant extent in one direction. A very deep river valley may be called a canyon or gorge. The terms U-shaped and V-shaped are descriptive terms of geography to characterize the form of valleys. Most valleys belong to one of these two main types or a mixture of them, (at least) with respect of the cross section of the slopes or hillsides.",
      "tags": [
        "wikipedia definition"
      ]
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
  "notes": []
}
```

## Parsing HTML strings

You can provide the HTML responses from Jisho yourself. This can be useful if you need to use a CORS proxy or something. You can do whatever you need to do to get the HTML and then provide it to this module's parsing functions. For example:

### Parse kanji page HTML

```dart
import 'package:http/http.dart' as http;
import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
final jisho = JishoApi();

main() async {
  const SEARCH_KANJI = '車';
  final SEARCH_URI = jisho.getUriForKanjiSearch(SEARCH_KANJI);

  final response = await http.get(SEARCH_URI);
  final json = jisho.parseKanjiPageHtml(response.body, SEARCH_KANJI);

  print('JLPT level: ${json.jlptLevel}');
  print('Stroke count: ${json.strokeCount}');
  print('Meaning: ${json.meaning}');
}
```

### Parse example page HTML

```dart
import 'package:http/http.dart' as http;
import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
final jisho = JishoApi();

main() async {
  const SEARCH_EXAMPLE = '保護者';
  final SEARCH_URI = jisho.getUriForExampleSearch(SEARCH_EXAMPLE);

  final response = await http.get(SEARCH_URI);
  final json = jisho.parseExamplePageHtml(response.body, SEARCH_EXAMPLE);
  
  print('English: ${json.results[0].english}');
  print('Kanji ${json.results[0].kanji}');
  print('Kana: ${json.results[0].kana}');
}
```

### Parse phrase page HTML

```dart
import 'dart:convert' show jsonEncode;
import 'package:http/http.dart' as http;
import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
final jisho = JishoApi();

main() async {
  const SEARCH_EXAMPLE = '保護者';
  final SEARCH_URI = jisho.getUriForPhraseScrape(SEARCH_EXAMPLE);

  final response = await http.get(SEARCH_URI);
  const json = jisho.parsePhraseScrapeHtml(response.body, SEARCH_EXAMPLE);
  
  print(jsonEncode(json, null, 2)); 
}
```

## About

Permission to scrape granted by Jisho's admin Kimtaro: http://jisho.org/forum/54fefc1f6e73340b1f160000-is-there-any-kind-of-search-api