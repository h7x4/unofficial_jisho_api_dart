import './baseURI.dart';
import './objects.dart';

import 'package:html/parser.dart';
import 'package:html/dom.dart';

final RegExp kanjiRegex = RegExp(r'[\u4e00-\u9faf\u3400-\u4dbf]');

String uriForExampleSearch(String phrase) {
  return '${SCRAPE_BASE_URI}${Uri.encodeComponent(phrase)}%23sentences';
}

/* TODO: This is the wrong approach. 
 * Symbols such as 、「」。 are missing in mid sentence
 * Maybe also JP fullwidth numbers?
 */

String getEndSymbolsOfExampleSentence(Element ul) {
  final endSymbols = RegExp(r'<\/li>([^<>]+)$');
  return endSymbols.firstMatch(ul.innerHtml).group(1);
}

ExampleResultData getKanjiAndKana(Element div) {
  final ul = div.querySelector('ul');
  final contents = ul.children;

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
          if (!kanjiRegex.hasMatch(char)) {
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
    final endSymbols = getEndSymbolsOfExampleSentence(ul).trim();
    kanji+= endSymbols;
    kana += endSymbols;

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

ExampleResultData parseExampleDiv(Element div) {
  final result = getKanjiAndKana(div);
  result.english = div.querySelector('.english').text;
  result.pieces = getPieces(div) ?? [];

  return result;
}

ExampleResults parseExamplePageData(String pageHtml, String phrase) {
  final document = parse(pageHtml);
  final divs = document.querySelectorAll('.sentence_content');

  final results = divs.map((div) => parseExampleDiv(div)).toList();

  return ExampleResults(
    query: phrase,
    found: results.isNotEmpty,
    results: results ?? [],
    uri: uriForExampleSearch(phrase),
    phrase: phrase,
  );
}