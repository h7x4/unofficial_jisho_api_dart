import 'package:html_unescape/html_unescape.dart' as html_entities;

import './baseUri.dart';
import './objects.dart';

final _htmlUnescape = html_entities.HtmlUnescape();

const _onyomiLocatorSymbol = 'On';
const _kunyomiLocatorSymbol = 'Kun';

String _removeNewlines(String str) {
  return str.replaceAll(RegExp(r'(?:\r|\n)') , '').trim();
}

/// Provides the URI for a kanji search
String uriForKanjiSearch(String kanji) {
  return '$SCRAPE_BASE_URI${Uri.encodeComponent(kanji)}%23kanji';
}

String _getUriForStrokeOrderDiagram(String kanji) {
  return '$STROKE_ORDER_DIAGRAM_BASE_URI${kanji.codeUnitAt(0)}_frames.png';
}

bool _containsKanjiGlyph(String pageHtml, String kanji) {
  final kanjiGlyphToken = '<h1 class="character" data-area-name="print" lang="ja">$kanji</h1>';
  return pageHtml.contains(kanjiGlyphToken);
}

String _getStringBetweenIndicies(String data, int startIndex, int endIndex) {
  final result = data.substring(startIndex, endIndex);
  return _removeNewlines(result).trim();
}

String _getStringBetweenStrings(String data, String startString, String endString) {
  final regex = RegExp('${RegExp.escape(startString)}(.*?)${RegExp.escape(endString)}', dotAll: true);
  final match = regex.allMatches(data).toList();

  return match.isNotEmpty ? match[0].group(1).toString() : null;
}

int _getIntBetweenStrings(String pageHtml, String startString, String endString) {
  final  stringBetweenStrings = _getStringBetweenStrings(pageHtml, startString, endString);
  return int.parse(stringBetweenStrings);
}

List<String> _getAllGlobalGroupMatches(String str, RegExp regex) {
  var regexResults = regex.allMatches(str).toList();
  List<String> results = [];
  for (var match in regexResults) {
    results.add(match.group(1));
  }

  return results;
}

List<String> _parseAnchorsToArray(String str) {
  final regex = RegExp(r'<a href=".*?">(.*?)<\/a>');
  return _getAllGlobalGroupMatches(str, regex);
}

List<String> _getYomi(String pageHtml, String yomiLocatorSymbol) {
  final yomiSection = _getStringBetweenStrings(pageHtml, '<dt>$yomiLocatorSymbol:</dt>', '</dl>');
  return _parseAnchorsToArray(yomiSection ?? '');
}

List<String> _getKunyomi(String pageHtml) {
  return _getYomi(pageHtml, _kunyomiLocatorSymbol);
}

List<String> _getOnyomi(String pageHtml) {
  return _getYomi(pageHtml, _onyomiLocatorSymbol);
}

List<YomiExample> _getYomiExamples(String pageHtml, String yomiLocatorSymbol) {
  final locatorString = '<h2>$yomiLocatorSymbol reading compounds</h2>';
  final exampleSection = _getStringBetweenStrings(pageHtml, locatorString, '</ul>');
  if (exampleSection==null) {
    return null;
  }

  final regex = RegExp(r'<li>(.*?)<\/li>', dotAll: true);
  final regexResults = _getAllGlobalGroupMatches(exampleSection, regex).map((s) => s.trim());

  final examples = regexResults.map((regexResult) {
    final examplesLines = regexResult.split('\n').map((s) => s.trim()).toList();
    return YomiExample(
      example: examplesLines[0],
      reading: examplesLines[1].replaceAll('【', '').replaceAll('】', ''),
      meaning: _htmlUnescape.convert(examplesLines[2]),
    );
  });

  return examples.toList();
}

List<YomiExample> _getOnyomiExamples(String pageHtml) {
  return _getYomiExamples(pageHtml, _onyomiLocatorSymbol);
}

List<YomiExample> _getKunyomiExamples(String pageHtml) {
  return _getYomiExamples(pageHtml, _kunyomiLocatorSymbol);
}

