import 'package:html/parser.dart';
import 'package:html/dom.dart';

import './baseUri.dart';
import './objects.dart';

final RegExp _kanjiRegex = RegExp(r'[\u4e00-\u9faf\u3400-\u4dbf]');

/// Provides the URI for an example search
String uriForExampleSearch(String phrase) {
  return '$SCRAPE_BASE_URI${Uri.encodeComponent(phrase)}%23sentences';
}

List<Element> _getChildrenAndSymbols(Element ul) {
  final ulText = ul.text;
  final ulCharArray = ulText.split('');
  final ulChildren = ul.children;
  var offsetPointer = 0;
  List<Element> result = [];

  for (var element in ulChildren) {
    if (element.text != ulText.substring(offsetPointer, offsetPointer + element.text.length)){
      var symbols = '';
      while (element.text.substring(0,1) != ulCharArray[offsetPointer]) {
        symbols += ulCharArray[offsetPointer];
        offsetPointer++;
      }
      final symbolElement = Element.html('<span>$symbols</span>'); 
      result.add(symbolElement);
    }
      offsetPointer += element.text.length;
      result.add(element);
  }
  if (offsetPointer + 1 != ulText.length){
    final symbols = ulText.substring(offsetPointer, ulText.length-1);
    final symbolElement = Element.html('<span>$symbols</span>'); 
    result.add(symbolElement);
  }
  return result;
}

ExampleResultData _getKanjiAndKana(Element div) {
  final ul = div.querySelector('ul');
  final contents = _getChildrenAndSymbols(ul);

  var kanji = '';
  var kana = '';
  for (var i = 0; i < contents.length; i += 1) {
    final content = contents[i];
    if (content.localName == 'li') {
      final li = content;
      final furigana = li.querySelector('.furigana')?.text;
      final unlifted = li.querySelector('.unlinked')?.text;

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
      if (text != null) {
        kanji += text;
        kana += text;
      }
    }
  }

  return ExampleResultData(
    kanji: kanji,
    kana: kana,
  );
}

List<ExampleSentencePiece> getPieces(Element sentenceElement) {
  final pieceElements = sentenceElement.querySelectorAll('li.clearfix');
  final List<ExampleSentencePiece> pieces = [];
  for (var pieceIndex = 0; pieceIndex < pieceElements.length; pieceIndex += 1) {
    final pieceElement = pieceElements[pieceIndex];
    pieces.add(ExampleSentencePiece(
      lifted: pieceElement.querySelector('.furigana')?.text,
      unlifted: pieceElement.querySelector('.unlinked')?.text,
    ));
  }

  return pieces;
}

ExampleResultData _parseExampleDiv(Element div) {
  final result = _getKanjiAndKana(div);
  result.english = div.querySelector('.english').text;
  result.pieces = getPieces(div) ?? [];

  return result;
}

/// Parses a jisho example sentence search page to an object
ExampleResults parseExamplePageData(String pageHtml, String phrase) {
  final document = parse(pageHtml);
  final divs = document.querySelectorAll('.sentence_content');

  final results = divs.map((div) => _parseExampleDiv(div)).toList();

  return ExampleResults(
    query: phrase,
    found: results.isNotEmpty,
    results: results ?? [],
    uri: uriForExampleSearch(phrase),
    phrase: phrase,
  );
}