import 'package:html_unescape/html_unescape.dart' as html_entities;

import './base_uri.dart';
import './objects.dart';
import './scraping.dart';

final _htmlUnescape = html_entities.HtmlUnescape();

const _onyomiLocatorSymbol = 'On';
const _kunyomiLocatorSymbol = 'Kun';

/// Provides the URI for a kanji search
Uri uriForKanjiSearch(String kanji) {
  return Uri.parse('$scrapeBaseUri${Uri.encodeComponent(kanji)}%23kanji');
}

String _getUriForStrokeOrderDiagram(String kanji) {
  return '$strokeOrderDiagramBaseUri${kanji.codeUnitAt(0)}_frames.png';
}

bool _containsKanjiGlyph(String pageHtml, String kanji) {
  final kanjiGlyphToken =
      '<h1 class="character" data-area-name="print" lang="ja">$kanji</h1>';
  return pageHtml.contains(kanjiGlyphToken);
}

List<String> _getYomi(String pageHtml, String yomiLocatorSymbol) {
  final yomiSection = getStringBetweenStrings(
      pageHtml, '<dt>$yomiLocatorSymbol:</dt>', '</dl>');
  return parseAnchorsToArray(yomiSection ?? '');
}

List<String> _getKunyomi(String pageHtml) {
  return _getYomi(pageHtml, _kunyomiLocatorSymbol);
}

List<String> _getOnyomi(String pageHtml) {
  return _getYomi(pageHtml, _onyomiLocatorSymbol);
}

List<YomiExample> _getYomiExamples(String pageHtml, String yomiLocatorSymbol) {
  final locatorString = '<h2>$yomiLocatorSymbol reading compounds</h2>';
  final exampleSection =
      getStringBetweenStrings(pageHtml, locatorString, '</ul>');
  if (exampleSection == null) {
    return [];
  }

  final regex = RegExp(r'<li>(.*?)<\/li>', dotAll: true);
  final regexResults =
      getAllGlobalGroupMatches(exampleSection, regex).map((s) => s.trim());

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

Radical? _getRadical(String pageHtml) {
  const radicalMeaningStartString = '<span class="radical_meaning">';
  const radicalMeaningEndString = '</span>';

  var radicalMeaning = getStringBetweenStrings(
    pageHtml,
    radicalMeaningStartString,
    radicalMeaningEndString,
  )?.trim();

  if (radicalMeaning == null) {
    return null;
  }

  final radicalMeaningStartIndex = pageHtml.indexOf(radicalMeaningStartString);

  final radicalMeaningEndIndex = pageHtml.indexOf(
    radicalMeaningEndString,
    radicalMeaningStartIndex,
  );

  final radicalSymbolStartIndex =
      radicalMeaningEndIndex + radicalMeaningEndString.length;
  const radicalSymbolEndString = '</span>';
  final radicalSymbolEndIndex =
      pageHtml.indexOf(radicalSymbolEndString, radicalSymbolStartIndex);

  final radicalSymbolsString = getStringBetweenIndicies(
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
      forms: radicalForms,
      meaning: radicalMeaning,
    );
  }

  return Radical(symbol: radicalSymbolsString, meaning: radicalMeaning);
}

String _getMeaning(String pageHtml) {
  final rawMeaning = assertNotNull(
    variable: getStringBetweenStrings(
      pageHtml,
      '<div class="kanji-details__main-meanings">',
      '</div>',
    ),
    errorMessage:
        "Could not parse meaning. Is the provided document corrupt, or has Jisho been updated?",
  );

  return _htmlUnescape.convert(removeNewlines(rawMeaning).trim());
}

List<String> _getParts(String pageHtml) {
  const partsSectionStartString = '<dt>Parts:</dt>';
  const partsSectionEndString = '</dl>';

  final partsSection = getStringBetweenStrings(
    pageHtml,
    partsSectionStartString,
    partsSectionEndString,
  );

  if (partsSection == null) {
    return [];
  }

  var result = parseAnchorsToArray(partsSection);
  result.sort();

  return result;
}

String _getSvgUri(String pageHtml) {
  var svgRegex = RegExp('\/\/.*?.cloudfront.net\/.*?.svg');

  final regexResult = assertNotNull(
    variable: svgRegex.firstMatch(pageHtml)?.group(0)?.toString(),
    errorMessage:
        "Could not find SVG URI. Is the provided document corrupt, or has Jisho been updated?",
  );

  return 'https:$regexResult';
}

String _getGifUri(String kanji) {
  final unicodeString = kanji.codeUnitAt(0).toRadixString(16);
  final fileName = '$unicodeString.gif';
  final animationUri =
      'https://raw.githubusercontent.com/mistval/kanji_images/master/gifs/$fileName';

  return animationUri;
}

int? _getNewspaperFrequencyRank(String pageHtml) {
  final frequencySection = getStringBetweenStrings(
    pageHtml,
    '<div class="frequency">',
    '</div>',
  );

  // ignore: avoid_returning_null
  if (frequencySection == null) return null;

  final frequencyRank =
      getStringBetweenStrings(frequencySection, '<strong>', '</strong>');

  return frequencyRank != null ? int.parse(frequencyRank) : null;
}

int _getStrokeCount(String pageHtml) {
  final strokeCount = assertNotNull(
    variable: getIntBetweenStrings(pageHtml, '<strong>', '</strong> strokes'),
    errorMessage:
        "Could not parse stroke count. Is the provided document corrupt, or has Jisho been updated?",
  );

  return strokeCount;
}

String? _getTaughtIn(String pageHtml) {
  return getStringBetweenStrings(pageHtml, 'taught in <strong>', '</strong>');
}

String? _getJlptLevel(String pageHtml) {
  return getStringBetweenStrings(pageHtml, 'JLPT level <strong>', '</strong>');
}

/// Parses a jisho kanji search page to an object
KanjiResult parseKanjiPageData(String pageHtml, String kanji) {
  final result = KanjiResult(
    query: kanji,
    found: _containsKanjiGlyph(pageHtml, kanji),
  );

  if (result.found == false) {
    return result;
  }

  result.data = KanjiResultData(
    strokeCount: _getStrokeCount(pageHtml),
    meaning: _getMeaning(pageHtml),
    strokeOrderDiagramUri: _getUriForStrokeOrderDiagram(kanji),
    strokeOrderSvgUri: _getSvgUri(pageHtml),
    strokeOrderGifUri: _getGifUri(kanji),
    uri: uriForKanjiSearch(kanji).toString(),
    parts: _getParts(pageHtml),
    taughtIn: _getTaughtIn(pageHtml),
    jlptLevel: _getJlptLevel(pageHtml),
    newspaperFrequencyRank: _getNewspaperFrequencyRank(pageHtml),
    kunyomi: _getKunyomi(pageHtml),
    onyomi: _getOnyomi(pageHtml),
    kunyomiExamples: _getKunyomiExamples(pageHtml),
    onyomiExamples: _getOnyomiExamples(pageHtml),
    radical: _getRadical(pageHtml),
  );

  return result;
}
