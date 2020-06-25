import './baseURI.dart';
import './objects.dart';


import 'package:html_unescape/html_unescape.dart' as html_entities;
final htmlUnescape = html_entities.HtmlUnescape();

const String ONYOMI_LOCATOR_SYMBOL = 'On';
const String KUNYOMI_LOCATOR_SYMBOL = 'Kun';

String removeNewlines(String str) {
  return str.replaceAll(RegExp(r'(?:\r|\n)') , '').trim();
}

/// Provides the URI for a kanji search
String uriForKanjiSearch(String kanji) {
  return '${SCRAPE_BASE_URI}${Uri.encodeComponent(kanji)}%23kanji';
}

String getUriForStrokeOrderDiagram(String kanji) {
  return '${STROKE_ORDER_DIAGRAM_BASE_URI}${kanji.codeUnitAt(0)}_frames.png';
}

bool containsKanjiGlyph(String pageHtml, String kanji) {
  final kanjiGlyphToken = '<h1 class="character" data-area-name="print" lang="ja">${kanji}</h1>';
  return pageHtml.contains(kanjiGlyphToken);
}

String getStringBetweenIndicies(String data, int startIndex, int endIndex) {
  final result = data.substring(startIndex, endIndex);
  return removeNewlines(result).trim();
}

String getStringBetweenStrings(String data, String startString, String endString) {
  final regex = RegExp('${RegExp.escape(startString)}(.*?)${RegExp.escape(endString)}', dotAll: true);
  final match = regex.allMatches(data).toList();

  return match.isNotEmpty ? match[0].group(1).toString() : null;
}

int getIntBetweenStrings(String pageHtml, String startString, String endString) {
  final  stringBetweenStrings = getStringBetweenStrings(pageHtml, startString, endString);
  return int.parse(stringBetweenStrings);
}

List<String> getAllGlobalGroupMatches(String str, RegExp regex) {
  var regexResults = regex.allMatches(str).toList();
  List<String> results = [];
  for (var match in regexResults) {
    results.add(match.group(1));
  }

  return results;
}

List<String> parseAnchorsToArray(String str) {
  final regex = RegExp(r'<a href=".*?">(.*?)<\/a>');
  return getAllGlobalGroupMatches(str, regex);
}

List<String> getYomi(String pageHtml, String yomiLocatorSymbol) {
  final yomiSection = getStringBetweenStrings(pageHtml, '<dt>${yomiLocatorSymbol}:</dt>', '</dl>');
  return parseAnchorsToArray(yomiSection ?? '');
}

List<String> getKunyomi(String pageHtml) {
  return getYomi(pageHtml, KUNYOMI_LOCATOR_SYMBOL);
}

List<String> getOnyomi(String pageHtml) {
  return getYomi(pageHtml, ONYOMI_LOCATOR_SYMBOL);
}

List<YomiExample> getYomiExamples(String pageHtml, String yomiLocatorSymbol) {
  final locatorString = '<h2>${yomiLocatorSymbol} reading compounds</h2>';
  final exampleSection = getStringBetweenStrings(pageHtml, locatorString, '</ul>');
  if (exampleSection==null) {
    return null;
  }

  final regex = RegExp(r'<li>(.*?)<\/li>', dotAll: true);
  final regexResults = getAllGlobalGroupMatches(exampleSection, regex).map((s) => s.trim());

  final examples = regexResults.map((regexResult) {
    final examplesLines = regexResult.split('\n').map((s) => s.trim()).toList();
    return YomiExample(
      example: examplesLines[0],
      reading: examplesLines[1].replaceAll('【', '').replaceAll('】', ''),
      meaning: htmlUnescape.convert(examplesLines[2]),
    );
  });

  return examples.toList();
}

List<YomiExample> getOnyomiExamples(String pageHtml) {
  return getYomiExamples(pageHtml, ONYOMI_LOCATOR_SYMBOL);
}

List<YomiExample> getKunyomiExamples(String pageHtml) {
  return getYomiExamples(pageHtml, KUNYOMI_LOCATOR_SYMBOL);
}

Radical getRadical(String pageHtml) {
  const radicalMeaningStartString = '<span class="radical_meaning">';
  const radicalMeaningEndString = '</span>';

  var radicalMeaning = getStringBetweenStrings(
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

List<String> getParts(String pageHtml) {
  const partsSectionStartString = '<dt>Parts:</dt>';
  const partsSectionEndString = '</dl>';

  final partsSection = getStringBetweenStrings(
    pageHtml,
    partsSectionStartString,
    partsSectionEndString,
  );

  var result = parseAnchorsToArray(partsSection);
  result.sort();

  return (result);
}

String getSvgUri(String pageHtml) {
  var svgRegex = RegExp('\/\/.*?.cloudfront.net\/.*?.svg');
  final regexResult = svgRegex.firstMatch(pageHtml).group(0).toString();
  return regexResult.isNotEmpty ? 'https:${regexResult}' : null;
}

String getGifUri(String kanji) {
  final unicodeString = kanji.codeUnitAt(0).toRadixString(16);
  final fileName = '${unicodeString}.gif';
  final animationUri = 'https://raw.githubusercontent.com/mistval/kanji_images/master/gifs/${fileName}';

  return animationUri;
}

int getNewspaperFrequencyRank(String pageHtml) {
  final frequencySection = getStringBetweenStrings(pageHtml, '<div class="frequency">', '</div>');
  return (frequencySection != null) ? int.parse(getStringBetweenStrings(frequencySection, '<strong>', '</strong>')) : null;
}

/// Parses a jisho kanji search page to an object
KanjiResult parseKanjiPageData(String pageHtml, String kanji) {
  final result = KanjiResult();
  result.query = kanji;
  result.found = containsKanjiGlyph(pageHtml, kanji);
  if (result.found==false) {
    return result;
  }

  result.taughtIn = getStringBetweenStrings(pageHtml, 'taught in <strong>', '</strong>');
  result.jlptLevel = getStringBetweenStrings(pageHtml, 'JLPT level <strong>', '</strong>');
  result.newspaperFrequencyRank = getNewspaperFrequencyRank(pageHtml);
  result.strokeCount = getIntBetweenStrings(pageHtml, '<strong>', '</strong> strokes');
  result.meaning = htmlUnescape.convert(removeNewlines(getStringBetweenStrings(pageHtml, '<div class="kanji-details__main-meanings">', '</div>')).trim());
  result.kunyomi = getKunyomi(pageHtml) ?? [];
  result.onyomi = getOnyomi(pageHtml) ?? [];
  result.onyomiExamples = getOnyomiExamples(pageHtml) ?? [];
  result.kunyomiExamples = getKunyomiExamples(pageHtml) ?? [];
  result.radical = getRadical(pageHtml);
  result.parts = getParts(pageHtml) ?? [];
  result.strokeOrderDiagramUri = getUriForStrokeOrderDiagram(kanji);
  result.strokeOrderSvgUri = getSvgUri(pageHtml);
  result.strokeOrderGifUri = getGifUri(kanji);
  result.uri = uriForKanjiSearch(kanji);
  return result;
}