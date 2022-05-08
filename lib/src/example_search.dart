import 'package:html/dom.dart';
import 'package:html/parser.dart';

import './base_uri.dart';
import './objects.dart';
import './scraping.dart';

final RegExp _kanjiRegex = RegExp(r'[\u4e00-\u9faf\u3400-\u4dbf]');

/// Provides the URI for an example search
Uri uriForExampleSearch(String phrase) {
  return Uri.parse('$scrapeBaseUri${Uri.encodeComponent(phrase)}%23sentences');
}

List<Element> _getChildrenAndSymbols(Element ul) {
  final ulText = ul.text;
  final ulCharArray = ulText.split('');
  final ulChildren = ul.children;
  var offsetPointer = 0;
  final result = <Element>[];

  for (var element in ulChildren) {
    if (element.text !=
        ulText.substring(offsetPointer, offsetPointer + element.text.length)) {
      var symbols = '';
      while (element.text.substring(0, 1) != ulCharArray[offsetPointer]) {
        symbols += ulCharArray[offsetPointer];
        offsetPointer++;
      }
      final symbolElement = Element.html('<span>$symbols</span>');
      result.add(symbolElement);
    }
    offsetPointer += element.text.length;
    result.add(element);
  }
  if (offsetPointer + 1 != ulText.length) {
    final symbols = ulText.substring(offsetPointer, ulText.length - 1);
    final symbolElement = Element.html('<span>$symbols</span>');
    result.add(symbolElement);
  }
  return result;
}

/// Although return type is List<String>, it is to be interpreted as (String, String)
List<String> _getKanjiAndKana(Element div) {
  final ul = assertNotNull(
    variable: div.querySelector('ul'),
    errorMessage:
        "Could not parse kanji/kana div. Is the provided document corrupt, or has Jisho been updated?",
  );
  final contents = _getChildrenAndSymbols(ul);

  var kanji = '';
  var kana = '';
  for (var i = 0; i < contents.length; i += 1) {
    final content = contents[i];
    if (content.localName == 'li') {
      final li = content;
      final furigana = li.querySelector('.furigana')?.text;
      final unlifted = assertNotNull(
        variable: li.querySelector('.unlinked')?.text,
        errorMessage:
            "Could not parse a piece of the example sentence. Is the provided document corrupt, or has Jisho been updated?",
      );

      if (furigana != null) {
        kanji += unlifted;
        kana += furigana;

        final kanaEnding = [];
        for (var j = unlifted.length - 1; j > 0; j -= 1) {
          final char = unlifted[j];
          if (!_kanjiRegex.hasMatch(char)) {
            kanaEnding.add(char);
          } else {
            break;
          }
        }

        kana += kanaEnding.reversed.join('');
      } else {
        kanji += unlifted;
        kana += unlifted;
      }
    } else {
      final text = content.text.trim();
      kanji += text;
      kana += text;
    }
  }

  return [kanji, kana];
}

Element _normalizeSentenceElement(Element sentenceElement) =>
    Element.html('<ul>'
        '${sentenceElement.children.first.innerHtml.replaceAllMapped(
      RegExp(r'(?<=^|<\/li>)\s*([^<>]+)\s*(?=<li)'),
      (match) =>
          '<li class="clearfix"><span class="unlinked">${match.group(0)}</span></li>',
    )}'
        '</ul>');

// ignore: public_member_api_docs
List<ExampleSentencePiece> getPieces(Element sentenceElement) {
  return _normalizeSentenceElement(sentenceElement)
      .querySelectorAll('li.clearfix')
      .map((var e) {
    final unlifted = assertNotNull(
      variable: e.querySelector('.unlinked')?.text,
      errorMessage:
          "Could not parse a piece of the example sentence. Is the provided document corrupt, or has Jisho been updated?",
    );

    return ExampleSentencePiece(
      lifted: e.querySelector('.furigana')?.text,
      unlifted: unlifted,
    );
  }).toList();
}

ExampleResultData _parseExampleDiv(Element div) {
  final result = _getKanjiAndKana(div);
  final kanji = result[0];
  final kana = result[1];

  final english = assertNotNull(
    variable: div.querySelector('.english')?.text,
    errorMessage:
        "Could not parse translation. Is the provided document corrupt, or has Jisho been updated?",
  );
  final pieces = getPieces(div);

  return ExampleResultData(
    english: english,
    kanji: kanji,
    kana: kana,
    pieces: pieces,
  );
}

/// Parses a jisho example sentence search page to an object
ExampleResults parseExamplePageData(String pageHtml, String phrase) {
  final document = parse(pageHtml);
  final divs = document.querySelectorAll('.sentence_content');

  final results = divs.map(_parseExampleDiv).toList();

  return ExampleResults(
    query: phrase,
    results: results,
  );
}