Radical _getRadical(String pageHtml) {
  const radicalMeaningStartString = '<span class="radical_meaning">';
  const radicalMeaningEndString = '</span>';

  var radicalMeaning = _getStringBetweenStrings(
    pageHtml,
    radicalMeaningStartString,
    radicalMeaningEndString,
  ).trim();

  if (radicalMeaning!=null) {
    final radicalMeaningStartIndex = pageHtml.indexOf(radicalMeaningStartString);

    final radicalMeaningEndIndex = pageHtml.indexOf(
      radicalMeaningEndString,
      radicalMeaningStartIndex,
    );

    final radicalSymbolStartIndex = radicalMeaningEndIndex + radicalMeaningEndString.length;
    const radicalSymbolEndString = '</span>';
    final radicalSymbolEndIndex = pageHtml.indexOf(radicalSymbolEndString, radicalSymbolStartIndex);

    final radicalSymbolsString = _getStringBetweenIndicies(
      pageHtml,
      radicalSymbolStartIndex,
      radicalSymbolEndIndex,
    );

    if (radicalSymbolsString.length > 1) {
      final radicalForms = radicalSymbolsString
        .substring(1)
        .replaceAll('(', '')
        .replaceAll(')', '')
        .trim()
        .split(', ');

      return Radical(
        symbol: radicalSymbolsString[0],
        forms: radicalForms ?? [],
        meaning: radicalMeaning
      );
    }

    return Radical (
      symbol: radicalSymbolsString,
      meaning: radicalMeaning
    );
  }

  return null;
}

List<String> _getParts(String pageHtml) {
  const partsSectionStartString = '<dt>Parts:</dt>';
  const partsSectionEndString = '</dl>';

  final partsSection = _getStringBetweenStrings(
    pageHtml,
    partsSectionStartString,
    partsSectionEndString,
  );

  var result = _parseAnchorsToArray(partsSection);
  result.sort();

  return (result);
}

String _getSvgUri(String pageHtml) {
  var svgRegex = RegExp('\/\/.*?.cloudfront.net\/.*?.svg');
  final regexResult = svgRegex.firstMatch(pageHtml).group(0).toString();
  return regexResult.isNotEmpty ? 'https:$regexResult' : null;
}

String _getGifUri(String kanji) {
  final unicodeString = kanji.codeUnitAt(0).toRadixString(16);
  final fileName = '$unicodeString.gif';
  final animationUri = 'https://raw.githubusercontent.com/mistval/kanji_images/master/gifs/$fileName';

  return animationUri;
}

int _getNewspaperFrequencyRank(String pageHtml) {
  final frequencySection = _getStringBetweenStrings(pageHtml, '<div class="frequency">', '</div>');
  return (frequencySection != null) ? int.parse(_getStringBetweenStrings(frequencySection, '<strong>', '</strong>')) : null;
}

/// Parses a jisho kanji search page to an object
KanjiResult parseKanjiPageData(String pageHtml, String kanji) {
  final result = KanjiResult();
  result.query = kanji;
  result.found = _containsKanjiGlyph(pageHtml, kanji);
  if (result.found==false) {
    return result;
  }

  result.taughtIn = _getStringBetweenStrings(pageHtml, 'taught in <strong>', '</strong>');
  result.jlptLevel = _getStringBetweenStrings(pageHtml, 'JLPT level <strong>', '</strong>');
  result.newspaperFrequencyRank = _getNewspaperFrequencyRank(pageHtml);
  result.strokeCount = _getIntBetweenStrings(pageHtml, '<strong>', '</strong> strokes');
  result.meaning = _htmlUnescape.convert(_removeNewlines(_getStringBetweenStrings(pageHtml, '<div class="kanji-details__main-meanings">', '</div>')).trim());
  result.kunyomi = _getKunyomi(pageHtml) ?? [];
  result.onyomi = _getOnyomi(pageHtml) ?? [];
  result.onyomiExamples = _getOnyomiExamples(pageHtml) ?? [];
  result.kunyomiExamples = _getKunyomiExamples(pageHtml) ?? [];
  result.radical = _getRadical(pageHtml);
  result.parts = _getParts(pageHtml) ?? [];
  result.strokeOrderDiagramUri = _getUriForStrokeOrderDiagram(kanji);
  result.strokeOrderSvgUri = _getSvgUri(pageHtml);
  result.strokeOrderGifUri = _getGifUri(kanji);
  result.uri = uriForKanjiSearch(kanji);
  return result;
}